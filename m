Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40904 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab3H3MaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 08:30:10 -0400
Subject: [PATCH 1/7] ath10k: pci: make host_ce_config_wlan[] more readable
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 15:30:07 +0300
Message-ID: <20130830123007.31164.84922.stgit@localhost6.localdomain6> (sfid-20130830_143014_600946_67524167)
In-Reply-To: <20130830122905.31164.50662.stgit@localhost6.localdomain6>
References: <20130830122905.31164.50662.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's much more readable if struct entries in host_ce_config_wlan
are explicitly set.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   81 ++++++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e29213b..cf7a3e4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -58,24 +58,69 @@ static int ath10k_pci_start_intr(struct ath10k *ar);
 static void ath10k_pci_stop_intr(struct ath10k *ar);
 
 static const struct ce_attr host_ce_config_wlan[] = {
-	/* host->target HTC control and raw streams */
-	{ /* CE0 */ CE_ATTR_FLAGS, 16, 256, 0 },
-	/* could be moved to share CE3 */
-	/* target->host HTT + HTC control */
-	{ /* CE1 */ CE_ATTR_FLAGS, 0, 512, 512 },
-	/* target->host WMI */
-	{ /* CE2 */ CE_ATTR_FLAGS, 0, 2048, 32 },
-	/* host->target WMI */
-	{ /* CE3 */ CE_ATTR_FLAGS, 32, 2048, 0 },
-	/* host->target HTT */
-	{ /* CE4 */ CE_ATTR_FLAGS | CE_ATTR_DIS_INTR,
-		    CE_HTT_H2T_MSG_SRC_NENTRIES, 256, 0 },
-	/* unused */
-	{ /* CE5 */ CE_ATTR_FLAGS, 0, 0, 0 },
-	/* Target autonomous hif_memcpy */
-	{ /* CE6 */ CE_ATTR_FLAGS, 0, 0, 0 },
-	/* ce_diag, the Diagnostic Window */
-	{ /* CE7 */ CE_ATTR_FLAGS, 2, DIAG_TRANSFER_LIMIT, 2 },
+	/* CE0: host->target HTC control and raw streams */
+	{
+		.flags = CE_ATTR_FLAGS,
+		.src_nentries = 16,
+		.src_sz_max = 256,
+		.dest_nentries = 0,
+	},
+
+	/* CE1: target->host HTT + HTC control */
+	{
+		.flags = CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 512,
+		.dest_nentries = 512,
+	},
+
+	/* CE2: target->host WMI */
+	{
+		.flags = CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 2048,
+		.dest_nentries = 32,
+	},
+
+	/* CE3: host->target WMI */
+	{
+		.flags = CE_ATTR_FLAGS,
+		.src_nentries = 32,
+		.src_sz_max = 2048,
+		.dest_nentries = 0,
+	},
+
+	/* CE4: host->target HTT */
+	{
+		.flags = CE_ATTR_FLAGS | CE_ATTR_DIS_INTR,
+		.src_nentries = CE_HTT_H2T_MSG_SRC_NENTRIES,
+		.src_sz_max = 256,
+		.dest_nentries = 0,
+	},
+
+	/* CE5: unused */
+	{
+		.flags = CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 0,
+		.dest_nentries = 0,
+	},
+
+	/* CE6: target autonomous hif_memcpy */
+	{
+		.flags = CE_ATTR_FLAGS,
+		.src_nentries = 0,
+		.src_sz_max = 0,
+		.dest_nentries = 0,
+	},
+
+	/* CE7: ce_diag, the Diagnostic Window */
+	{
+		.flags = CE_ATTR_FLAGS,
+		.src_nentries = 2,
+		.src_sz_max = DIAG_TRANSFER_LIMIT,
+		.dest_nentries = 2,
+	},
 };
 
 /* Target firmware's Copy Engine configuration. */

