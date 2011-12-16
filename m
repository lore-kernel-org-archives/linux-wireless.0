Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45643 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750743Ab1LPFDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 00:03:40 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: cleanup work in scan.c
Date: Thu, 15 Dec 2011 21:00:37 -0800
Message-Id: <1324011637-4370-1-git-send-email-bzhao@marvell.com> (sfid-20111216_060343_813768_2C7D894D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Scan type derived from IEEE80211_CHAN_PASSIVE_SCAN bit is a boolean
flag representing passive scanning. We should not again compare it
with driver specific macro MWIFIEX_SCAN_TYPE_PASSIVE to determine
passive or active scan. We can also avoid the use of local variable
by using the flag directly.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index e2e7156..6396d33 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -500,7 +500,6 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 	struct ieee80211_channel *ch;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int chan_idx = 0, i;
-	u8 scan_type;
 
 	for (band = 0; (band < IEEE80211_NUM_BANDS) ; band++) {
 
@@ -514,19 +513,20 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 			if (ch->flags & IEEE80211_CHAN_DISABLED)
 				continue;
 			scan_chan_list[chan_idx].radio_type = band;
-			scan_type = ch->flags & IEEE80211_CHAN_PASSIVE_SCAN;
+
 			if (user_scan_in &&
 				user_scan_in->chan_list[0].scan_time)
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16((u16) user_scan_in->
 					chan_list[0].scan_time);
-			else if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
+			else if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16(adapter->passive_scan_time);
 			else
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16(adapter->active_scan_time);
-			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
+
+			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					|= MWIFIEX_PASSIVE_SCAN;
 			else
-- 
1.7.0.2

