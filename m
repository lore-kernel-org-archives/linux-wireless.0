Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbcFDTSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 15:18:51 -0400
Subject: Patch "ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards." has been added to the 4.4-stable tree
To: linux-wireless@vittgam.net, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com, gregkh@linuxfoundation.org,
	kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	linuxbugs@vittgam.net
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sat, 04 Jun 2016 12:18:49 -0700
Message-ID: <1465067929249254@kroah.com> (sfid-20160604_211925_239486_CC135585)
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.

to the 4.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ath9k-fix-led-polarity-for-some-mini-pci-ar9220-mb92-cards.patch
and it can be found in the queue-4.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From 0f9edcdd88a993914fa1d1dc369b35dc503979db Mon Sep 17 00:00:00 2001
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
Date: Mon, 11 Apr 2016 04:48:55 +0200
Subject: ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.

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


Patches currently in stable-queue which might be from linux-wireless@vittgam.net are

queue-4.4/ath9k-add-a-module-parameter-to-invert-led-polarity.patch
queue-4.4/ath9k-fix-led-polarity-for-some-mini-pci-ar9220-mb92-cards.patch
