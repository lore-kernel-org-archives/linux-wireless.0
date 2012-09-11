Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:54764 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757260Ab2IKBcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:32:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 09/10] mwifiex: disable WOW by default
Date: Mon, 10 Sep 2012 18:30:48 -0700
Message-Id: <1347327049-13665-10-git-send-email-bzhao@marvell.com> (sfid-20120911_033231_816411_0DED11F3)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some platforms do not support WOW. Let's change the default wakeup
criteria to 0.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 1a4a694..b8ce78e 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -310,7 +310,7 @@ enum ENH_PS_MODES {
 #define HostCmd_SCAN_RADIO_TYPE_A           1
 
 #define HOST_SLEEP_CFG_CANCEL		0xffffffff
-#define HOST_SLEEP_CFG_COND_DEF		0x0000000f
+#define HOST_SLEEP_CFG_COND_DEF		0x00000000
 #define HOST_SLEEP_CFG_GPIO_DEF		0xff
 #define HOST_SLEEP_CFG_GAP_DEF		0
 
-- 
1.7.0.2

