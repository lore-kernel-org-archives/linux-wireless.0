Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55354 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbcDYGus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 02:50:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3P6khZ6031149
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2016 23:50:46 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 22g8jfm2f6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2016 23:50:46 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/2] mwifiex: disable channel filtering feature in firmware
Date: Sun, 24 Apr 2016 23:49:51 -0700
Message-ID: <1461566992-3539-1-git-send-email-akarwar@marvell.com> (sfid-20160425_085054_661156_1258E868)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As 2.4Ghz channels are overlapping, sometimes AP responds to
probe request even if it's operating on neighbouring channel.
Currently firmware drops those scan entries, as current channel
doesn't match with APs channel.

This patch enables MWIFIEX_DISABLE_CHAN_FILT flag in scan
command to disable the feature so that better scan results
will be received in 2.4Ghz band.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 36cc9cc..bc5e52c 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -498,11 +498,13 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 					&= ~MWIFIEX_PASSIVE_SCAN;
 			scan_chan_list[chan_idx].chan_number =
 							(u32) ch->hw_value;
+
+			scan_chan_list[chan_idx].chan_scan_mode_bitmap
+					|= MWIFIEX_DISABLE_CHAN_FILT;
+
 			if (filtered_scan) {
 				scan_chan_list[chan_idx].max_scan_time =
 				cpu_to_le16(adapter->specific_scan_time);
-				scan_chan_list[chan_idx].chan_scan_mode_bitmap
-					|= MWIFIEX_DISABLE_CHAN_FILT;
 			}
 			chan_idx++;
 		}
@@ -1060,9 +1062,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					&= ~MWIFIEX_PASSIVE_SCAN;
 
-			if (*filtered_scan)
-				scan_chan_list[chan_idx].chan_scan_mode_bitmap
-					|= MWIFIEX_DISABLE_CHAN_FILT;
+			scan_chan_list[chan_idx].chan_scan_mode_bitmap
+				|= MWIFIEX_DISABLE_CHAN_FILT;
 
 			if (user_scan_in->chan_list[chan_idx].scan_time) {
 				scan_dur = (u16) user_scan_in->
-- 
1.8.1.4

