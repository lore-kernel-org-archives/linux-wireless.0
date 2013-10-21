Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:60926 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3JURWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:22:47 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so6680696wes.8
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:22:44 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 01/14] cfg80211: consolidate passive-scan and no-ibss flags
Date: Mon, 21 Oct 2013 19:22:25 +0200
Message-Id: <1382376158-25586-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192249_840178_EE95D475)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two flags are used for the same purpose, just
combine them into a no-ir flag to annotate no initiating
radiation is allowed.

The way we deal with the consolidation is we rename
the passive scan flag to no-ir, and redefine no-ibss
to the no-ir flag. Old userspace sending us the no-ibss
flag will now be treated in-kernel as a no-ir flag. If
a channel has the no-ir flag we will send userspace both
the no-ir flag and the no-ibss flag to help with older
userspace. New userspace can just upgrade to treat only
the no-ir flag as when one will be populated the other
will be too.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 Documentation/networking/regulatory.txt |  4 ++--
 include/net/cfg80211.h                  | 12 +++++++-----
 include/uapi/linux/nl80211.h            | 30 ++++++++++++++++++++----------
 net/wireless/chan.c                     |  3 +--
 net/wireless/genregdb.awk               |  7 +++++--
 net/wireless/ibss.c                     |  4 ++--
 net/wireless/mesh.c                     |  3 +--
 net/wireless/nl80211.c                  | 12 ++++++------
 net/wireless/reg.c                      | 33 ++++++++++-----------------------
 9 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/Documentation/networking/regulatory.txt b/Documentation/networking/regulatory.txt
index 9551622..356f791 100644
--- a/Documentation/networking/regulatory.txt
+++ b/Documentation/networking/regulatory.txt
@@ -159,10 +159,10 @@ struct ieee80211_regdomain mydriver_jp_regdom = {
 		REG_RULE(2412-20, 2484+20, 40, 6, 20, 0),
 		/* IEEE 802.11a, channels 34..48 */
 		REG_RULE(5170-20, 5240+20, 40, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN),
+			NL80211_RRF_NO_IR),
 		/* IEEE 802.11a, channels 52..64 */
 		REG_RULE(5260-20, 5320+20, 40, 6, 20,
-			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_NO_IR|
 			NL80211_RRF_DFS),
 	}
 };
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 419202c..45eb9aa 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -91,9 +91,8 @@ enum ieee80211_band {
  * Channel flags set by the regulatory control code.
  *
  * @IEEE80211_CHAN_DISABLED: This channel is disabled.
- * @IEEE80211_CHAN_PASSIVE_SCAN: Only passive scanning is permitted
- *	on this channel.
- * @IEEE80211_CHAN_NO_IBSS: IBSS is not allowed on this channel.
+ * @IEEE80211_CHAN_NO_IR: do not initiate radiation, this includes
+ * 	sending probe requests or beaconing.
  * @IEEE80211_CHAN_RADAR: Radar detection is required on this channel.
  * @IEEE80211_CHAN_NO_HT40PLUS: extension channel above this channel
  * 	is not permitted.
@@ -113,8 +112,8 @@ enum ieee80211_band {
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
-	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
-	IEEE80211_CHAN_NO_IBSS		= 1<<2,
+	IEEE80211_CHAN_NO_IR		= 1<<1,
+	/* hole at 1<<2 */
 	IEEE80211_CHAN_RADAR		= 1<<3,
 	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
 	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
@@ -123,6 +122,9 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
 };
 
+#define IEEE80211_CHAN_PASSIVE_SCAN	IEEE80211_CHAN_NO_IR
+#define IEEE80211_CHAN_NO_IBSS		IEEE80211_CHAN_NO_IR
+
 #define IEEE80211_CHAN_NO_HT40 \
 	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6ab79ea..64d0096 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2206,10 +2206,9 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_FREQ: Frequency in MHz
  * @NL80211_FREQUENCY_ATTR_DISABLED: Channel is disabled in current
  *	regulatory domain.
- * @NL80211_FREQUENCY_ATTR_PASSIVE_SCAN: Only passive scanning is
- *	permitted on this channel in current regulatory domain.
- * @NL80211_FREQUENCY_ATTR_NO_IBSS: IBSS networks are not permitted
- *	on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_NO_IR: no mechanisms that initiate radiation
+ * 	are permitted on this channel, this includes sending probe
+ * 	requests, or modes of operation that require beaconing.
  * @NL80211_FREQUENCY_ATTR_RADAR: Radar detection is mandatory
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
@@ -2236,8 +2235,8 @@ enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
 	NL80211_FREQUENCY_ATTR_FREQ,
 	NL80211_FREQUENCY_ATTR_DISABLED,
-	NL80211_FREQUENCY_ATTR_PASSIVE_SCAN,
-	NL80211_FREQUENCY_ATTR_NO_IBSS,
+	NL80211_FREQUENCY_ATTR_NO_IR,
+	__NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 	NL80211_FREQUENCY_ATTR_DFS_STATE,
@@ -2253,6 +2252,9 @@ enum nl80211_frequency_attr {
 };
 
 #define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
+#define NL80211_FREQUENCY_ATTR_PASSIVE_SCAN	NL80211_FREQUENCY_ATTR_NO_IR
+#define NL80211_FREQUENCY_ATTR_NO_IBSS		NL80211_FREQUENCY_ATTR_NO_IR
+#define NL80211_FREQUENCY_ATTR_NO_IR		NL80211_FREQUENCY_ATTR_NO_IR
 
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
@@ -2395,8 +2397,9 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_DFS: DFS support is required to be used
  * @NL80211_RRF_PTP_ONLY: this is only for Point To Point links
  * @NL80211_RRF_PTMP_ONLY: this is only for Point To Multi Point links
- * @NL80211_RRF_PASSIVE_SCAN: passive scan is required
- * @NL80211_RRF_NO_IBSS: no IBSS is allowed
+ * @NL80211_RRF_NO_IR: no mechanisms that initiate radiation are allowed,
+ * 	this includes probe requests or modes of operation that require
+ * 	beaconing.
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2406,10 +2409,17 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_DFS			= 1<<4,
 	NL80211_RRF_PTP_ONLY		= 1<<5,
 	NL80211_RRF_PTMP_ONLY		= 1<<6,
-	NL80211_RRF_PASSIVE_SCAN	= 1<<7,
-	NL80211_RRF_NO_IBSS		= 1<<8,
+	NL80211_RRF_NO_IR		= 1<<7,
+	__NL80211_RRF_NO_IBSS		= 1<<8,
 };
 
