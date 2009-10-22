Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59615 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbZJVSxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:48 -0400
Date: Thu, 22 Oct 2009 20:20:53 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 17/28] mwl8k: handle loading AP firmware images
Message-ID: <20091022182053.GS1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP and STA firmware images provide a different signature in the
HIU_INT_CODE register after loading.  Record which of the signatures
we saw, as it determines which command sequences to use later on.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 37b3f31..703c306 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -129,6 +129,7 @@ struct mwl8k_priv {
 	struct pci_dev *pdev;
 
 	struct mwl8k_device_info *device_info;
+	bool ap_fw;
 
 	/* firmware files and meta data */
 	struct mwl8k_firmware fw;
@@ -533,6 +534,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct firmware *fw = priv->fw.ucode;
+	struct mwl8k_device_info *di = priv->device_info;
 	int rc;
 	int loops;
 
@@ -564,14 +566,26 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 		return rc;
 	}
 
-	iowrite32(MWL8K_MODE_STA, priv->regs + MWL8K_HIU_GEN_PTR);
+	if (di->modes & BIT(NL80211_IFTYPE_AP))
+		iowrite32(MWL8K_MODE_AP, priv->regs + MWL8K_HIU_GEN_PTR);
+	else
+		iowrite32(MWL8K_MODE_STA, priv->regs + MWL8K_HIU_GEN_PTR);
 	msleep(1);
 
 	loops = 200000;
 	do {
-		if (ioread32(priv->regs + MWL8K_HIU_INT_CODE)
-						== MWL8K_FWSTA_READY)
+		u32 ready_code;
+
+		ready_code = ioread32(priv->regs + MWL8K_HIU_INT_CODE);
+		if (ready_code == MWL8K_FWAP_READY) {
+			priv->ap_fw = 1;
+			break;
+		} else if (ready_code == MWL8K_FWSTA_READY) {
+			priv->ap_fw = 0;
 			break;
+		}
+
+		cond_resched();
 		udelay(1);
 	} while (--loops);
 
@@ -3164,9 +3178,10 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_stop_firmware;
 	}
 
-	printk(KERN_INFO "%s: %s v%d, %pM, firmware version %u.%u.%u.%u\n",
+	printk(KERN_INFO "%s: %s v%d, %pM, %s firmware %u.%u.%u.%u\n",
 	       wiphy_name(hw->wiphy), priv->device_info->part_name,
 	       priv->hw_rev, hw->wiphy->perm_addr,
+	       priv->ap_fw ? "AP" : "STA",
 	       (priv->fw_rev >> 24) & 0xff, (priv->fw_rev >> 16) & 0xff,
 	       (priv->fw_rev >> 8) & 0xff, priv->fw_rev & 0xff);
 
-- 
1.5.6.4
