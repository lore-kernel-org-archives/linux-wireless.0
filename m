Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23938 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbcDZQCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 12:02:53 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	Anilkumar Kolli <akolli@qti.qualcomm.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] ath10k: fix kernel panic, move arvifs list head init before htt init
Date: Tue, 26 Apr 2016 21:35:48 +0530
Message-ID: <1461686748-862-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20160426_180307_753397_25DA0EE2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

It is observed that while loading and unloading ath10k modules
in an infinite loop, before ath10k_core_start() completion HTT
rx frames are received, while processing these frames,
dereferencing the arvifs list code is getting hit before
initilizing the arvifs list, causing a kernel panic.

This patch initilizes the arvifs list before initilizing htt.

Fixes the below issue:
 [<bf88b058>] (ath10k_htt_rx_pktlog_completion_handler+0x278/0xd08 [ath10k_core])
 [<bf88b058>] (ath10k_htt_rx_pktlog_completion_handler [ath10k_core])
 [<bf88c0dc>] (ath10k_htt_txrx_compl_task+0x5f4/0xeb0 [ath10k_core])
 [<bf88c0dc>] (ath10k_htt_txrx_compl_task [ath10k_core])
 [<c0234100>] (tasklet_action+0x8c/0xec)
 [<c0234100>] (tasklet_action)
 [<c02337c0>] (__do_softirq+0xf8/0x228)
 [<c02337c0>] (__do_softirq)  [<c0233920>] (run_ksoftirqd+0x30/0x90)
 Code: e5954ad8 e2899008 e1540009 0a00000d (e5943008)
 ---[ end trace 71de5c2e011dbf56 ]---
 Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 500ff9f9389d ("ath10k: implement chanctx API")
Cc: stable@vger.kernel.org

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b2c7fe3d30a4..83e02f292828 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1822,6 +1822,10 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 		goto err_hif_stop;
 	}
 
+	ar->free_vdev_map = (1LL << ar->max_num_vdevs) - 1;
+
+	INIT_LIST_HEAD(&ar->arvifs);
+
 	/* we don't care about HTT in UTF mode */
 	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
 		status = ath10k_htt_setup(&ar->htt);
@@ -1835,10 +1839,6 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 	if (status)
 		goto err_hif_stop;
 
-	ar->free_vdev_map = (1LL << ar->max_num_vdevs) - 1;
-
-	INIT_LIST_HEAD(&ar->arvifs);
-
 	return 0;
 
 err_hif_stop:
-- 
1.7.9.5

