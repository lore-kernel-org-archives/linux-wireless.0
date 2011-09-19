Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51746 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1ISQPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:15:46 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 2/9] ath6kl: Remove deprecated WMI_OPT_RX_FRAME_EVENTID processing
Date: Mon, 19 Sep 2011 19:15:00 +0300
Message-ID: <1316448907-10166-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181550_070793_690ADB73)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This event has been deprecated and there is no need for ath6kl to
include code for processing it.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   40 +--------------------------------
 1 files changed, 1 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index dbddb91..24f0e3e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1185,44 +1185,6 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_opt_frame_event_rx(struct wmi *wmi, u8 *datap, int len)
-{
-	struct bss *bss;
-	struct wmi_opt_rx_info_hdr *bih;
-	u8 *buf;
-
-	if (len <= sizeof(struct wmi_opt_rx_info_hdr))
-		return -EINVAL;
-
-	bih = (struct wmi_opt_rx_info_hdr *) datap;
-	buf = datap + sizeof(struct wmi_opt_rx_info_hdr);
-	len -= sizeof(struct wmi_opt_rx_info_hdr);
-
-	ath6kl_dbg(ATH6KL_DBG_WMI, "opt frame event %2.2x:%2.2x\n",
-		   bih->bssid[4], bih->bssid[5]);
-
-	bss = wlan_find_node(&wmi->parent_dev->scan_table, bih->bssid);
-	if (bss != NULL) {
-		/* Free up the node. We are about to allocate a new node. */
-		wlan_node_reclaim(&wmi->parent_dev->scan_table, bss);
-	}
-
-	bss = wlan_node_alloc(len);
-	if (!bss)
-		return -ENOMEM;
-
-	bss->ni_snr = bih->snr;
-	bss->ni_cie.ie_chan = le16_to_cpu(bih->ch);
-
-	if (WARN_ON(!bss->ni_buf))
-		return -EINVAL;
-
-	memcpy(bss->ni_buf, buf, len);
-	wlan_setup_node(&wmi->parent_dev->scan_table, bss, bih->bssid);
-
-	return 0;
-}
-
 /* Inactivity timeout of a fatpipe(pstream) at the target */
 static int ath6kl_wmi_pstream_timeout_event_rx(struct wmi *wmi, u8 *datap,
 					       int len)
@@ -3175,7 +3137,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_OPT_RX_FRAME_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_OPT_RX_FRAME_EVENTID\n");
-		ret = ath6kl_wmi_opt_frame_event_rx(wmi, datap, len);
+		/* this event has been deprecated */
 		break;
 	case WMI_REPORT_ROAM_TBL_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REPORT_ROAM_TBL_EVENTID\n");
-- 
1.7.4.1

