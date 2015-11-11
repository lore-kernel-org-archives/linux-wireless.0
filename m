Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:59981 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbbKKMBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 07:01:48 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: poll HTT send completion when CE 5 is unused
Date: Wed, 11 Nov 2015 17:31:26 +0530
Message-ID: <1447243286-22116-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151111_130159_708538_32C5D581)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit a70587b3389a ("ath10k: configure copy engine 5 for HTT messages")
moved send completion polling under HTT Rx (CE 5) service routine. For
QCA6174 based devices copy engine 1 (CE 1) is used for HTT Rx instead
of CE 5. So send completion never be called. This is causing "failed to
transmit packet, dropping: -105" errors. Fix this by processing send
completion from CE 1 service routine instead of CE 5.

Tested-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 5c91a67..698e669 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -112,6 +112,7 @@ static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state);
 static void ath10k_pci_htt_tx_cb(struct ath10k_ce_pipe *ce_state);
 static void ath10k_pci_htt_rx_cb(struct ath10k_ce_pipe *ce_state);
 static void ath10k_pci_pktlog_rx_cb(struct ath10k_ce_pipe *ce_state);
+static void ath10k_pci_htt_htc_rx_cb(struct ath10k_ce_pipe *ce_state);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
@@ -129,7 +130,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
 		.src_nentries = 0,
 		.src_sz_max = 2048,
 		.dest_nentries = 512,
-		.recv_cb = ath10k_pci_htc_rx_cb,
+		.recv_cb = ath10k_pci_htt_htc_rx_cb,
 	},
 
 	/* CE2: target->host WMI */
@@ -1210,6 +1211,16 @@ static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state)
 	ath10k_pci_process_rx_cb(ce_state, ath10k_htc_rx_completion_handler);
 }
 
+static void ath10k_pci_htt_htc_rx_cb(struct ath10k_ce_pipe *ce_state)
+{
+	/* CE4 polling needs to be done whenever CE pipe which transports
+	 * HTT Rx (target->host) is processed.
+	 */
+	ath10k_ce_per_engine_service(ce_state->ar, 4);
+
+	ath10k_pci_process_rx_cb(ce_state, ath10k_htc_rx_completion_handler);
+}
+
 /* Called by lower (CE) layer when data is received from the Target.
  * Only 10.4 firmware uses separate CE to transfer pktlog data.
  */
-- 
2.6.2

