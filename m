Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:35777 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751704Ab2FGEO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 00:14:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: shorten per channel scan time
Date: Wed,  6 Jun 2012 21:12:40 -0700
Message-Id: <1339042362-30317-2-git-send-email-bzhao@marvell.com> (sfid-20120607_061434_393888_E9794312)
In-Reply-To: <1339042362-30317-1-git-send-email-bzhao@marvell.com>
References: <1339042362-30317-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the scan time per channel for active scanning is set to
200ms. It takes quite a while to finsh scanning on all channels,
especially with a dual band configuration.

Change the per channel scan time settings to the following values:

passive scan: 110ms
active scan: 30ms
specific scan: 30ms

Above settings have been tested on x86 and arm platforms.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index bd3b0bf..cbad00d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -79,9 +79,9 @@ enum {
 
 #define SCAN_BEACON_ENTRY_PAD			6
 
-#define MWIFIEX_PASSIVE_SCAN_CHAN_TIME	200
-#define MWIFIEX_ACTIVE_SCAN_CHAN_TIME	200
-#define MWIFIEX_SPECIFIC_SCAN_CHAN_TIME	110
+#define MWIFIEX_PASSIVE_SCAN_CHAN_TIME	110
+#define MWIFIEX_ACTIVE_SCAN_CHAN_TIME	30
+#define MWIFIEX_SPECIFIC_SCAN_CHAN_TIME	30
 
 #define SCAN_RSSI(RSSI)					(0x100 - ((u8)(RSSI)))
 
-- 
1.7.0.2

