Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14991 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbaCSFTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 01:19:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add support for sleep cookie in PCIe
Date: Tue, 18 Mar 2014 22:19:17 -0700
Message-ID: <1395206358-11573-2-git-send-email-bzhao@marvell.com> (sfid-20140319_061934_846388_4240B482)
In-Reply-To: <1395206358-11573-1-git-send-email-bzhao@marvell.com>
References: <1395206358-11573-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support to read sleep cookie for command
response before accessing buffer.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 26 ++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/pcie.h |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 9f1683b..57c353a 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -327,6 +327,30 @@ static void mwifiex_pcie_dev_wakeup_delay(struct mwifiex_adapter *adapter)
 	return;
 }
 
+static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
+					   u32 max_delay_loop_cnt)
+{
+	struct pcie_service_card *card = adapter->card;
+	u8 *buffer;
+	u32 sleep_cookie, count;
+
+	for (count = 0; count < max_delay_loop_cnt; count++) {
+		buffer = card->cmdrsp_buf->data - INTF_HEADER_LEN;
+		sleep_cookie = *(u32 *)buffer;
+
+		if (sleep_cookie == MWIFIEX_DEF_SLEEP_COOKIE) {
+			dev_dbg(adapter->dev,
+				"sleep cookie found at count %d\n", count);
+			break;
+		}
+		usleep_range(20, 30);
+	}
+
+	if (count >= max_delay_loop_cnt)
+		dev_dbg(adapter->dev,
+			"max count reached while accessing sleep cookie\n");
+}
+
 /* This function wakes up the card by reading fw_status register. */
 static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
@@ -1539,6 +1563,8 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 					 "Write register failed\n");
 				return -1;
 			}
+			mwifiex_delay_for_sleep_cookie(adapter,
+						       MWIFIEX_MAX_DELAY_COUNT);
 			while (reg->sleep_cookie && (count++ < 10) &&
 			       mwifiex_pcie_ok_to_access_hw(adapter))
 				usleep_range(50, 60);
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 193af75..e8ec561 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -97,6 +97,8 @@
 #define MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD		256
 /* FW awake cookie after FW ready */
 #define FW_AWAKE_COOKIE						(0xAA55AA55)
+#define MWIFIEX_DEF_SLEEP_COOKIE			0xBEEFBEEF
+#define MWIFIEX_MAX_DELAY_COUNT				5
 
 struct mwifiex_pcie_card_reg {
 	u16 cmd_addr_lo;
-- 
1.8.2.3

