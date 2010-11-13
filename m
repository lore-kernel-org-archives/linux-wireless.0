Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55148 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225Ab0KMBY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:24:28 -0500
Received: by mail-yw0-f46.google.com with SMTP id 21so947866ywc.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 17:24:27 -0800 (PST)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH V2 7/7] mwl8k: use const struct fw pointers throughout
Date: Fri, 12 Nov 2010 17:23:53 -0800
Message-Id: <1289611433-5119-8-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This eliminates compiler warnings by doing things how the
firmware class expects.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 081bb6c..9ecf840 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -144,8 +144,8 @@ struct mwl8k_priv {
 	void __iomem *regs;
 
 	/* firmware */
-	struct firmware *fw_helper;
-	struct firmware *fw_ucode;
+	const struct firmware *fw_helper;
+	const struct firmware *fw_ucode;
 
 	/* hardware/firmware parameters */
 	bool ap_fw;
@@ -395,7 +395,7 @@ static void mwl8k_hw_reset(struct mwl8k_priv *priv)
 }
 
 /* Release fw image */
-static void mwl8k_release_fw(struct firmware **fw)
+static void mwl8k_release_fw(const struct firmware **fw)
 {
 	if (*fw == NULL)
 		return;
@@ -420,7 +420,7 @@ enum {
 
 /* Request fw image */
 static int mwl8k_request_fw(struct mwl8k_priv *priv,
-			    const char *fname, struct firmware **fw,
+			    const char *fname, const struct firmware **fw,
 			    bool nowait)
 {
 	/* release current image */
@@ -432,8 +432,7 @@ static int mwl8k_request_fw(struct mwl8k_priv *priv,
 					       &priv->pdev->dev, GFP_KERNEL,
 					       priv, mwl8k_fw_state_machine);
 	else
-		return request_firmware((const struct firmware **)fw,
-					fname, &priv->pdev->dev);
+		return request_firmware(fw, fname, &priv->pdev->dev);
 }
 
 static int mwl8k_request_firmware(struct mwl8k_priv *priv, char *fw_image,
@@ -632,12 +631,12 @@ static int mwl8k_feed_fw_image(struct mwl8k_priv *priv,
 static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	struct firmware *fw = priv->fw_ucode;
+	const struct firmware *fw = priv->fw_ucode;
 	int rc;
 	int loops;
 
 	if (!memcmp(fw->data, "\x01\x00\x00\x00", 4)) {
-		struct firmware *helper = priv->fw_helper;
+		const struct firmware *helper = priv->fw_helper;
 
 		if (helper == NULL) {
 			printk(KERN_ERR "%s: helper image needed but none "
-- 
1.7.1.1

