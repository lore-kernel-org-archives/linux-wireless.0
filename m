Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:51960 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbdAPDGm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Jan 2017 22:06:42 -0500
Date: Mon, 16 Jan 2017 04:06:25 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 09/14] rt2x00: rt2x00pci: set PCI MWI only if supported
Message-ID: <20170116030613.GA32249@makrotopia.org> (sfid-20170116_040644_867064_96322458)
References: <874m114lwq.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874m114lwq.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Claudio Mignanti <c.mignanti@gmail.com>

This is needed for devices without support for PCI MWI. See also
https://dev.openwrt.org/changeset/21850

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
index eb6dbcd4fddf..4becfeb75ba8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.c
@@ -94,8 +94,10 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 
 	pci_set_master(pci_dev);
 
+#ifdef CONFIG_PCI_SET_MWI
 	if (pci_set_mwi(pci_dev))
 		rt2x00_probe_err("MWI not available\n");
+#endif
 
 	if (dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32))) {
 		rt2x00_probe_err("PCI DMA not supported\n");
-- 
2.11.0
