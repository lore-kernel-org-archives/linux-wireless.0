Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55169 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2FRLBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 07:01:00 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <jouni@qca.qualcomm.com>, <johannes@sipsolutions.net>,
	<kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: Support for automatic channel selection in AP mode
Date: Mon, 18 Jun 2012 16:30:40 +0530
Message-ID: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120618_130105_470903_112816CB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the driver sets WIPHY_FLAG_SUPPORTS_ACS, auto_channel_select
is passed to the driver as ap settings and frequency setting is
skipped. When the AP mode comes up in the new channel, it is 
intimated to cfg80211 through cfg80211_ch_switch_notify which
in turn notifies the channel information to wpa_supplicant
through CH_SWITCH event.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
v2: Add a new flag attribute for _START_AP command to indicate ACS request.
    Update the channel/frequency information using ch_switch_notify
    once the driver (firmware) has selected the channel.

For P2P, the operating channel needs to be known before group negotiation starts.
This is true in case of P2P GO or client. It needs a separate p2p command from
wpa_cli to get the acs-based best channel information from the driver.

 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    4 ++++
 net/wireless/nl80211.c  |    7 +++++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 970afdf..ed6653b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1224,6 +1224,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
  *      or 0 to disable background scan.
  *
+ * @NL80211_ATTR_ACS: Enable automatic channel selection by the driver
+ *	for AP mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1475,6 +1478,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BG_SCAN_PERIOD,
 
+	NL80211_ATTR_ACS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7319f25..b0262b5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -417,6 +417,7 @@ struct cfg80211_beacon_data {
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
  * @inactivity_timeout: time in seconds to determine station's inactivity.
+ * @auto_channel_select: automatic channel selection
  */
 struct cfg80211_ap_settings {
 	struct ieee80211_channel *channel;
@@ -432,6 +433,7 @@ struct cfg80211_ap_settings {
 	bool privacy;
 	enum nl80211_auth_type auth_type;
 	int inactivity_timeout;
+	bool auto_channel_select;
 };
 
 /**
@@ -1810,6 +1812,7 @@ struct cfg80211_ops {
  *	responds to probe-requests in hardware.
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
+ * @WIPHY_FLAG_SUPPORTS_ACS: Device supports automatic channel selection.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1833,6 +1836,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
+	WIPHY_FLAG_SUPPORTS_ACS			= BIT(22),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ae54b8..26f8c03 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -206,6 +206,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
 	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
+	[NL80211_ATTR_ACS] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -2348,6 +2349,12 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else if (wdev->preset_chan) {
 		params.channel = wdev->preset_chan;
 		params.channel_type = wdev->preset_chantype;
+	} else if (info->attrs[NL80211_ATTR_ACS]) {
+		if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_ACS)
+			params.auto_channel_select =
+				!!info->attrs[NL80211_ATTR_ACS];
+		else
+			return -EINVAL;
 	} else
 		return -EINVAL;
 
-- 
1.7.4.1

