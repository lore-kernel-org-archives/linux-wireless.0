Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37968 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935176AbcCJIo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 03:44:29 -0500
Received: by mail-wm0-f51.google.com with SMTP id l68so18503989wml.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 00:44:28 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v2 5/7] mwifiex: scan: replace pointer arithmetic with array access
Date: Thu, 10 Mar 2016 09:44:09 +0100
Message-Id: <1457599451-13910-6-git-send-email-afenkart@gmail.com> (sfid-20160310_094432_682161_675A7724)
In-Reply-To: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
References: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

improves readability

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index c137fd8..327b4d8 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1000,27 +1000,24 @@ mwifiex_config_scan(struct mwifiex_private *priv,
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
@@ -1035,9 +1032,9 @@ mwifiex_config_scan(struct mwifiex_private *priv,
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

