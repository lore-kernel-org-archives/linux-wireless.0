Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935149AbeE2Bmm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 21:42:42 -0400
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH 2/2] mwifiex: reserve passive scan time for radar channel
Date: Tue, 29 May 2018 09:42:09 +0800
Message-ID: <1527558129-18109-2-git-send-email-huxm@marvell.com> (sfid-20180529_034308_556399_7D58698F)
In-Reply-To: <1527558129-18109-1-git-send-email-huxm@marvell.com>
References: <1527558129-18109-1-git-send-email-huxm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Active scan is not allowed on radar channel, instead
using passvie scan with more time.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index d7ce7f7..fb1cbaf 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -482,7 +482,8 @@ enum cipher_suite {
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16((u16) user_scan_in->
 					chan_list[0].scan_time);
-			else if (ch->flags & IEEE80211_CHAN_NO_IR)
+			else if ((ch->flags & IEEE80211_CHAN_NO_IR) ||
+				 (ch->flags & IEEE80211_CHAN_RADAR))
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16(adapter->passive_scan_time);
 			else
@@ -502,10 +503,12 @@ enum cipher_suite {
 			scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					|= MWIFIEX_DISABLE_CHAN_FILT;
 
-			if (filtered_scan) {
+			if (filtered_scan &&
+			    !((ch->flags & IEEE80211_CHAN_NO_IR) ||
+			      (ch->flags & IEEE80211_CHAN_RADAR)))
 				scan_chan_list[chan_idx].max_scan_time =
 				cpu_to_le16(adapter->specific_scan_time);
-			}
+
 			chan_idx++;
 		}
 
-- 
1.9.1
