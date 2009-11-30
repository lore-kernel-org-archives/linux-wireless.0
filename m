Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45416 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZK3Rcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:32:32 -0500
Date: Mon, 30 Nov 2009 18:32:38 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 07/11] mwl8k: get rid of the struct mwl8k_firmware abstraction
Message-ID: <20091130173238.GW20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cecabd6..427cbb9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -127,15 +127,6 @@ struct mwl8k_tx_queue {
 	struct sk_buff **skb;
 };
 
-/* Pointers to the firmware data and meta information about it.  */
-struct mwl8k_firmware {
-	/* Boot helper code */
-	struct firmware *helper;
-
-	/* Microcode */
-	struct firmware *ucode;
-};
-
 struct mwl8k_priv {
 	void __iomem *sram;
 	void __iomem *regs;
@@ -148,7 +139,8 @@ struct mwl8k_priv {
 	struct rxd_ops *rxd_ops;
 
 	/* firmware files and meta data */
-	struct mwl8k_firmware fw;
+	struct firmware *fw_helper;
+	struct firmware *fw_ucode;
 
 	/* firmware access */
 	struct mutex fw_mutex;
@@ -359,8 +351,8 @@ static void mwl8k_release_fw(struct firmware **fw)
 
 static void mwl8k_release_firmware(struct mwl8k_priv *priv)
 {
-	mwl8k_release_fw(&priv->fw.ucode);
-	mwl8k_release_fw(&priv->fw.helper);
+	mwl8k_release_fw(&priv->fw_ucode);
+	mwl8k_release_fw(&priv->fw_helper);
 }
 
 /* Request fw image */
@@ -381,7 +373,7 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv)
 	int rc;
 
 	if (di->helper_image != NULL) {
-		rc = mwl8k_request_fw(priv, di->helper_image, &priv->fw.helper);
+		rc = mwl8k_request_fw(priv, di->helper_image, &priv->fw_helper);
 		if (rc) {
 			printk(KERN_ERR "%s: Error requesting helper "
 			       "firmware file %s\n", pci_name(priv->pdev),
@@ -390,11 +382,11 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv)
 		}
 	}
 
-	rc = mwl8k_request_fw(priv, di->fw_image, &priv->fw.ucode);
+	rc = mwl8k_request_fw(priv, di->fw_image, &priv->fw_ucode);
 	if (rc) {
 		printk(KERN_ERR "%s: Error requesting firmware file %s\n",
 		       pci_name(priv->pdev), di->fw_image);
-		mwl8k_release_fw(&priv->fw.helper);
+		mwl8k_release_fw(&priv->fw_helper);
 		return rc;
 	}
 
@@ -555,13 +547,13 @@ static int mwl8k_feed_fw_image(struct mwl8k_priv *priv,
 static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	struct firmware *fw = priv->fw.ucode;
+	struct firmware *fw = priv->fw_ucode;
 	struct mwl8k_device_info *di = priv->device_info;
 	int rc;
 	int loops;
 
 	if (!memcmp(fw->data, "\x01\x00\x00\x00", 4)) {
-		struct firmware *helper = priv->fw.helper;
+		struct firmware *helper = priv->fw_helper;
 
 		if (helper == NULL) {
 			printk(KERN_ERR "%s: helper image needed but none "
-- 
1.5.6.4
