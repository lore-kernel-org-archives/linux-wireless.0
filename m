Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56964 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752437Ab2CMCfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:35:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 04/15] mwifiex: use usleep_range instead of udelay
Date: Mon, 12 Mar 2012 19:35:11 -0700
Message-Id: <1331606116-32745-5-git-send-email-bzhao@marvell.com> (sfid-20120313_033550_132934_5788F304)
In-Reply-To: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
References: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For the delay of 10 uSec or more usleep_range is prefered.
Unlike udelay, sleep_range avoids large number of undesired
interrupts.

Ref Documentation/timers/timers-howto.txt

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    6 +++---
 drivers/net/wireless/mwifiex/sdio.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 4053509..1033f00 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -288,7 +288,7 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 
 	while (mwifiex_pcie_ok_to_access_hw(adapter)) {
 		i++;
-		udelay(10);
+		usleep_range(10, 20);
 		/* 50ms max wait */
 		if (i == 50000)
 			break;
@@ -1088,7 +1088,7 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 					card->cmdrsp_buf->len);
 			while (mwifiex_pcie_ok_to_access_hw(adapter) &&
 							(count++ < 10))
-				udelay(50);
+				usleep_range(50, 60);
 		} else {
 			dev_err(adapter->dev, "There is no command but "
 					      "got cmdrsp\n");
@@ -1337,7 +1337,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			}
 			if (len)
 				break;
-			udelay(10);
+			usleep_range(10, 20);
 		}
 
 		if (!len) {
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index d39d845..fe6fbc1 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -583,7 +583,7 @@ mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 		else if ((cs & bits) == bits)
 			return 0;
 
-		udelay(10);
+		usleep_range(10, 20);
 	}
 
 	dev_err(adapter->dev, "poll card status failed, tries = %d\n",
@@ -761,7 +761,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (len)
 				break;
 
-			udelay(10);
+			usleep_range(10, 20);
 		}
 
 		if (!len) {
-- 
1.7.0.2

