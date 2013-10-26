Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35201 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3JZTu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Oct 2013 15:50:29 -0400
Received: by mail-ee0-f48.google.com with SMTP id e50so2642717eek.21
        for <linux-wireless@vger.kernel.org>; Sat, 26 Oct 2013 12:50:28 -0700 (PDT)
Date: Sat, 26 Oct 2013 22:50:24 +0300
From: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
To: opw-kernel@googlegroups.com
Cc: linux-wireless@vger.kernel.org
Subject: [Patch v3 3/3] net: wireless: replace printk with pr_warn in
 adm8211.c
Message-ID: <20131026195024.GA12235@fireworks> (sfid-20131026_215032_417350_7965FE18)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...
to printk(KERN_WARNING ...

Signed-off-by: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
---
 drivers/net/wireless/adm8211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 0392b52..00a1221 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1855,8 +1855,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 		cpu_to_le16(ADM8211_CSR_READ(PAR1) & 0xFFFF);
 
 	if (!is_valid_ether_addr(perm_addr)) {
-		printk(KERN_WARNING "%s (adm8211): Invalid hwaddr in EEPROM!\n",
-		       pci_name(pdev));
+		pr_warn("%s (adm8211): Invalid hwaddr in EEPROM!\n",
+			pci_name(pdev));
 		eth_random_addr(perm_addr);
 	}
 	SET_IEEE80211_PERM_ADDR(dev, perm_addr);
-- 
1.8.1.2

