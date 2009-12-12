Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39693 "HELO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932216AbZLMCYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 21:24:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC 1/2] wireless: support internal statically compiled regulatory database
Date: Sat, 12 Dec 2009 16:42:42 -0500
Message-Id: <1260654163-11214-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch provides infrastructure for machine translation of the
regulatory rules database used by CRDA into a C data structure.
It includes code for searching that database as an alternative
to dynamic regulatory rules updates via CRDA.  Most people should
use CRDA instead of this infrastructure, but it provides a better
alternative than the WIRELESS_OLD_REGULATORY infrastructure (which
can now be removed).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 Documentation/networking/regulatory.txt |   24 +++++++
 net/wireless/.gitignore                 |    1 +
 net/wireless/Kconfig                    |   16 +++++
 net/wireless/Makefile                   |    6 ++
 net/wireless/db.txt                     |   17 +++++
 net/wireless/genregdb.awk               |  101 +++++++++++++++++++++++++++++++
 net/wireless/reg.c                      |   77 +++++++++++++++++++++++
 net/wireless/regdb.h                    |    7 ++
 8 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 net/wireless/.gitignore
 create mode 100644 net/wireless/db.txt
 create mode 100644 net/wireless/genregdb.awk
 create mode 100644 net/wireless/regdb.h

diff --git a/Documentation/networking/regulatory.txt b/Documentation/networking/regulatory.txt
index ee31369..9551622 100644
--- a/Documentation/networking/regulatory.txt
+++ b/Documentation/networking/regulatory.txt
@@ -188,3 +188,27 @@ Then in some part of your code after your wiphy has been registered:
 		       &mydriver_jp_regdom.reg_rules[i],
 		       sizeof(struct ieee80211_reg_rule));
 	regulatory_struct_hint(rd);
+
+Statically compiled regulatory database
+---------------------------------------
+
+In most situations the userland solution using CRDA as described
+above is the preferred solution.  However in some cases a set of
+rules built into the kernel itself may be desirable.  To account
+for this situation, a configuration option has been provided
+(i.e. CONFIG_CFG80211_INTERNAL_REGDB).  With this option enabled,
+the wireless database information contained in net/wireless/db.txt is
+used to generate a data structure encoded in net/wireless/regdb.c.
+That option also enables code in net/wireless/reg.c which queries
+the data in regdb.c as an alternative to using CRDA.
+
+The file net/wireless/db.txt should be kept up-to-date with the db.txt
+file available in the git repository here:
+
+    git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
+
+Again, most users in most situations should be using the CRDA package
+provided with their distribution, and in most other situations users
+should be building and using CRDA on their own rather than using
+this option.  If you are not absolutely sure that you should be using
+CONFIG_CFG80211_INTERNAL_REGDB then _DO_NOT_USE_IT_.
diff --git a/net/wireless/.gitignore b/net/wireless/.gitignore
new file mode 100644
index 0000000..c33451b
--- /dev/null
+++ b/net/wireless/.gitignore
@@ -0,0 +1 @@
+regdb.c
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 90e93a5..b1bd151 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -109,6 +109,22 @@ config WIRELESS_OLD_REGULATORY
 
 	  Say N and if you say Y, please tell us why. The default is N.
 
+config CFG80211_INTERNAL_REGDB
+	bool "Statically compiled regulatory rules database"
+	default n
+	depends on CFG80211
+	---help---
+	  This option generates an internal data structure representing
+	  the wireless regulatory rules described in net/wireless/db.txt
+	  and includes code to query that database.  This is an alternative
+	  to using CRDA for defining regulatory rules for the kernel.
+
+	  For details see:
+
+	  http://wireless.kernel.org/en/developers/Regulatory
+
+	  Most distributions have a CRDA package.  So if unsure, say N.
+
 config CFG80211_WEXT
 	bool "cfg80211 wireless extensions compatibility"
 	depends on CFG80211
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index f07c8dc..62639e6 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -13,5 +13,11 @@ cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
 cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
+cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
 
 ccflags-y += -D__CHECK_ENDIAN__
