Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:38558 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab2JTCUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:20:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/7] mwifiex: disable channel filtering for SSID specific scan from user
Date: Fri, 19 Oct 2012 19:19:18 -0700
Message-Id: <1350699561-852-5-git-send-email-bzhao@marvell.com> (sfid-20121020_042026_141014_70F495F7)
In-Reply-To: <1350699561-852-1-git-send-email-bzhao@marvell.com>
References: <1350699561-852-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

If MWIFIEX_DISABLE_CHAN_FILT bit in scan mode bitmap is set,
firmware will turn off the filtering of scan responses from
adjacent channels.

Currently the bit is set only for internal SSID specific scan
performed during association. We will set it for user requested
SSID specific scan as well.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index b9d41db..9189a32 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -941,6 +941,11 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 				 chan_idx)->chan_scan_mode_bitmap
 					&= ~MWIFIEX_PASSIVE_SCAN;
 
+			if (*filtered_scan)
+				(scan_chan_list +
+				 chan_idx)->chan_scan_mode_bitmap
+					|= MWIFIEX_DISABLE_CHAN_FILT;
+
 			if (user_scan_in->chan_list[chan_idx].scan_time) {
 				scan_dur = (u16) user_scan_in->
 					chan_list[chan_idx].scan_time;
-- 
1.7.0.2

