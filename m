Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog031.obsmtp.com ([74.125.150.105]:43772 "EHLO
	na6sys009bog031.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423Ab2HDBY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:24:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 05/16] mwifiex: update max_chan_per_scan correctly for SSID scan
Date: Fri,  3 Aug 2012 18:06:03 -0700
Message-Id: <1344042374-6892-6-git-send-email-bzhao@marvell.com> (sfid-20120804_032551_236995_4059C8BE)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As per recent patch "658f37b mwifiex: scan less channels..."
less channels are scanned per scan command in associated state.

Default number of channels per scan command for normal scan are
already 4, but those are 14 for SSID specific scan operation.

This code change in this patch is required for SSID specific scan.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 04dc7ca..3035412 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -989,6 +989,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 			*max_chan_per_scan = 2;
 		else if (chan_num < MWIFIEX_LIMIT_3_CHANNELS_PER_SCAN_CMD)
 			*max_chan_per_scan = 3;
+		else
+			*max_chan_per_scan = 4;
 	}
 }
 
-- 
1.7.0.2

