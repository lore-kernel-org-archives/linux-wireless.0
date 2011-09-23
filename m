Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33142 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1IWJD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 05:03:56 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix a dma warning/memory leak
Date: Fri, 23 Sep 2011 14:33:14 +0530
Message-ID: <1316768594-8539-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110923_110401_795120_38E33BE4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

proper dma_unmapping and freeing of skb's has to be done in the rx
cleanup for EDMA chipsets when the device is unloaded and this also
seems to address the following warning which shows up occasionally when
the device is unloaded

	Call Trace:
	[<c0148cd2>] warn_slowpath_common+0x72/0xa0
	[<c03b669c>] ? dma_debug_device_change+0x19c/0x200
	[<c03b669c>] ? dma_debug_device_change+0x19c/0x200
	[<c0148da3>] warn_slowpath_fmt+0x33/0x40
	[<c03b669c>] dma_debug_device_change+0x19c/0x200
	[<c0657f12>] notifier_call_chain+0x82/0xb0
	[<c0171370>] __blocking_notifier_call_chain+0x60/0x90
	[<c01713bf>] blocking_notifier_call_chain+0x1f/0x30
	[<c044f594>] __device_release_driver+0xa4/0xc0
	[<c044f647>] driver_detach+0x97/0xa0
	[<c044e65c>] bus_remove_driver+0x6c/0xe0
	[<c029af0b>] ? sysfs_addrm_finish+0x4b/0x60
	[<c0450109>] driver_unregister+0x49/0x80
	[<c0299f54>] ? sysfs_remove_file+0x14/0x20
	[<c03c3ab2>] pci_unregister_driver+0x32/0x80
	[<f92c2162>] ath_pci_exit+0x12/0x20 [ath9k]
	[<f92c8467>] ath9k_exit+0x17/0x36 [ath9k]
	[<c06523cd>] ? mutex_unlock+0xd/0x10
	[<c018e27f>] sys_delete_module+0x13f/0x200
	[<c02139bb>] ? sys_munmap+0x4b/0x60
	[<c06547c5>] ? restore_all+0xf/0xf
	[<c0657a20>] ? spurious_fault+0xe0/0xe0
	[<c01832f4>] ? trace_hardirqs_on_caller+0xf4/0x180
	[<c065b863>] sysenter_do_call+0x12/0x38
	 ---[ end trace 16e1c1521c06bcf9 ]---
	Mapped at:
	[<c03b7938>] debug_dma_map_page+0x48/0x120
	[<f92ba3e8>] ath_rx_init+0x3f8/0x4b0 [ath9k]
	[<f92b5ae4>] ath9k_init_device+0x4c4/0x7b0 [ath9k]
	[<f92c2813>] ath_pci_probe+0x263/0x330 [ath9k]

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index bcc0b22..4984350 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -205,14 +205,22 @@ static void ath_rx_remove_buffer(struct ath_softc *sc,
 
 static void ath_rx_edma_cleanup(struct ath_softc *sc)
 {
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf;
 
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_HP);
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-		if (bf->bf_mpdu)
+		if (bf->bf_mpdu) {
+			dma_unmap_single(sc->dev, bf->bf_buf_addr,
+					common->rx_bufsize,
+					DMA_BIDIRECTIONAL);
 			dev_kfree_skb_any(bf->bf_mpdu);
+			bf->bf_buf_addr = 0;
+			bf->bf_mpdu = NULL;
+		}
 	}
 
 	INIT_LIST_HEAD(&sc->rx.rxbuf);
-- 
1.7.0.4