+
+$(obj)/regdb.c: $(src)/db.txt $(src)/genregdb.awk
+	@cat $< | $(AWK) -f $(src)/genregdb.awk > $@
+
+clean-files := regdb.c
diff --git a/net/wireless/db.txt b/net/wireless/db.txt
new file mode 100644
index 0000000..4a772fa
--- /dev/null
+++ b/net/wireless/db.txt
@@ -0,0 +1,17 @@
+#
+# This file is a placeholder to prevert accidental build breakage if someone
+# enables CONFIG_CFG80211_INTERNAL_REGDB.  Almost no one actually needs to
+# enable that build option.
+#
+# You should be using CRDA instead.  It is even better if you use the CRDA
+# package provided by your distribution, since they will probably keep it
+# up-to-date on your behalf.
+#
+# If you _really_ intend to use CONFIG_CFG80211_INTERNAL_REGDB then you will
+# need to replace this file with one containing appropriately formatted
+# regulatory rules that cover the regulatory domains you will be using.  Your
+# best option is to extract the db.txt file from the wireless-regdb git
+# repository:
+#
+#   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
+#
diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
new file mode 100644
index 0000000..91059e2
--- /dev/null
+++ b/net/wireless/genregdb.awk
@@ -0,0 +1,101 @@
+#!/usr/bin/awk -f
+BEGIN {
+	active = 0
+	rule = 0;
+	print "#include <linux/nl80211.h>"
+	print "#include <net/cfg80211.h>"
+	print
+	regdb = "const struct ieee80211_regdomain *reg_regdb[] = {\n"
+}
+
+/^[ \t]*#/ {
+	/* Ignore */
+}
+
+!active && /^[ \t]*$/ {
+	/* Ignore */
+}
+
+!active && /country/ {
+	country=$2
+	sub(/:/, "", country)
+	printf "static const struct ieee80211_regdomain regdom_%s = {\n", country
+	printf "\t.alpha2 = \"%s\",\n", country
+	printf "\t.reg_rules = {\n"
+	active = 1
+	regdb = regdb "\t&regdom_" country ",\n"
+}
+
+active && /^[ \t]*\(/ {
+	start = $1
+	sub(/\(/, "", start)
+	end = $3
+	bw = $5
+	sub(/\),/, "", bw)
+	gain = $6
+	sub(/\(/, "", gain)
+	sub(/,/, "", gain)
+	power = $7
+	sub(/\)/, "", power)
+	sub(/,/, "", power)
+	# power might be in mW...
+	units = $8
+	sub(/\)/, "", units)
+	sub(/,/, "", units)
+	if (units == "mW") {
+		if (power == 100) {
+			power = 20
+		} else if (power == 200) {
+			power = 23
+		} else if (power == 500) {
+			power = 27
+		} else if (power == 1000) {
+			power = 30
+		} else {
+			print "Unknown power value in database!"
+		}
+	}
+	flagstr = ""
+	for (i=8; i<=NF; i++)
+		flagstr = flagstr $i
+	split(flagstr, flagarray, ",")
+	flags = ""
+	for (arg in flagarray) {
+		if (flagarray[arg] == "NO-OFDM") {
+			flags = flags "\n\t\t\tNL80211_RRF_NO_OFDM | "
+		} else if (flagarray[arg] == "NO-CCK") {
+			flags = flags "\n\t\t\tNL80211_RRF_NO_CCK | "
+		} else if (flagarray[arg] == "NO-INDOOR") {
+			flags = flags "\n\t\t\tNL80211_RRF_NO_INDOOR | "
+		} else if (flagarray[arg] == "NO-OUTDOOR") {
+			flags = flags "\n\t\t\tNL80211_RRF_NO_OUTDOOR | "
+		} else if (flagarray[arg] == "DFS") {
+			flags = flags "\n\t\t\tNL80211_RRF_DFS | "
+		} else if (flagarray[arg] == "PTP-ONLY") {
+			flags = flags "\n\t\t\tNL80211_RRF_PTP_ONLY | "
+		} else if (flagarray[arg] == "PTMP-ONLY") {
+			flags = flags "\n\t\t\tNL80211_RRF_PTMP_ONLY | "
+		} else if (flagarray[arg] == "PASSIVE-SCAN") {
+			flags = flags "\n\t\t\tNL80211_RRF_PASSIVE_SCAN | "
+		} else if (flagarray[arg] == "NO-IBSS") {
+			flags = flags "\n\t\t\tNL80211_RRF_NO_IBSS | "
+		}
+	}
+	flags = flags "0"
+	printf "\t\tREG_RULE(%d, %d, %d, %d, %d, %s),\n", start, end, bw, gain, power, flags
+	rules++
+}
+
+active && /^[ \t]*$/ {
+	active = 0
+	printf "\t},\n"
+	printf "\t.n_reg_rules = %d\n", rules
+	printf "};\n\n"
+	rules = 0;
+}
+
+END {
+	print regdb "};"
+	print ""
+	print "int reg_regdb_size = ARRAY_SIZE(reg_regdb);"
+}
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index baa898a..41b2373 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -40,6 +40,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "reg.h"
+#include "regdb.h"
 #include "nl80211.h"
 
 /* Receipt of information from last regulatory request */
