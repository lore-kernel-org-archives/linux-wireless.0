Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:64178 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3JXWZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 18:25:02 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so94436ead.31
        for <linux-wireless@vger.kernel.org>; Thu, 24 Oct 2013 15:25:01 -0700 (PDT)
Date: Fri, 25 Oct 2013 01:25:00 +0300
From: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
To: opw-kernel@googlegroups.com
Cc: linux-wireless@vger.kernel.org
Subject: [Patch v2 3/3] net: wireless: replace printk with netdev_warn in
 adm8211.c
Message-ID: <20131024222500.GA4268@fireworks> (sfid-20131025_002508_139757_FB052B70)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then
pr_warn(...  to printk(KERN_WARNING ...

Signed-off-by: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
---
 drivers/net/wireless/adm8211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 1910ea7..3eee517 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1859,8 +1859,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 		cpu_to_le16(ADM8211_CSR_READ(PAR1) & 0xFFFF);
 
 	if (!is_valid_ether_addr(perm_addr)) {
-		printk(KERN_WARNING "%s (adm8211): Invalid hwaddr in EEPROM!\n",
-		       pci_name(pdev));
+		netdev_warn(dev->priv, "(adm8211): Invalid hwaddr in EEPROM!",
+			    "\n", pci_name(pdev));
 		eth_random_addr(perm_addr);
 	}
 	SET_IEEE80211_PERM_ADDR(dev, perm_addr);
-- 
1.8.1.2

