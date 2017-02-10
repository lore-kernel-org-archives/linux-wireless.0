Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31345 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbdBJLwB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 06:52:01 -0500
Subject: [PATCH v4] ath10k: fix napi crash during rmmod when probe firmware
 fails
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 10 Feb 2017 13:51:25 +0200
Message-ID: <148672748569.28126.12259592472689214081.stgit@potku.adurom.net> (sfid-20170210_125206_043373_E487FEAF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the below crash when ath10k probe firmware fails, NAPI polling tries
to access a rx ring resource which was never allocated. An easy way to
reproduce this is easy to remove all the firmware files, load ath10k modules
and ath10k will crash when calling 'rmmod ath10k_pci'. The fix is to call
napi_enable() from ath10k_pci_hif_start() so that it matches with
napi_disable() being called from ath10k_pci_hif_stop().

Big thanks to Mohammed Shafi Shajakhan who debugged this and provided first
version of the fix. In this patch I just fix the actual problem in pci.c
instead of having a workaround in core.c.

BUG: unable to handle kernel NULL pointer dereference at (null)
IP:  __ath10k_htt_rx_ring_fill_n+0x19/0x230 [ath10k_core]
__ath10k_htt_rx_ring_fill_n+0x19/0x230 [ath10k_core]

Call Trace:

[<ffffffffa113ec62>] ath10k_htt_rx_msdu_buff_replenish+0x42/0x90
[ath10k_core]
[<ffffffffa113f393>] ath10k_htt_txrx_compl_task+0x433/0x17d0
[ath10k_core]
[<ffffffff8114406d>] ? __wake_up_common+0x4d/0x80
[<ffffffff811349ec>] ? cpu_load_update+0xdc/0x150
[<ffffffffa119301d>] ? ath10k_pci_read32+0xd/0x10 [ath10k_pci]
[<ffffffffa1195b17>] ath10k_pci_napi_poll+0x47/0x110 [ath10k_pci]
[<ffffffff817863af>] net_rx_action+0x20f/0x370

Reported-by: Ben Greear <greearb@candelatech.com>
Fixes: 3c97f5de1f28 ("ath10k: implement NAPI support")
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 5d2f9b9922d3..6094372307aa 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1651,6 +1651,8 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
+	napi_enable(&ar->napi);
+
 	ath10k_pci_irq_enable(ar);
 	ath10k_pci_rx_post(ar);
 
@@ -2535,7 +2537,6 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		ath10k_err(ar, "could not wake up target CPU: %d\n", ret);
 		goto err_ce;
 	}
-	napi_enable(&ar->napi);
 
 	return 0;
 
