Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64528 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1H2M2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:28:55 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 09/20] ath6kl: Add cfg80211 calls for remain-on-channel events
Date: Mon, 29 Aug 2011 15:23:50 +0300
Message-ID: <1314620641-24257-10-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_142903_040854_70C95BD2)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 261ccff..2d80bdb 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -425,11 +425,14 @@ static int ath6kl_wmi_tx_complete_event_rx(u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_remain_on_chnl_event_rx(u8 *datap, int len)
+static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
+					      int len)
 {
 	struct wmi_remain_on_chnl_event *ev;
 	u32 freq;
 	u32 dur;
+	struct ieee80211_channel *chan;
+	struct ath6kl *ar = wmi->parent_dev;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -439,15 +442,26 @@ static int ath6kl_wmi_remain_on_chnl_event_rx(u8 *datap, int len)
 	dur = le32_to_cpu(ev->duration);
 	ath6kl_dbg(ATH6KL_DBG_WMI, "remain_on_chnl: freq=%u dur=%u\n",
 		   freq, dur);
+	chan = ieee80211_get_channel(ar->wdev->wiphy, freq);
+	if (!chan) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "remain_on_chnl: Unknown channel "
+			   "(freq=%u)\n", freq);
+		return -EINVAL;
+	}
+	cfg80211_ready_on_channel(ar->net_dev, 1, chan, NL80211_CHAN_NO_HT,
+				  dur, GFP_ATOMIC);
 
 	return 0;
 }
 
-static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(u8 *datap, int len)
+static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
+						     u8 *datap, int len)
 {
 	struct wmi_cancel_remain_on_chnl_event *ev;
 	u32 freq;
 	u32 dur;
+	struct ieee80211_channel *chan;
+	struct ath6kl *ar = wmi->parent_dev;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -457,6 +471,14 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(u8 *datap, int len)
 	dur = le32_to_cpu(ev->duration);
 	ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl: freq=%u dur=%u "
 		   "status=%u\n", freq, dur, ev->status);
+	chan = ieee80211_get_channel(ar->wdev->wiphy, freq);
+	if (!chan) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "cancel_remain_on_chnl: Unknown "
+			   "channel (freq=%u)\n", freq);
+		return -EINVAL;
+	}
+	cfg80211_remain_on_channel_expired(ar->net_dev, 1, chan,
+					   NL80211_CHAN_NO_HT, GFP_ATOMIC);
 
 	return 0;
 }
@@ -3009,12 +3031,13 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_REMAIN_ON_CHNL_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REMAIN_ON_CHNL_EVENTID\n");
-		ret = ath6kl_wmi_remain_on_chnl_event_rx(datap, len);
+		ret = ath6kl_wmi_remain_on_chnl_event_rx(wmi, datap, len);
 		break;
 	case WMI_CANCEL_REMAIN_ON_CHNL_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI,
 			   "WMI_CANCEL_REMAIN_ON_CHNL_EVENTID\n");
-		ret = ath6kl_wmi_cancel_remain_on_chnl_event_rx(datap, len);
+		ret = ath6kl_wmi_cancel_remain_on_chnl_event_rx(wmi, datap,
+								len);
 		break;
 	case WMI_TX_STATUS_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_STATUS_EVENTID\n");
-- 
1.7.4.1

