Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51598 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023Ab3CALvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 06:51:10 -0500
Date: Fri, 1 Mar 2013 17:13:01 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: [PATCH 2/2] mwl8k: Load 8764 firmware image
Message-ID: <20130301114301.GA11074@markyou.marvell.com> (sfid-20130301_125114_148821_962ED3E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This differs from legacy chips i.e.
a 8764 loads firmware image without a helper image
b Check interrupt status register for download
  complete indication.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index e86a31b..aaaf10d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -284,6 +284,7 @@ struct mwl8k_priv {
 	unsigned fw_state;
 	char *fw_pref;
 	char *fw_alt;
+	bool is_8764;
 	struct completion firmware_loading_complete;
 
 	/* bitmap of running BSSes */
@@ -600,13 +601,18 @@ mwl8k_send_fw_load_cmd(struct mwl8k_priv *priv, void *data, int length)
 	loops = 1000;
 	do {
 		u32 int_code;
-
-		int_code = ioread32(regs + MWL8K_HIU_INT_CODE);
-		if (int_code == MWL8K_INT_CODE_CMD_FINISHED) {
-			iowrite32(0, regs + MWL8K_HIU_INT_CODE);
-			break;
+		if (priv->is_8764) {
+			int_code = ioread32(regs +
+					    MWL8K_HIU_H2A_INTERRUPT_STATUS);
+			if (int_code == 0)
+				break;
+		} else {
+			int_code = ioread32(regs + MWL8K_HIU_INT_CODE);
+			if (int_code == MWL8K_INT_CODE_CMD_FINISHED) {
+				iowrite32(0, regs + MWL8K_HIU_INT_CODE);
+				break;
+			}
 		}
-
 		cond_resched();
 		udelay(1);
 	} while (--loops);
@@ -724,7 +730,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 	int rc;
 	int loops;
 
-	if (!memcmp(fw->data, "\x01\x00\x00\x00", 4)) {
+	if (!memcmp(fw->data, "\x01\x00\x00\x00", 4) && !priv->is_8764) {
 		const struct firmware *helper = priv->fw_helper;
 
 		if (helper == NULL) {
@@ -743,7 +749,10 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 
 		rc = mwl8k_feed_fw_image(priv, fw->data, fw->size);
 	} else {
-		rc = mwl8k_load_fw_image(priv, fw->data, fw->size);
+		if (priv->is_8764)
+			rc = mwl8k_feed_fw_image(priv, fw->data, fw->size);
+		else
+			rc = mwl8k_load_fw_image(priv, fw->data, fw->size);
 	}
 
 	if (rc) {
@@ -6007,6 +6016,8 @@ static int mwl8k_probe(struct pci_dev *pdev,
 	priv->pdev = pdev;
 	priv->device_info = &mwl8k_info_tbl[id->driver_data];
 
+	if (id->driver_data == MWL8764)
+		priv->is_8764 = true;
 
 	priv->sram = pci_iomap(pdev, 0, 0x10000);
 	if (priv->sram == NULL) {
-- 
1.8.0.3

