Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5464 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab1H3TD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:03:27 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 14/22] ath6kl: Report received Action frames to cfg80211
Date: Tue, 30 Aug 2011 21:58:03 +0300
Message-ID: <1314730691-12089-15-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210330_466557_05A329C9)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d098cbd..dec8697 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -552,17 +552,26 @@ static int ath6kl_wmi_p2p_capabilities_event_rx(u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_rx_action_event_rx(u8 *datap, int len)
+static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	struct wmi_rx_action_event *ev;
+	u32 freq;
 	u16 dlen;
+	struct ath6kl *ar = wmi->parent_dev;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
 
 	ev = (struct wmi_rx_action_event *) datap;
+	freq = le32_to_cpu(ev->freq);
 	dlen = le16_to_cpu(ev->len);
-	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_action: len=%u\n", dlen);
+	if (datap + len < ev->data + dlen) {
+		ath6kl_err("invalid wmi_rx_action_event: "
+			   "len=%d dlen=%u\n", len, dlen);
+		return -EINVAL;
+	}
+	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_action: len=%u freq=%u\n", dlen, freq);
+	cfg80211_rx_mgmt(ar->net_dev, freq, ev->data, dlen, GFP_ATOMIC);
 
 	return 0;
 }
@@ -3086,7 +3095,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_RX_ACTION_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_ACTION_EVENTID\n");
-		ret = ath6kl_wmi_rx_action_event_rx(datap, len);
+		ret = ath6kl_wmi_rx_action_event_rx(wmi, datap, len);
 		break;
 	case WMI_P2P_INFO_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_P2P_INFO_EVENTID\n");
-- 
1.7.4.1

