Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:61734 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1GTRNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 13:13:41 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so2056296fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 10:13:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Pavel Roskin <proski@gnu.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3 V3] b43: bcma: get DMA translation bits
Date: Wed, 20 Jul 2011 19:52:16 +0200
Message-Id: <1311184336-3633-3-git-send-email-zajec5@gmail.com> (sfid-20110720_191349_525358_A85B5DB9)
In-Reply-To: <1311184336-3633-1-git-send-email-zajec5@gmail.com>
References: <1311184336-3633-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/dma.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 997d3ad..60c6b61 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1057,6 +1057,11 @@ int b43_dma_init(struct b43_wldev *dev)
 		return err;
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		dma->translation = bcma_core_dma_translation(dev->dev->bdev);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		dma->translation = ssb_dma_translation(dev->dev->sdev);
-- 
1.7.3.4

