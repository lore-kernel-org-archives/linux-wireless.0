Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58586 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab0HMWri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Aug 2010 18:47:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ipw2100: don't sync status queue entries
Date: Fri, 13 Aug 2010 18:47:33 -0400
Message-Id: <1281739653-2180-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are allocated with pci_alloc_consistent, so calling
pci_dma_sync_single_for_cpu is incorrect usage of the API.  Remove this
misuse and consequently avoid the following backtrace:

WARNING: at lib/dma-debug.c:902 check_sync+0xce/0x43a()
Hardware name: 2373HU6
ipw2100 0000:02:02.0: DMA-API: device driver tries to sync DMA memory it has not allocated [device address=0x0000000034e88008] [size=8 bytes]
Modules linked in: microcode ipw2100(+) snd_seq_device ppdev libipw nsc_ircc snd_pcm lib80211 video output irda parport_pc cfg80211 parport thinkpad_acpi e1000 iTCO_wdt crc_ccitt snd_timer iTCO_vendor_support snd i2c_i801 pcspkr rfkill soundcore joydev snd_page_alloc yenta_socket radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Tainted: G        W   2.6.35-wl+ #8
Call Trace:
 [<c043aa42>] warn_slowpath_common+0x6a/0x7f
 [<c05d252a>] ? check_sync+0xce/0x43a
 [<c043aaca>] warn_slowpath_fmt+0x2b/0x2f
 [<c05d252a>] check_sync+0xce/0x43a
 [<c046189a>] ? print_lock_contention_bug+0x11/0xb2
 [<c05d2b6f>] debug_dma_sync_single_for_cpu+0x47/0x49
 [<c06cbd3c>] ? ehci_irq+0x31/0x331
 [<f82a224a>] ? ipw2100_irq_tasklet+0x24/0x5e9 [ipw2100]
 [<f82a224a>] ? ipw2100_irq_tasklet+0x24/0x5e9 [ipw2100]
 [<f82a221d>] pci_dma_sync_single_for_cpu.clone.1+0x42/0x4b [ipw2100]
 [<f82a23a2>] ipw2100_irq_tasklet+0x17c/0x5e9 [ipw2100]
 [<c043fd87>] tasklet_action+0x78/0xcb
 [<c0440293>] __do_softirq+0xc4/0x183
 [<c044038d>] do_softirq+0x3b/0x5f
 [<c04404d0>] irq_exit+0x3a/0x6d
 [<c0404423>] do_IRQ+0x8b/0x9f
 [<c04038b5>] common_interrupt+0x35/0x3c
 [<c062ecfa>] ? acpi_idle_enter_simple+0xfe/0x13c
 [<c045007b>] ? exit_itimers+0x2d/0x73
 [<c062ecfc>] ? acpi_idle_enter_simple+0x100/0x13c
 [<c070bf10>] cpuidle_idle_call+0x78/0xdc
 [<c040251c>] cpu_idle+0x9b/0xb7
 [<c07b1dd2>] rest_init+0xa6/0xab
 [<c0a4b96d>] start_kernel+0x389/0x38e
 [<c0a4b0c9>] i386_start_kernel+0xc9/0xd0

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 1189dbb..996e9d7 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -2723,14 +2723,6 @@ static void __ipw2100_rx_process(struct ipw2100_priv *priv)
 
 		packet = &priv->rx_buffers[i];
 
-		/* Sync the DMA for the STATUS buffer so CPU is sure to get
-		 * the correct values */
-		pci_dma_sync_single_for_cpu(priv->pci_dev,
-					    sq->nic +
-					    sizeof(struct ipw2100_status) * i,
-					    sizeof(struct ipw2100_status),
-					    PCI_DMA_FROMDEVICE);
-
 		/* Sync the DMA for the RX buffer so CPU is sure to get
 		 * the correct values */
 		pci_dma_sync_single_for_cpu(priv->pci_dev, packet->dma_addr,
-- 
1.7.2.1