+#define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
+#define NL80211_RRF_NO_IBSS		NL80211_RRF_NO_IR
+#define NL80211_RRF_NO_IR		NL80211_RRF_NO_IR
+
+/* For backport compatibility with older userspace */
+#define NL80211_RRF_NO_IR_ALL		(NL80211_RRF_NO_IR | __NL80211_RRF_NO_IBSS)
+
 /**
  * enum nl80211_dfs_regions - regulatory DFS regions
  *
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 16f3c3a..82aa71fd 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -467,8 +467,7 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 
 	res = cfg80211_chandef_usable(wiphy, chandef,
 				      IEEE80211_CHAN_DISABLED |
-				      IEEE80211_CHAN_PASSIVE_SCAN |
-				      IEEE80211_CHAN_NO_IBSS |
+				      IEEE80211_CHAN_NO_IR |
 				      IEEE80211_CHAN_RADAR);
 
 	trace_cfg80211_return_bool(res);
diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 42ed274..c808619 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -107,10 +107,13 @@ active && /^[ \t]*\(/ {
 		} else if (flagarray[arg] == "PTMP-ONLY") {
 			flags = flags "\n\t\t\tNL80211_RRF_PTMP_ONLY | "
 		} else if (flagarray[arg] == "PASSIVE-SCAN") {
-			flags = flags "\n\t\t\tNL80211_RRF_PASSIVE_SCAN | "
+			flags = flags "\n\t\t\tNL80211_RRF_NO_IR | "
 		} else if (flagarray[arg] == "NO-IBSS") {
-			flags = flags "\n\t\t\tNL80211_RRF_NO_IBSS | "
+			flags = flags "\n\t\t\tNL80211_RRF_NO_IR | "
+		} else if (flagarray[arg] == "NO-IR") {
+			flags = flags "\n\t\t\tNL80211_RRF_NO_IR | "
 		}
+
 	}
 	flags = flags "0"
 	printf "\t\tREG_RULE(%d, %d, %d, %d, %d, %s),\n", start, end, bw, gain, power, flags
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 403fe29..fc47c62 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -258,7 +258,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 
 			for (i = 0; i < sband->n_channels; i++) {
 				chan = &sband->channels[i];
-				if (chan->flags & IEEE80211_CHAN_NO_IBSS)
+				if (chan->flags & IEEE80211_CHAN_NO_IR)
 					continue;
 				if (chan->flags & IEEE80211_CHAN_DISABLED)
 					continue;
@@ -329,7 +329,7 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 		chan = ieee80211_get_channel(wdev->wiphy, freq);
 		if (!chan)
 			return -EINVAL;
-		if (chan->flags & IEEE80211_CHAN_NO_IBSS ||
+		if (chan->flags & IEEE80211_CHAN_NO_IR ||
 		    chan->flags & IEEE80211_CHAN_DISABLED)
 			return -EINVAL;
 	}
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0553fd4..b0e1869 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -141,8 +141,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 
 			for (i = 0; i < sband->n_channels; i++) {
 				chan = &sband->channels[i];
-				if (chan->flags & (IEEE80211_CHAN_NO_IBSS |
-						   IEEE80211_CHAN_PASSIVE_SCAN |
+				if (chan->flags & (IEEE80211_CHAN_NO_IR |
 						   IEEE80211_CHAN_DISABLED |
 						   IEEE80211_CHAN_RADAR))
 					continue;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cbbef88..cc5d106 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -542,12 +542,12 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 	if ((chan->flags & IEEE80211_CHAN_DISABLED) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_DISABLED))
 		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN))
-		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_IBSS))
-		goto nla_put_failure;
+	if (chan->flags & IEEE80211_CHAN_NO_IR) {
+		if (nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_IR))
+			goto nla_put_failure;
+		if (nla_put_flag(msg, __NL80211_FREQUENCY_ATTR_NO_IBSS))
+			goto nla_put_failure;
+	}
 	if (chan->flags & IEEE80211_CHAN_RADAR) {
 		if (nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
 			goto nla_put_failure;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9851a2b..89b4664 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -163,35 +163,29 @@ static const struct ieee80211_regdomain world_regdom = {
 		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
 		/* IEEE 802.11b/g, channels 12..13. */
 		REG_RULE(2467-10, 2472+10, 40, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS),
