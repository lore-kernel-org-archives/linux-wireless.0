Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbcFEWZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 18:25:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	Vittorio Gambaletta <linuxbugs@vittgam.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 4.5 037/128] ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.
Date: Sun,  5 Jun 2016 15:23:12 -0700
Message-Id: <20160605222322.398801416@linuxfoundation.org> (sfid-20160606_003935_700573_0CEAFD2B)
In-Reply-To: <20160605222321.183131188@linuxfoundation.org>
References: <20160605222321.183131188@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vittorio Gambaletta (VittGam) <linux-wireless@vittgam.net>

commit 0f9edcdd88a993914fa1d1dc369b35dc503979db upstream.

The Wistron DNMA-92 and Compex WLM200NX have inverted LED polarity
(active high instead of active low).

The same PCI Subsystem ID is used by both cards, which are based on
the same Atheros MB92 design.

Cc: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@qca.qualcomm.com>
Cc: <ath9k-devel@lists.ath9k.org>
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/pci.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -28,6 +28,16 @@ static const struct pci_device_id ath_pc
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


