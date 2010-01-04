Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52760 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0ADUx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:53:56 -0500
Date: Mon, 4 Jan 2010 21:53:54 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 01/14] mwl8k: bail out if there is no AP firmware image support for this chip
Message-ID: <20100104205354.GA1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cf0671f..d3a7916 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3363,10 +3363,17 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	mwl8k_release_firmware(priv);
 
 
-	if (priv->ap_fw)
+	if (priv->ap_fw) {
 		priv->rxd_ops = priv->device_info->ap_rxd_ops;
-	else
+		if (priv->rxd_ops == NULL) {
+			printk(KERN_ERR "%s: Driver does not have AP "
+			       "firmware image support for this hardware\n",
+			       wiphy_name(hw->wiphy));
+			goto err_stop_firmware;
+		}
+	} else {
 		priv->rxd_ops = &rxd_sta_ops;
+	}
 
 	priv->sniffer_enabled = false;
 	priv->wmm_enabled = false;
-- 
1.5.6.4
