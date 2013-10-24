Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:44411 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3JXVaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 17:30:30 -0400
Received: by mail-ee0-f48.google.com with SMTP id e50so1404506eek.7
        for <linux-wireless@vger.kernel.org>; Thu, 24 Oct 2013 14:30:28 -0700 (PDT)
Date: Fri, 25 Oct 2013 00:30:26 +0300
From: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
To: opw-kernel@googlegroups.com
Cc: linux-wireless@vger.kernel.org
Subject: [Patch v2 1/3] net: wireless: replace printk with netdev_warn in
 adm8211.c
Message-ID: <20131024213026.GA3569@fireworks> (sfid-20131024_233033_437584_F664DB03)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...
to printk(KERN_WARNING ...

Signed-off-by: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
---
 drivers/net/wireless/adm8211.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index f9a24e5..0d0dcba 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -151,8 +151,9 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else
 			priv->rf_type = ADM8211_TYPE_AIROHA;
 
-		printk(KERN_WARNING "%s (adm8211): Unknown RFtype %d\n",
-		       pci_name(priv->pdev), (cr49 >> 3) & 0x7);
+		netdev_warn(priv->pdev, "(adm8211): Unknown RFtype %d\n",
+			    pci_name(priv->pdev), (cr49 >> 3) & 0x7);
+
 	}
 
 	priv->bbp_type = cr49 & 0x7;
-- 
1.8.1.2

