Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:55174 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab0ESGsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 02:48:10 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1426965fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 23:48:08 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: don't use to_pci_dev in rt2x00pci_uninitialize
Date: Wed, 19 May 2010 08:47:59 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005190847.59068.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't use to_pci_dev in rt2x00pci_uninitialize to get the allocated irq
as it won't work for platform devices (SoC). Instead, use the irq field
that's already used everywhere else.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index a016f7c..f71eee6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -206,7 +206,7 @@ void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Free irq line.
 	 */
-	free_irq(to_pci_dev(rt2x00dev->dev)->irq, rt2x00dev);
+	free_irq(rt2x00dev->irq, rt2x00dev);
 
 	/*
 	 * Free DMA
-- 
1.6.4.2

