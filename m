Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:38885 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3JZTU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Oct 2013 15:20:57 -0400
Received: by mail-ea0-f182.google.com with SMTP id o10so1404652eaj.27
        for <linux-wireless@vger.kernel.org>; Sat, 26 Oct 2013 12:20:56 -0700 (PDT)
Date: Sat, 26 Oct 2013 22:20:53 +0300
From: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
To: opw-kernel@googlegroups.com
Cc: linux-wireless@vger.kernel.org
Subject: [Patch v3 1/3] net: wireless: replace printk with pr_warn in
 adm8211.c
Message-ID: <20131026192053.GA10494@fireworks> (sfid-20131026_212100_739944_3DFF4EBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...
to printk(KERN_WARNING ...

Signed-off-by: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
---
 drivers/net/wireless/adm8211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index f9a24e5..e36d54d 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -151,7 +151,7 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else
 			priv->rf_type = ADM8211_TYPE_AIROHA;
 
-		printk(KERN_WARNING "%s (adm8211): Unknown RFtype %d\n",
+		pr_warn("%s (adm8211): Unknown RFtype %d\n",
 		       pci_name(priv->pdev), (cr49 >> 3) & 0x7);
 	}
 
-- 
1.8.1.2

