Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36450 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753859AbdJIJuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 05:50:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 4/4] cfg80211: implement regdb signature checking
Date: Mon,  9 Oct 2017 11:50:18 +0200
Message-Id: <20171009095018.5289-5-johannes@sipsolutions.net> (sfid-20171009_115035_097870_1B470FEA)
In-Reply-To: <20171009095018.5289-1-johannes@sipsolutions.net>
References: <20171009095018.5289-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently CRDA implements the signature checking, and the previous
commits added the ability to load the whole regulatory database
into the kernel.

However, we really can't lose the signature checking, so implement
it in the kernel by loading a detached signature (regulatory.db.p7s)
and check it against built-in keys.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Kconfig             |  30 ++++++++++
 net/wireless/Makefile            |  22 +++++++
 net/wireless/certs/sforshee.x509 | Bin 0 -> 680 bytes
 net/wireless/reg.c               | 121 ++++++++++++++++++++++++++++++++++++++-
 net/wireless/reg.h               |   8 +++
 5 files changed, 180 insertions(+), 1 deletion(-)
 create mode 100644 net/wireless/certs/sforshee.x509

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index f050030055c5..da91bb547db3 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -83,6 +83,36 @@ config CFG80211_CERTIFICATION_ONUS
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
+config CFG80211_USE_KERNEL_REGDB_KEYS
+	bool "allow regdb keys shipped with the kernel" if CFG80211_CERTIFICATION_ONUS
+	default y
+	depends on CFG80211_REQUIRE_SIGNED_REGDB
+	help
+	  Allow the regulatory database to be signed by one of the keys for
+	  which certificates are part of the kernel sources
+	  (in net/wireless/certs/).
+
+	  This is currently only Seth Forshee's key, who is the regulatory
+	  database maintainer.
+
+config CFG80211_EXTRA_REGDB_KEYDIR
+	string "additional regdb key directory" if CFG80211_CERTIFICATION_ONUS
+	depends on CFG80211_REQUIRE_SIGNED_REGDB
+	help
+	  If selected, point to a directory with DER-encoded X.509
+	  certificates like in the kernel sources (net/wireless/certs/)
+	  that shall be accepted for a signed regulatory database.
+
 config CFG80211_REG_CELLULAR_HINTS
 	bool "cfg80211 regulatory support for cellular base station hints"
 	depends on CFG80211_CERTIFICATION_ONUS
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 5f20dac5d8c6..219baea57e4e 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -16,3 +16,25 @@ cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 
 CFLAGS_trace.o := -I$(src)
