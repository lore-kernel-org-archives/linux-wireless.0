Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35420 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730488AbeG0RxG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 13:53:06 -0400
Received: by mail-wm0-f66.google.com with SMTP id o18-v6so6144888wmc.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2018 09:30:26 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wlcore: Set rx_status boottime_ns field on rx
Date: Fri, 27 Jul 2018 18:30:23 +0200
Message-Id: <1532709023-1237-1-git-send-email-loic.poulain@linaro.org> (sfid-20180727_183029_600708_4106714B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving a beacon or probe response, we should update the
boottime_ns field which is the timestamp the frame was received at.
(cf mac80211.h)

This fixes a scanning issue with Android since it relies on this
timestamp to determine when the AP has been seen for the last time
(via the nl80211 BSS_LAST_SEEN_BOOTTIME parameter).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ti/wlcore/rx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 0f15696..078a494 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -59,7 +59,7 @@ static u32 wlcore_rx_get_align_buf_size(struct wl1271 *wl, u32 pkt_len)
 static void wl1271_rx_status(struct wl1271 *wl,
 			     struct wl1271_rx_descriptor *desc,
 			     struct ieee80211_rx_status *status,
-			     u8 beacon)
+			     u8 beacon, u8 probe_rsp)
 {
 	memset(status, 0, sizeof(struct ieee80211_rx_status));
 
@@ -106,6 +106,9 @@ static void wl1271_rx_status(struct wl1271 *wl,
 		}
 	}
 
+	if (beacon || probe_rsp)
+		status->boottime_ns = ktime_get_boot_ns();
+
 	if (beacon)
 		wlcore_set_pending_regdomain_ch(wl, (u16)desc->channel,
 						status->band);
@@ -191,7 +194,8 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	if (ieee80211_is_data_present(hdr->frame_control))
 		is_data = 1;
 
-	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon);
+	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon,
+			 ieee80211_is_probe_resp(hdr->frame_control));
 	wlcore_hw_set_rx_csum(wl, desc, skb);
 
 	seq_num = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
-- 
2.7.4
