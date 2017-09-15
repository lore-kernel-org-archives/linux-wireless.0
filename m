Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37234 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbdIOKSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 06:18:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 4/4] cfg80211: implement regdb signature checking
Date: Fri, 15 Sep 2017 12:18:10 +0200
Message-Id: <20170915101810.11435-5-johannes@sipsolutions.net> (sfid-20170915_121820_023097_633FD9F9)
In-Reply-To: <20170915101810.11435-1-johannes@sipsolutions.net>
References: <20170915101810.11435-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently CRDA implements the signature checking, and the previous
commits added the ability to load the whole regulatory database
into the kernel.

However, we really can't lose the signature checking, so implement
it in the kernel by loading a detached signature (regulatory.db.p7s)
and check it against built-in keys.

TODO
 - add a Kconfig option to specify extra keys, rather than requiring
   them to be dropped into the right directory
 - should anything be able to modify the keyring? I guess not?
 - add Seth's key, obviously

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Kconfig         |  10 ++++
 net/wireless/Makefile        |  10 ++++
 net/wireless/certs/none.x509 |   0
 net/wireless/reg.c           | 109 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.h           |   6 +++
 5 files changed, 135 insertions(+)
 create mode 100644 net/wireless/certs/none.x509

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index f050030055c5..8ac8fda93cfe 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -83,6 +83,16 @@ config CFG80211_CERTIFICATION_ONUS
 	  you are a wireless researcher and are working in a controlled
 	  and approved environment by your local regulatory agency.
 
+config CFG80211_REQUIRE_SIGNED_REGDB
+	bool "require regdb signature" if CFG80211_CERTIFICATION_ONUS
+	default y
+	select SYSTEM_DATA_VERIFICATION
+	help
+	  Require that in addition to the "regulatory.db" file a
+	  "regulatory.db.p7s" can be loaded with a valid PKCS#7
+	  signature for the regulatory.db file made by one of the
+	  keys in the certs/ directory.
+
 config CFG80211_REG_CELLULAR_HINTS
 	bool "cfg80211 regulatory support for cellular base station hints"
 	depends on CFG80211_CERTIFICATION_ONUS
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 5f20dac5d8c6..20994876d42a 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -16,3 +16,13 @@ cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 
 CFLAGS_trace.o := -I$(src)
