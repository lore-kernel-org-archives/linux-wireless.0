Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:43122 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdBMP5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 10:57:10 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        Sven Eckelmann <sven@narfation.org>,
        Akash Goel <akash.goel@intel.com>,
        Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH] ath9k: Access rchan::buf only with per_cpu helper
Date: Mon, 13 Feb 2017 16:56:48 +0100
Message-Id: <20170213155648.4821-1-sven@narfation.org> (sfid-20170213_165757_133654_7CB62647)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The relayfs was changed to use per CPU constructs to handle the rchan
buffers. But the users of the rchan buffers in other parts of the kernel
were not modified. This caused crashes like

  BUG: unable to handle kernel paging request at 00003a5198a0b910
  IP: [<ffffffffa973cb3a>] ath_cmn_process_fft+0xea/0x610
  PGD 0 [  179.522449]
  Oops: 0000 [#1] SMP
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.9.0-rc5 #1
  [...]
  Call Trace:
   <IRQ> [  179.656426]  [<ffffffffa9704373>] ? ath_rx_tasklet+0x2f3/0xd10
   [<ffffffffa9702106>] ? ath9k_tasklet+0x1b6/0x230
   [<ffffffffa90dcbd1>] ? tasklet_action+0xf1/0x100
   [<ffffffffa9a3cb3f>] ? __do_softirq+0xef/0x284
   [<ffffffffa90dd22e>] ? irq_exit+0xae/0xb0
   [<ffffffffa9a3c89f>] ? do_IRQ+0x4f/0xd0
   [<ffffffffa9a3aa42>] ? common_interrupt+0x82/0x82
   <EOI> [  179.703152]  [<ffffffffa9a39c1d>] ? poll_idle+0x2d/0x57
   [<ffffffffa908c845>] ? sched_clock+0x5/0x10
   [<ffffffffa97bc8d6>] ? cpuidle_enter_state+0xf6/0x2d0
   [<ffffffffa911988e>] ? cpu_startup_entry+0x14e/0x230
   [<ffffffffaa3cdf70>] ? start_kernel+0x461/0x481
   [<ffffffffaa3cd120>] ? early_idt_handler_array+0x120/0x120
   [<ffffffffaa3cd413>] ? x86_64_start_kernel+0x14c/0x170
  Code: 31 db 41 be ff ff ff ff 4c 8b 26 48 8b 6e 08 49 8b 84 24 60 05 00
        00 48 8b 00 0f b7 40 04 66 89 44 24 48 eb 11 48 8b 55 40 48 98 <48>
        8b 3c c2 e8 ad a0 a4 ff 01 c3 41 8d 56 01 be 00 02 00 00 48
  RIP  [<ffffffffa973cb3a>] ath_cmn_process_fft+0xea/0x610
   RSP <ffff9b43e7003d20>
  CR2: 00003a5198a0b910

Fixes: 017c59c042d0 ("relay: Use per CPU constructs for the relay channel buffer pointers")
Cc: Akash Goel <akash.goel@intel.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Reported-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 789a3dbe8341..0ffa23a61568 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -482,7 +482,7 @@ ath_cmn_is_fft_buf_full(struct ath_spec_scan_priv *spec_priv)
 	struct rchan *rc = spec_priv->rfs_chan_spec_scan;
 
 	for_each_online_cpu(i)
-		ret += relay_buf_full(rc->buf[i]);
+		ret += relay_buf_full(*per_cpu_ptr(rc->buf, i));
 
 	i = num_online_cpus();
 
