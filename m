Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31629 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbYJWWMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 18:12:13 -0400
Subject: ath5k: badness at net/mac80211/rx.c:2200, status->rate_idx = 255
From: Pavel Roskin <proski@gnu.org>
To: ath5k-devel@lists.ath5k.org
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 18:12:07 -0400
Message-Id: <1224799927.22806.15.camel@dv> (sfid-20081024_001225_845813_75C40765)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm seeing rare (approximately once an hour) reports of badness at
net/mac80211/rx.c:2200 with the current wireless-testing on a 32-bit
PowerPC machine.

Badness at /home/proski/src/linux-2.6/net/mac80211/rx.c:2200
NIP: c02ba388 LR: f104ae24 CTR: c02ba20c
REGS: c03c1cd0 TRAP: 0700   Not tainted  (2.6.27-wl)
MSR: 00029032 <EE,ME,IR,DR>  CR: 24004084  XER: 00000000
TASK = c03a1578[0] 'swapper' THREAD: c03c0000
GPR00: 0000000c c03c1d80 c03a1578 c18ac180 efb76b40 c03c1dd8 c1a46022 00000000 
GPR08: 00000080 c18ac040 c18acdc8 000000ff 24004082 00000000 0171e9a8 000000db 
GPR16: f1054868 f1054e8c 00000064 00008000 ea0ea0eb 00000000 c03c1dc8 c03c1dd8 
GPR24: c18afdf0 efb0c0a8 c18afdc0 00000080 c18ac180 c03c1dd8 c18acce0 efb76b40 
NIP [c02ba388] __ieee80211_rx+0x17c/0x638
LR [f104ae24] ath5k_tasklet_rx+0x2c8/0x5cc [ath5k]
Call Trace:
[c03c1d80] [2d89b700] 0x2d89b700 (unreliable)
[c03c1dc0] [f104ae24] ath5k_tasklet_rx+0x2c8/0x5cc [ath5k]
[c03c1e50] [c002e318] tasklet_action+0x80/0xfc
[c03c1e70] [c002ebf8] __do_softirq+0x8c/0xfc
[c03c1ea0] [c00062ac] do_softirq+0x58/0x5c
[c03c1eb0] [c002eaf8] irq_exit+0x84/0x88
[c03c1ec0] [c0006320] do_IRQ+0x70/0xc8
[c03c1ed0] [c00106fc] ret_from_except+0x0/0x14
--- Exception: 501 at cpu_idle+0xd8/0xe8
    LR = cpu_idle+0xd8/0xe8
[c03c1f90] [c0009188] cpu_idle+0x54/0xe8 (unreliable)
[c03c1fb0] [c02c2acc] __got2_end+0x58/0x68
[c03c1fc0] [c0371754] start_kernel+0x26c/0x2c8
[c03c1ff0] [00003438] 0x3438
Instruction dump:
6c09ffff 2f898800 419e0244 80010044 7f83e378 7f04c378 7fa5eb78 7ea6ab78 
baa10014 7c0803a6 38210040 4bfff4d4 <0fe00000> 80010044 baa10014 38210040 

Adding a printk before that line shows:
status->rate_idx = 255, sband->n_bitrates = 12

status->rate_idx is apparently wrong.  Search for rate_idx in ath5k
sources finds an array with the same name, but ignoring it, I see this
in base.c:

rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);

ath5k_hw_to_driver_rix() is simple function that takes values from the
rate_idx array, some elements of which are actually initialized with -1
in ath5k_setup_rate_idx().

While rxs.rate_idx has type int, the rate_idx array has type u8.
Perhaps it should be s8, or the value of 255 should be handled specially
if valid indices can exceed 127.

This patch is compile-tested only.  I'm leaving it overnight for
testing.

diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 06d1054..453eaec 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -112,7 +112,7 @@ struct ath5k_softc {
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
 	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
-	u8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
+	s8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
 	enum nl80211_iftype	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 


-- 
Regards,
Pavel Roskin
