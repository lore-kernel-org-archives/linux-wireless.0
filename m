Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49294 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbcCHDTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 22:19:49 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH] ath9k: fix reg dump data bus error
Date: Tue,  8 Mar 2016 11:19:37 +0800
Message-Id: <1457407177-11438-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160308_041953_702594_017AA17B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Changes:
 - restrict only dump MAC registers
 - skip the register memory holes

Data bus error, epc == 831d4040, ra == 831d403c
Oops[#1]:
CPU: 0 PID: 1536 Comm: cat Not tainted 3.14.0 #3
task: 82f87840 ti: 82f88000 task.ti: 82f88000
$ 0   : 00000000 00000001 deadc0de 1000fc03
$ 4   : b8100200 00000200 831e0000 80218788
$ 8   : 00000030 00000003 00000001 09524547
$12   : 00000000 810594f4 00000000 3a206d61
$16   : 831dd3c0 00000081 00000a00 c05ff000
$20   : 00005af6 00000200 00071b39 00071139
$24   : 00000001 80217760
$28   : 82f88000 82f89c60 c05ffa00 831d403c
Hi    : 00000000
Lo    : 453c0000
epc   : 831d4040 ath_ahb_exit+0x2198/0x2904 [ath9k]
	Not tainted
ra    : 831d403c ath_ahb_exit+0x2194/0x2904 [ath9k]
Status: 1000fc03	KERNEL EXL IE
Cause : 4080801c
PrId  : 00019374 (MIPS 24Kc)
Stack : 00000001 00000000 0000000e 80475c60 0000000e 800a8ebc 00000000 00000000
	00000001 00000007 00000000 800a9678 00000000 00000004 00000002 00000010
	00000000 00000000 00000000 00000000 80475c60 0000000e 000009ec c05ff000
	831dd3c0 00000080 00000a00 c05ff000 00005af6 00000200 00071b39 0007114d
	c05ff9ec 800a9904 831dd3c0 82f89d10 00000001 81082194 831d8f0c 82f89d14
	...
	Call Trace:
	[<831d4040>] ath_ahb_exit+0x2198/0x2904 [ath9k]
	[<831d403c>] ath_ahb_exit+0x2194/0x2904 [ath9k]

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 6de64cf..c56e40f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -916,10 +916,21 @@ static int open_file_regdump(struct inode *inode, struct file *file)
 	struct ath_softc *sc = inode->i_private;
 	unsigned int len = 0;
 	u8 *buf;
-	int i;
+	int i, j = 0;
 	unsigned long num_regs, regdump_len, max_reg_offset;
+	const struct reg_hole {
+		u32 start;
+		u32 end;
+	} reg_hole_list[] = {
+		{0x0200, 0x07fc},
+		{0x0c00, 0x0ffc},
+		{0x2000, 0x3ffc},
+		{0x4100, 0x6ffc},
+		{0x705c, 0x7ffc},
+		{0x0000, 0x0000}
+	};
 
-	max_reg_offset = AR_SREV_9300_20_OR_LATER(sc->sc_ah) ? 0x16bd4 : 0xb500;
+	max_reg_offset = AR_SREV_9300_20_OR_LATER(sc->sc_ah) ? 0x8800 : 0xb500;
 	num_regs = max_reg_offset / 4 + 1;
 	regdump_len = num_regs * REGDUMP_LINE_SIZE + 1;
 	buf = vmalloc(regdump_len);
@@ -927,9 +938,16 @@ static int open_file_regdump(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	ath9k_ps_wakeup(sc);
-	for (i = 0; i < num_regs; i++)
+	for (i = 0; i < num_regs; i++) {
+		if (reg_hole_list[j].start == i << 2) {
+			i = reg_hole_list[j].end >> 2;
+			j++;
+			continue;
+		}
+
 		len += scnprintf(buf + len, regdump_len - len,
 			"0x%06x 0x%08x\n", i << 2, REG_READ(sc->sc_ah, i << 2));
+	}
 	ath9k_ps_restore(sc);
 
 	file->private_data = buf;
-- 
1.9.1