+
+cfg80211-$(CONFIG_CFG80211_REQUIRE_SIGNED_REGDB) += certs.o
+
+$(obj)/certs.c: $(wildcard $(srctree)/$(src)/certs/*.x509)
+	@echo "  GEN     $@"
+	@echo '#include "reg.h"' > $@
+	@echo 'const u8 regdb_certs[] = {' >> $@
+	@hexdump -v -e '1/1 "0x%.2x," "\n"' < $< >> $@
+	@echo '};' >> $@
+	@echo 'unsigned int regdb_certs_len = sizeof(regdb_certs);' >> $@
diff --git a/net/wireless/certs/none.x509 b/net/wireless/certs/none.x509
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5dd453bdad3a..2a04118c500a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -52,6 +52,7 @@
 #include <linux/ctype.h>
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
+#include <linux/verification.h>
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <net/cfg80211.h>
@@ -652,6 +653,105 @@ static bool valid_country(const struct firmware *db,
 	return true;
 }
 
+#ifdef CONFIG_CFG80211_REQUIRE_SIGNED_REGDB
+static struct key *builtin_regdb_keys;
+
+static int load_builtin_regdb_keys(void)
+{
+	key_ref_t key;
+	const u8 *p, *end;
+	size_t plen;
+
+	builtin_regdb_keys =
+		keyring_alloc(".builtin_regdb_keys",
+			      KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
+			      ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			      KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
+			      KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
+	if (IS_ERR(builtin_regdb_keys))
+		return PTR_ERR(builtin_regdb_keys);
+
+	pr_notice("Loading compiled-in X.509 certificates\n");
+
+	p = regdb_certs;
+	end = p + regdb_certs_len;
+	while (p < end) {
+		/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
+		 * than 256 bytes in size.
+		 */
+		if (end - p < 4)
+			goto dodgy_cert;
+		if (p[0] != 0x30 &&
+		    p[1] != 0x82)
+			goto dodgy_cert;
+		plen = (p[2] << 8) | p[3];
+		plen += 4;
+		if (plen > end - p)
+			goto dodgy_cert;
+
+		key = key_create_or_update(make_key_ref(builtin_regdb_keys, 1),
+					   "asymmetric",
+					   NULL,
+					   p,
+					   plen,
+					   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					   KEY_USR_VIEW | KEY_USR_READ),
+					   KEY_ALLOC_NOT_IN_QUOTA |
+					   KEY_ALLOC_BUILT_IN |
+					   KEY_ALLOC_BYPASS_RESTRICTION);
+		if (IS_ERR(key)) {
+			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
+			       PTR_ERR(key));
+		} else {
+			pr_notice("Loaded X.509 cert '%s'\n",
+				  key_ref_to_ptr(key)->description);
+			key_ref_put(key);
+		}
+		p += plen;
+	}
+
+	return 0;
+
+dodgy_cert:
+	pr_err("Problem parsing in-kernel X.509 certificate list\n");
+	return 0;
+}
+
+static bool regdb_has_valid_signature(const struct firmware *db)
+{
+	const struct firmware *sig;
+
+	if (request_firmware(&sig, "regulatory.db.p7s", &reg_pdev->dev))
+		return false;
+
+	if (verify_pkcs7_signature(db->data, db->size, sig->data, sig->size,
+				   builtin_regdb_keys,
+				   VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL))
+		return false;
+
+	return true;
+}
+
+static void free_regdb_keyring(void)
+{
+	key_put(builtin_regdb_keys);
+}
+#else
+static int load_builtin_regdb_keys(void)
+{
+	return 0;
+}
+
+static bool regdb_has_valid_signature(const struct firmware *db)
+{
+	return true;
+}
+
+static void free_regdb_keyring(void)
+{
+}
+#endif /* CONFIG_CFG80211_REQUIRE_SIGNED_REGDB */
+
 static bool valid_regdb(const struct firmware *db)
 {
 	const struct fwdb_header *hdr = (void *)db->data;
@@ -666,6 +766,9 @@ static bool valid_regdb(const struct firmware *db)
 	if (hdr->version != cpu_to_be32(FWDB_VERSION))
 		return false;
 
+	if (!regdb_has_valid_signature(db))
+		return false;
+
 	country = &hdr->country[0];
 	while ((u8 *)(country + 1) <= db->data + db->size) {
 		if (!country->coll_ptr)
@@ -3505,6 +3608,10 @@ int __init regulatory_init(void)
 {
 	int err = 0;
 
+	err = load_builtin_regdb_keys();
+	if (err)
+		return err;
+
 	reg_pdev = platform_device_register_simple("regulatory", 0, NULL, 0);
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
@@ -3581,4 +3688,6 @@ void regulatory_exit(void)
 
 	if (!IS_ERR_OR_NULL(regdb))
 		release_firmware(rcu_access_pointer(regdb));
+
+	free_regdb_keyring();
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 9529c522611a..a520a8261d1a 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -1,5 +1,8 @@
 #ifndef __NET_WIRELESS_REG_H
 #define __NET_WIRELESS_REG_H
+
+#include <net/cfg80211.h>
+
 /*
  * Copyright 2008-2011	Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
  *
@@ -185,4 +188,7 @@ bool reg_dfs_domain_same(struct wiphy *wiphy1, struct wiphy *wiphy2);
  */
 int reg_reload_regdb(void);
 
+extern const u8 regdb_certs[];
+extern unsigned int regdb_certs_len;
+
 #endif  /* __NET_WIRELESS_REG_H */
-- 
2.14.1
