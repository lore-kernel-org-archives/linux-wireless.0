Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:59846 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBRBKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:10:36 -0500
Received: by mail-ee0-f49.google.com with SMTP id d17so7466516eek.36
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:10:35 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	liuhq11@mails.tsinghua.edu.cn,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 2/7] rtl818x: pci_iomap() should pair with pci_iounmap()
Date: Tue, 18 Feb 2014 02:10:41 +0100
Message-Id: <1392685846-10116-3-git-send-email-andrea.merello@gmail.com> (sfid-20140218_021040_728519_A1F97E37)
In-Reply-To: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

Currently the driver uses pci_iomap() but iounmap() is called in
the error path

Change to use pci_iounmap() instead.

Reported-by: Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 470a1e3..bf59ff9 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1137,7 +1137,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	return 0;
 
  err_iounmap:
-	iounmap(priv->map);
+	pci_iounmap(pdev, priv->map);
 
  err_free_dev:
 	ieee80211_free_hw(dev);
-- 
1.8.3.2