+			NL80211_RRF_NO_IR),
 		/* IEEE 802.11 channel 14 - Only JP enables
 		 * this and for 802.11b only */
 		REG_RULE(2484-10, 2484+10, 20, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_NO_IR |
 			NL80211_RRF_NO_OFDM),
 		/* IEEE 802.11a, channel 36..48 */
 		REG_RULE(5180-10, 5240+10, 160, 6, 20,
-                        NL80211_RRF_PASSIVE_SCAN |
-                        NL80211_RRF_NO_IBSS),
+                        NL80211_RRF_NO_IR),
 
 		/* IEEE 802.11a, channel 52..64 - DFS required */
 		REG_RULE(5260-10, 5320+10, 160, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_NO_IR |
 			NL80211_RRF_DFS),
 
 		/* IEEE 802.11a, channel 100..144 - DFS required */
 		REG_RULE(5500-10, 5720+10, 160, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_NO_IR |
 			NL80211_RRF_DFS),
 
 		/* IEEE 802.11a, channel 149..165 */
 		REG_RULE(5745-10, 5825+10, 80, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS),
+			NL80211_RRF_NO_IR),
 
 		/* IEEE 802.11ad (60gHz), channels 1..3 */
 		REG_RULE(56160+2160*1-1080, 56160+2160*3+1080, 2160, 0, 0, 0),
@@ -698,10 +692,8 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 static u32 map_regdom_flags(u32 rd_flags)
 {
 	u32 channel_flags = 0;
-	if (rd_flags & NL80211_RRF_PASSIVE_SCAN)
-		channel_flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-	if (rd_flags & NL80211_RRF_NO_IBSS)
-		channel_flags |= IEEE80211_CHAN_NO_IBSS;
+	if (rd_flags & NL80211_RRF_NO_IR_ALL)
+		channel_flags |= IEEE80211_CHAN_NO_IR;
 	if (rd_flags & NL80211_RRF_DFS)
 		channel_flags |= IEEE80211_CHAN_RADAR;
 	if (rd_flags & NL80211_RRF_NO_OFDM)
@@ -1067,13 +1059,8 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 	chan_before.center_freq = chan->center_freq;
 	chan_before.flags = chan->flags;
 
-	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) {
-		chan->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
-		channel_changed = true;
-	}
-
-	if (chan->flags & IEEE80211_CHAN_NO_IBSS) {
-		chan->flags &= ~IEEE80211_CHAN_NO_IBSS;
+	if (chan->flags & IEEE80211_CHAN_NO_IR) {
+		chan->flags &= ~IEEE80211_CHAN_NO_IR;
 		channel_changed = true;
 	}
 
-- 
1.8.4.rc3

