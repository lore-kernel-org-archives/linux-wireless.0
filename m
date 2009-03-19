Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZCSF5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 01:57:22 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: add support to print HT40-/+ on channels
Date: Thu, 19 Mar 2009 01:57:21 -0400
Message-Id: <1237442241-29803-1-git-send-email-lrodriguez@atheros.com> (sfid-20090319_065724_503610_39D0E7A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You don't have to guess now if your channels support HT40-/+ now.
This also helps with regulatory testing.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 info.c    |   13 +++++++++++++
 nl80211.h |   21 +++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/info.c b/info.c
index f704131..14c88a3 100644
--- a/info.c
+++ b/info.c
@@ -55,6 +55,9 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 		[NL80211_FREQUENCY_ATTR_RADAR] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] = { .type = NLA_U32 },
 		[NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH] = { .type = NLA_U32 },
+		[NL80211_FREQUENCY_ATTR_NO_HT40] = { .type = NLA_FLAG },
+		[NL80211_FREQUENCY_ATTR_NO_HT40MINUS] = { .type = NLA_FLAG },
+		[NL80211_FREQUENCY_ATTR_NO_HT40PLUS] = { .type = NLA_FLAG },
 	};
 
 	struct nlattr *tb_rate[NL80211_BITRATE_ATTR_MAX + 1];
@@ -70,6 +73,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 	int bandidx = 1;
 	int rem_band, rem_freq, rem_rate, rem_mode;
 	int open;
+	bool ht_supported_by_dev = false;
 
 	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -90,6 +94,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 #ifdef NL80211_BAND_ATTR_HT_CAPA
 		if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
 			unsigned short cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
+			ht_supported_by_dev = true;
 #define PCOM(fmt, args...) do { printf("\t\t\t* " fmt "\n", ##args); } while (0)
 #define PBCOM(bit, args...) if (cap & (bit)) PCOM(args)
 			printf("\t\tHT capabilities: 0x%.4x\n", cap);
@@ -231,6 +236,14 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 				print_flag("no IBSS", &open);
 			if (tb_freq[NL80211_FREQUENCY_ATTR_RADAR])
 				print_flag("radar detection", &open);
+			if (ht_supported_by_dev) {
+				if (tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40])
+					print_flag("HT40 disallowed", &open);
+				else if (tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40MINUS])
+					print_flag("HT40- disallowed", &open);
+				else if (tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40PLUS])
+					print_flag("HT40+ disallowed", &open);
+			}
  next:
 			if (open)
 				printf(")");
diff --git a/nl80211.h b/nl80211.h
index 9118460..f00ebff 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -349,6 +349,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_REG_TYPE: indicates the type of the regulatory domain currently
  * 	set. This can be one of the nl80211_reg_type (%NL80211_REGDOM_TYPE_*)
  *
+ * @NL80211_ATTR_SUPPORTED_COMMANDS: wiphy attribute that specifies
+ *	an array of command numbers (i.e. a mapping index to command number)
+ *	that the driver for the given wiphy supports.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -426,6 +430,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_REG_INITIATOR,
 	NL80211_ATTR_REG_TYPE,
 
+	NL80211_ATTR_SUPPORTED_COMMANDS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -665,6 +671,15 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
  *	(100 * dBm).
  * @NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH: max bandwidth allowed, given in MHz
+ * @NL80211_FREQUENCY_ATTR_NOHT40: HT40 operation is not permitted on
+ * 	this channel, this is would indicate the regulatory domain did
+ * 	not allow for HT40 operation.
+ * @NL80211_FREQUENCY_ATTR_NO_HT40MINUS: HT40- operation is not permitted on
+ * 	this channel. This could be due to regulatory domain restrictions or
+ * 	when the channel is on a band edge, towards the beginning.
+ * @NL80211_FREQUENCY_ATTR_NO_HT40PLUS: HT40+ operation is not permitted on
+ * 	this channel. This could be due to regulatory domain restrictions or
+ * 	when the channel is on a band edge, towards the end.
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -675,6 +690,9 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 	NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH,
+	NL80211_FREQUENCY_ATTR_NO_HT40,
+	NL80211_FREQUENCY_ATTR_NO_HT40MINUS,
+	NL80211_FREQUENCY_ATTR_NO_HT40PLUS,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -683,6 +701,9 @@ enum nl80211_frequency_attr {
 
 #define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
 #define NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH
+#define NL80211_FREQUENCY_ATTR_NO_HT40 NL80211_FREQUENCY_ATTR_NO_HT40
+#define NL80211_FREQUENCY_ATTR_NO_HT40MINUS NL80211_FREQUENCY_ATTR_NO_HT40MINUS
+#define NL80211_FREQUENCY_ATTR_NO_HT40PLUS NL80211_FREQUENCY_ATTR_NO_HT40PLUS
 
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
-- 
1.6.0.6

