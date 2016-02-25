Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37123 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbcBYAJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:09:09 -0500
Received: by mail-wm0-f41.google.com with SMTP id g62so5579160wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:09:08 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 5/7] mwifiex: scan: replace pointer arithmetic with array access
Date: Thu, 25 Feb 2016 01:08:50 +0100
Message-Id: <1456358932-23114-6-git-send-email-afenkart@gmail.com> (sfid-20160225_010915_257618_F97132C9)
In-Reply-To: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

improves readability

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 5588750..6ddc98b 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -999,27 +999,24 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 		     chan_idx++) {
 
 			channel = user_scan_in->chan_list[chan_idx].chan_number;
-			(scan_chan_list + chan_idx)->chan_number = channel;
+			scan_chan_list[chan_idx].chan_number = channel;
 
 			radio_type =
 				user_scan_in->chan_list[chan_idx].radio_type;
-			(scan_chan_list + chan_idx)->radio_type = radio_type;
+			scan_chan_list[chan_idx].radio_type = radio_type;
 
 			scan_type = user_scan_in->chan_list[chan_idx].scan_type;
 
 			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
-				(scan_chan_list +
-				 chan_idx)->chan_scan_mode_bitmap
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					|= (MWIFIEX_PASSIVE_SCAN |
 					    MWIFIEX_HIDDEN_SSID_REPORT);
 			else
-				(scan_chan_list +
-				 chan_idx)->chan_scan_mode_bitmap
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					&= ~MWIFIEX_PASSIVE_SCAN;
 
 			if (*filtered_scan)
-				(scan_chan_list +
-				 chan_idx)->chan_scan_mode_bitmap
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					|= MWIFIEX_DISABLE_CHAN_FILT;
 
 			if (user_scan_in->chan_list[chan_idx].scan_time) {
@@ -1034,9 +1031,9 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 					scan_dur = adapter->active_scan_time;
 			}
 
-			(scan_chan_list + chan_idx)->min_scan_time =
+			scan_chan_list[chan_idx].min_scan_time =
 				cpu_to_le16(scan_dur);
-			(scan_chan_list + chan_idx)->max_scan_time =
+			scan_chan_list[chan_idx].max_scan_time =
 				cpu_to_le16(scan_dur);
 		}
 
-- 
2.7.0

