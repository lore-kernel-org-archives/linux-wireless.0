Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17235 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422645AbcFCVrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:47:08 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: stable@vger.kernel.org, stable-commits@vger.kernel.org
Cc: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<ath9k-devel@venema.h4ckr.net>,
	Vittorio Gambaletta <linuxbugs@vittgam.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Sasha Levin <sasha.levin@oracle.com>
Subject: [added to the 3.18 stable tree] ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.
Date: Fri,  3 Jun 2016 17:45:06 -0400
Message-Id: <1464990398-17381-16-git-send-email-sasha.levin@oracle.com> (sfid-20160603_234712_122381_0C72DFC6)
In-Reply-To: <1464990398-17381-1-git-send-email-sasha.levin@oracle.com>
References: <1464990398-17381-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>

This patch has been added to the 3.18 stable tree. If you have any
objections, please let us know.

===============

[ Upstream commit 0f9edcdd88a993914fa1d1dc369b35dc503979db ]

The Wistron DNMA-92 and Compex WLM200NX have inverted LED polarity
(active high instead of active low).

The same PCI Subsystem ID is used by both cards, which are based on
the same Atheros MB92 design.

Cc: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@qca.qualcomm.com>
Cc: <ath9k-devel@lists.ath9k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c018dea..5ca08ed 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -28,6 +28,16 @@ static const struct pci_device_id ath_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x0024) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x0027) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
+
+#ifdef CONFIG_ATH9K_PCOEM
+	/* Mini PCI AR9220 MB92 cards: Compex WLM200NX, Wistron DNMA-92 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0029,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x2096),
+	  .driver_data = ATH9K_PCI_LED_ACT_HI },
+#endif
+
 	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
 
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
-- 
2.5.0