@@ -335,6 +336,8 @@ static bool country_ie_integrity_changes(u32 checksum)
 	return false;
 }
 
+static int reg_regdb_query(const char *alpha2);
+
 /*
  * This lets us keep regulatory code which is updated on a regulatory
  * basis in userspace.
@@ -354,6 +357,10 @@ static int call_crda(const char *alpha2)
 		printk(KERN_INFO "cfg80211: Calling CRDA to update world "
 			"regulatory domain\n");
 
+#ifdef CONFIG_CFG80211_INTERNAL_REGDB
+	reg_regdb_query(alpha2);
+#endif
+
 	country_env[8] = alpha2[0];
 	country_env[9] = alpha2[1];
 
@@ -2205,6 +2212,76 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	return r;
 }
 
+#ifdef CONFIG_CFG80211_INTERNAL_REGDB
+
+struct reg_regdb_search_request {
+	char alpha2[2];
+	struct list_head list;
+};
+
+static LIST_HEAD(reg_regdb_search_list);
+static DEFINE_SPINLOCK(reg_regdb_search_lock);
+
+static void reg_regdb_search(struct work_struct *work)
+{
+	struct reg_regdb_search_request *request;
+	const struct ieee80211_regdomain *curdom, *regdom;
+	int i, r;
+
+	spin_lock(&reg_regdb_search_lock);
+	while (!list_empty(&reg_regdb_search_list)) {
+		request = list_first_entry(&reg_regdb_search_list,
+					   struct reg_regdb_search_request,
+					   list);
+		list_del(&request->list);
+
+		for (i=0; i<reg_regdb_size; i++) {
+			curdom = reg_regdb[i];
+
+			if (!memcmp(request->alpha2, curdom->alpha2, 2)) {
+				r = reg_copy_regd(&regdom, curdom);
+				if (r)
+					break;
+				spin_unlock(&reg_regdb_search_lock);
+				mutex_lock(&cfg80211_mutex);
+				set_regdom(regdom);
+				mutex_unlock(&cfg80211_mutex);
+				spin_lock(&reg_regdb_search_lock);
+				break;
+			}
+		}
+
+		kfree(request);
+	}
+	spin_unlock(&reg_regdb_search_lock);
+}
+
+static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
+
+static int reg_regdb_query(const char *alpha2)
+{
+	struct reg_regdb_search_request *request;
+
+	if (!alpha2)
+		return -EINVAL;
+
+	request = kzalloc(sizeof(struct reg_regdb_search_request), GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	memcpy(request->alpha2, alpha2, 2);
+
+	spin_lock(&reg_regdb_search_lock);
+	list_add_tail(&request->list, &reg_regdb_search_list);
+	spin_unlock(&reg_regdb_search_lock);
+
+	schedule_work(&reg_regdb_work);
+
+	return 0;
+}
+
+#endif /* CONFIG_CFG80211_INTERNAL_REGDB */
+
 /* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
diff --git a/net/wireless/regdb.h b/net/wireless/regdb.h
new file mode 100644
index 0000000..818222c
--- /dev/null
+++ b/net/wireless/regdb.h
@@ -0,0 +1,7 @@
+#ifndef __REGDB_H__
+#define __REGDB_H__
+
+extern const struct ieee80211_regdomain *reg_regdb[];
+extern int reg_regdb_size;
+
+#endif /* __REGDB_H__ */
-- 
1.6.5.2

