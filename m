Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbcFIOdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 10:33:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org,
	Vittorio Gambaletta <linuxbugs@vittgam.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Kamal Mostafa <kamal@canonical.com>,
	kernel-team@lists.ubuntu.com
Subject: [4.2.y-ckt stable] Patch "ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards." has been added to the 4.2.y-ckt tree
Date: Thu,  9 Jun 2016 07:33:34 -0700
Message-Id: <1465482814-19920-1-git-send-email-kamal@canonical.com> (sfid-20160609_163347_402743_255B46B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a note to let you know that I have just added a patch titled

    ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.

to the linux-4.2.y-queue branch of the 4.2.y-ckt extended stable tree 
which can be found at:

    https://git.launchpad.net/~canonical-kernel/linux/+git/linux-stable-ckt/log/?h=linux-4.2.y-queue

This patch is scheduled to be released in version 4.2.8-ckt12.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 4.2.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

---8<------------------------------------------------------------

>From b2ad7e11502a0c9ac8044b167751ea629fff98db Mon Sep 17 00:00:00 2001
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
Date: Mon, 11 Apr 2016 04:48:55 +0200
Subject: ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index e6fef1b..7cdaf40 100644
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
--
2.7.4

