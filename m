Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50682 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbcFIVRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 17:17:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	kernel-team@lists.ubuntu.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org,
	Vittorio Gambaletta <linuxbugs@vittgam.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 4.2.y-ckt 030/206] ath9k: Fix LED polarity for some Mini PCI AR9220 MB92 cards.
Date: Thu,  9 Jun 2016 14:13:59 -0700
Message-Id: <1465507015-23052-31-git-send-email-kamal@canonical.com> (sfid-20160610_001357_421348_AD8A565E)
In-Reply-To: <1465507015-23052-1-git-send-email-kamal@canonical.com>
References: <1465507015-23052-1-git-send-email-kamal@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4.2.8-ckt12 -stable review patch.  If anyone has any objections, please let me know.

---8<------------------------------------------------------------

From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>

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

