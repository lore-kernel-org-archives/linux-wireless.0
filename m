Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1KROdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 09:33:52 -0500
Subject: [PATCH v3] cfg80211: add flags for off-channel capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
In-Reply-To: <1321606323.10266.0.camel@jlt3.sipsolutions.net> (sfid-20111118_095222_965831_061B5D4F)
References: <1321522773.3997.3.camel@jlt3.sipsolutions.net>
	 (sfid-20111117_103942_138938_A7896DED)  <1321606323.10266.0.camel@jlt3.sipsolutions.net>
	 (sfid-20111118_095222_965831_061B5D4F)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 15:33:48 +0100
Message-ID: <1321626828.10266.60.camel@jlt3.sipsolutions.net> (sfid-20111118_153355_145582_0B65A586)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently mac80211 implements these for all devices,
but given restrictions of some devices that isn't
really true, so prepare for being able to remove the
capability for some mac80211 devices.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: make ath6kl part apply again
v3: fix logic bug sparse found

 drivers/net/wireless/ath/ath6kl/init.c |    3 ++-
 include/net/cfg80211.h                 |    4 ++++
 net/mac80211/main.c                    |    4 +++-
 net/wireless/nl80211.c                 |   16 +++++++++++-----
 4 files changed, 20 insertions(+), 7 deletions(-)

--- a/include/net/cfg80211.h	2011-11-18 09:47:37.000000000 +0100
+++ b/include/net/cfg80211.h	2011-11-18 09:47:38.000000000 +0100
@@ -1700,6 +1700,8 @@ struct cfg80211_ops {
  *	cfg80211_report_obss_beacon().
  * @WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD: When operating as an AP, the device
  *	responds to probe-requests in hardware.
+ * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
+ * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1721,6 +1723,8 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAVE_AP_SME			= BIT(17),
 	WIPHY_FLAG_REPORTS_OBSS			= BIT(18),
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
+	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
+	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 };
 
 /**
--- a/net/wireless/nl80211.c	2011-11-18 09:47:37.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-18 15:33:05.000000000 +0100
@@ -881,7 +881,8 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(set_pmksa, SET_PMKSA);
 	CMD(del_pmksa, DEL_PMKSA);
 	CMD(flush_pmksa, FLUSH_PMKSA);
-	CMD(remain_on_channel, REMAIN_ON_CHANNEL);
+	if (dev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL)
+		CMD(remain_on_channel, REMAIN_ON_CHANNEL);
 	CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
 	CMD(mgmt_tx, FRAME);
 	CMD(mgmt_tx_cancel_wait, FRAME_WAIT_CANCEL);
@@ -917,11 +918,12 @@ static int nl80211_send_wiphy(struct sk_
 
 	nla_nest_end(msg, nl_cmds);
 
-	if (dev->ops->remain_on_channel)
+	if (dev->ops->remain_on_channel &&
+	    dev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL)
 		NLA_PUT_U32(msg, NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
 			    dev->wiphy.max_remain_on_channel_duration);
 
-	if (dev->ops->mgmt_tx_cancel_wait)
+	if (dev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_OFFCHANNEL_TX_OK);
 
 	if (mgmt_stypes) {
@@ -5108,7 +5110,8 @@ static int nl80211_remain_on_channel(str
 	    duration > rdev->wiphy.max_remain_on_channel_duration)
 		return -EINVAL;
 
-	if (!rdev->ops->remain_on_channel)
+	if (!rdev->ops->remain_on_channel ||
+	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL))
 		return -EOPNOTSUPP;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
@@ -5321,7 +5324,7 @@ static int nl80211_tx_mgmt(struct sk_buf
 		return -EOPNOTSUPP;
 
 	if (info->attrs[NL80211_ATTR_DURATION]) {
-		if (!rdev->ops->mgmt_tx_cancel_wait)
+		if (!(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
 			return -EINVAL;
 		wait = nla_get_u32(info->attrs[NL80211_ATTR_DURATION]);
 	}
@@ -5339,6 +5342,9 @@ static int nl80211_tx_mgmt(struct sk_buf
 
 	offchan = info->attrs[NL80211_ATTR_OFFCHANNEL_TX_OK];
 
+	if (offchan && !(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
+		return -EINVAL;
+
 	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
--- a/net/mac80211/main.c	2011-11-18 09:47:37.000000000 +0100
+++ b/net/mac80211/main.c	2011-11-18 09:47:38.000000000 +0100
@@ -594,7 +594,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
 			WIPHY_FLAG_4ADDR_AP |
 			WIPHY_FLAG_4ADDR_STATION |
-			WIPHY_FLAG_REPORTS_OBSS;
+			WIPHY_FLAG_REPORTS_OBSS |
+			WIPHY_FLAG_OFFCHAN_TX |
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	wiphy->features = NL80211_FEATURE_SK_TX_STATUS;
 
--- a/drivers/net/wireless/ath/ath6kl/init.c	2011-11-18 09:47:37.000000000 +0100
+++ b/drivers/net/wireless/ath/ath6kl/init.c	2011-11-18 09:47:38.000000000 +0100
@@ -1603,7 +1603,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 		ar->conf_flags |= ATH6KL_CONF_SUSPEND_CUTPOWER;
 
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
-			    WIPHY_FLAG_HAVE_AP_SME;
+			    WIPHY_FLAG_HAVE_AP_SME |
+			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	set_bit(FIRST_BOOT, &ar->flag);
 