+
+cfg80211-$(CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS) += shipped-certs.o
+ifneq ($(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR),)
+cfg80211-y += extra-certs.o
+endif
+
+$(obj)/shipped-certs.c: $(wildcard $(srctree)/$(src)/certs/*.x509)
+	@echo "  GEN     $@"
+	@echo '#include "reg.h"' > $@
+	@echo 'const u8 shipped_regdb_certs[] = {' >> $@
+	@for f in $^ ; do hexdump -v -e '1/1 "0x%.2x," "\n"' < $$f >> $@ ; done
+	@echo '};' >> $@
+	@echo 'unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);' >> $@
+
+$(obj)/extra-certs.c: $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%) \
+		      $(wildcard $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%)/*.x509)
+	@echo "  GEN     $@"
+	@echo '#include "reg.h"' > $@
+	@echo 'const u8 extra_regdb_certs[] = {' >> $@
+	@for f in $^ ; do test -f $$f && hexdump -v -e '1/1 "0x%.2x," "\n"' < $$f >> $@ || true ; done
+	@echo '};' >> $@
+	@echo 'unsigned int extra_regdb_certs_len = sizeof(extra_regdb_certs);' >> $@
diff --git a/net/wireless/certs/sforshee.x509 b/net/wireless/certs/sforshee.x509
new file mode 100644
index 0000000000000000000000000000000000000000..c6f8f9d6b98839048822ebbe27ecb831614ccf3d
GIT binary patch
literal 680
zcmXqLVp?L*#Mr~c$*`&SzWchL=aw7rvT<s)d9;1!Wn|=LWiSvn6g1#xV-96u=HVz#
z%P%U<NKG|R5a%^CH#9IXGqf}@FgA^n;5RZfG&is`G=d6X*Ve?Sgls$`D+6;ABR>Ps
z1zb!`jEoFh9UjloXt8AeWO+SJ$I(J`P2JMwLe;tnH5qsF?QdR>w3uI$6?BMMOSdlV
zi`-_R0)^-+(~WEkyRD@;#6_|bkA!zm6O;L?a+RC&XNF+Q?^A(17hNT93Al9K{8zT}
zZ-TA_x5m^>y01EB?6?@F_#s&SBUAoMx7m~9H74+{G5eLFTo@kq?abx-wOTi&i(Oyu
zQg3}<RloFf!*K(%OTq8ntdV<e_|a_9oaAGv(e<jO84F)su49Oq6?a2H!l;~GQz%W&
ztoZqK7Dw}q8;i8REYwt}nO4cIec{Hv6FK&ie;<8U5hN%oUG?oz#?0rx-NafRA7A+F
z!6mn=50AtzNc(c@$p5LbOw5c7jL0Dbi~wK=F*39>-}=;a=<fO&7yY)&@jjD1cK%}*
z->vvvRoQQq5|7x<;&pS~YD#Y&_6&F5Z@hi_o39R~2i%lCEQp;`DZKFij>Y=beQfq8
zwmr$x_+%2JY;Sbn*;@WJ=R-@}i!U>_Zs%4CQ>mTLxstDKo_X|~T&9~nCjzn_MSd1z
zd$q}FYs9}@7aPN+-fyz#i1@bZh+cP;`je$EmYhnDSyPmLIA8d%u4(1<uIFE`C>nTO
z{kHgKW!NWvf$y~!0w?Rc|ETrmY6%tMs`ay$*Vg}|u{qP^VMD|2N9%W9Gx#VQ(ylyn
seju}tYb{f1@#??lr<~!nO89FdqAzB=Qc?bNz{Y;&cMH;1idBjL01XcsegFUf

literal 0
HcmV?d00001

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index bcccd1a905ef..6f2728137749 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -53,6 +53,7 @@
 #include <linux/ctype.h>
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
+#include <linux/verification.h>
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <net/cfg80211.h>
@@ -660,6 +661,115 @@ static bool valid_country(const u8 *data, unsigned int size,
 	return true;
 }
 
+#ifdef CONFIG_CFG80211_REQUIRE_SIGNED_REGDB
+static struct key *builtin_regdb_keys;
+
+static void __init load_keys_from_buffer(const u8 *p, unsigned int buflen)
+{
+	const u8 *end = p + buflen;
+	size_t plen;
+	key_ref_t key;
+
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
+					   "asymmetric", NULL, p, plen,
+					   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					    KEY_USR_VIEW | KEY_USR_READ),
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
+	return;
+
+dodgy_cert:
+	pr_err("Problem parsing in-kernel X.509 certificate list\n");
+}
+
+static int __init load_builtin_regdb_keys(void)
+{
+	builtin_regdb_keys =
+		keyring_alloc(".builtin_regdb_keys",
+			      KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
+			      ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			      KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
+			      KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
+	if (IS_ERR(builtin_regdb_keys))
+		return PTR_ERR(builtin_regdb_keys);
+
+	pr_notice("Loading compiled-in X.509 certificates for regulatory database\n");
+
+#ifdef CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS
+	load_keys_from_buffer(shipped_regdb_certs, shipped_regdb_certs_len);
+#endif
+#ifdef CFG80211_EXTRA_REGDB_KEYDIR
+	if (CONFIG_CFG80211_EXTRA_REGDB_KEYDIR[0] != '\0')
+		load_keys_from_buffer(extra_regdb_certs, extra_regdb_certs_len);
+#endif
+
+	return 0;
+}
+
+static bool regdb_has_valid_signature(const u8 *data, unsigned int size)
+{
+	const struct firmware *sig;
+	bool result;
+
+	if (request_firmware(&sig, "regulatory.db.p7s", &reg_pdev->dev))
+		return false;
+
+	result = verify_pkcs7_signature(data, size, sig->data, sig->size,
+					builtin_regdb_keys,
+					VERIFYING_UNSPECIFIED_SIGNATURE,
+					NULL, NULL) == 0;
+
+	release_firmware(sig);
+
+	return result;
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
+static bool regdb_has_valid_signature(const u8 *data, unsigned int size)
+{
+	return true;
+}
+
+static void free_regdb_keyring(void)
+{
+}
+#endif /* CONFIG_CFG80211_REQUIRE_SIGNED_REGDB */
+
 static bool valid_regdb(const u8 *data, unsigned int size)
 {
 	const struct fwdb_header *hdr = (void *)data;
@@ -674,6 +784,9 @@ static bool valid_regdb(const u8 *data, unsigned int size)
 	if (hdr->version != cpu_to_be32(FWDB_VERSION))
 		return false;
 
+	if (!regdb_has_valid_signature(data, size))
+		return false;
+
 	country = &hdr->country[0];
 	while ((u8 *)(country + 1) <= data + size) {
 		if (!country->coll_ptr)
@@ -775,7 +888,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 		if (fwregdb_attempts-- == 0)
 			set_error = -ENODATA;
 	} else if (!valid_regdb(fw->data, fw->size)) {
-		pr_info("loaded regulatory.db is malformed\n");
+		pr_info("loaded regulatory.db is malformed or signature is missing/invalid\n");
 		set_error = -EINVAL;
 	}
 
@@ -3537,6 +3650,10 @@ int __init regulatory_init(void)
 {
 	int err = 0;
 
+	err = load_builtin_regdb_keys();
+	if (err)
+		return err;
+
 	reg_pdev = platform_device_register_simple("regulatory", 0, NULL, 0);
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
@@ -3613,4 +3730,6 @@ void regulatory_exit(void)
 
 	if (!IS_ERR_OR_NULL(regdb))
 		kfree(regdb);
+
+	free_regdb_keyring();
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 9529c522611a..9ceeb5f3a7cb 100644
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
@@ -185,4 +188,9 @@ bool reg_dfs_domain_same(struct wiphy *wiphy1, struct wiphy *wiphy2);
  */
 int reg_reload_regdb(void);
 
+extern const u8 shipped_regdb_certs[];
+extern unsigned int shipped_regdb_certs_len;
+extern const u8 extra_regdb_certs[];
+extern unsigned int extra_regdb_certs_len;
+
 #endif  /* __NET_WIRELESS_REG_H */
-- 
2.14.2
