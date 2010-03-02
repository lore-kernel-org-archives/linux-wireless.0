Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37376 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0CBPe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 10:34:58 -0500
Received: by bwz1 with SMTP id 1so260268bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 07:34:55 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: fix rt2800pci compilation with SoC
Date: Tue, 2 Mar 2010 16:34:49 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003021634.50077.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compiling rt2800pci with CONFIG_RT2800PCI_SOC fails with "... rt2880pci.c:
error: incompatible type for argument 2 of 'rt2x00soc_probe'".

Fix this by using &rt2800pci_ops instead of rt2800pci_ops.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Just noticed that error while trying to compile rt2800pci for a
Ralink SoC board.

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0e4c417..f71e83b 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1225,7 +1225,7 @@ MODULE_LICENSE("GPL");
 #ifdef CONFIG_RT2800PCI_SOC
 static int rt2800soc_probe(struct platform_device *pdev)
 {
-       return rt2x00soc_probe(pdev, rt2800pci_ops);
+       return rt2x00soc_probe(pdev, &rt2800pci_ops);
 }

 static struct platform_driver rt2800soc_driver = {
