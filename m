Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server1.vittgam.net ([213.239.197.142]:14450 "EHLO
	mail.vittgam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbcDKC4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 22:56:14 -0400
Date: Mon, 11 Apr 2016 04:48:55 +0200
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
To: <kvalo@codeaurora.org>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<ath9k-devel@venema.h4ckr.net>, <stable@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.
Content-Type: text/plain; charset=UTF-8
Message-ID: <ath9k-patch-20160411-2@vittgam.net> (sfid-20160411_045616_954167_BC649C1D)
In-Reply-To: <ath9k-patch-20160411-1@vittgam.net>
References: <ath9k-patch-20160411-1@vittgam.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Wistron DNMA-92 and Compex WLM200NX have inverted LED polarity
(active high instead of active low).

The same PCI Subsystem ID is used by both cards, which are based on
the same Atheros MB92 design.

Cc: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@qca.qualcomm.com>
Cc: <ath9k-devel@lists.ath9k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
---

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
 
 #ifdef CONFIG_ATH9K_PCOEM

