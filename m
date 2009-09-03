Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48322 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbZICAGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 20:06:19 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 17:06:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: claim irq for ath9k, not ath for pci
Date: Wed, 2 Sep 2009 17:06:21 -0700
Message-ID: <1251936381-16886-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k ahb requests an IRQ and indicates 'ath9k' claimed it,
ath9k pci requests an IRQ and indicates 'ath'   claims it;
since 'ath' is another module sync both ahb and pci to claim
the irq using 'ath9k'.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index bc4bc2c..8bb286d 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -187,7 +187,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* setup interrupt service routine */
 
-	ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath", sc);
+	ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
 		goto bad4;
-- 
1.6.3.3

