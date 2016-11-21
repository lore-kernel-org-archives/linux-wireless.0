Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34513 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754561AbcKUN3b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 08:29:31 -0500
Received: by mail-wm0-f67.google.com with SMTP id g23so2017580wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 05:29:30 -0800 (PST)
From: Tobias Regnery <tobias.regnery@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, brcm80211-dev-list.pdl@broadcom.com
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Subject: [PATCH] brcmsmac: fix array out-of-bounds access in qm_log10
Date: Mon, 21 Nov 2016 14:29:09 +0100
Message-Id: <1479734949-6300-1-git-send-email-tobias.regnery@gmail.com> (sfid-20161121_142941_975563_017C17E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get the following UBSAN warning during boot on my laptop:

================================================================================
UBSAN: Undefined behaviour in drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c:280:21
index 32 is out of range for type 's16 [32]'
CPU: 0 PID: 879 Comm: NetworkManager Not tainted 4.9.0-rc4 #28
Hardware name: LENOVO Lenovo IdeaPad N581/INVALID, BIOS 5ECN96WW(V9.01) 03/14/2013
ffff8800b74a6478 ffffffff828e59d2 0000000041b58ab3 ffffffff8398330c
ffffffff828e5920 ffff8800b74a64a0 ffff8800b74a6450 0000000000000020
1ffffffff845848c ffffed0016e94bf1 ffffffffc22c2460 000000006b9c0514
Call Trace:
[<ffffffff828e59d2>] dump_stack+0xb2/0x110
[<ffffffff828e5920>] ? _atomic_dec_and_lock+0x150/0x150
[<ffffffff82968c9d>] ubsan_epilogue+0xd/0x4e
[<ffffffff82969875>] __ubsan_handle_out_of_bounds+0xfa/0x13e
[<ffffffff8296977b>] ? __ubsan_handle_shift_out_of_bounds+0x241/0x241
[<ffffffffc0d48379>] ? bcma_host_pci_read16+0x59/0xa0 [bcma]
[<ffffffffc0d48388>] ? bcma_host_pci_read16+0x68/0xa0 [bcma]
[<ffffffffc212ad78>] ? read_phy_reg+0xe8/0x180 [brcmsmac]
[<ffffffffc2184714>] qm_log10+0x2e4/0x350 [brcmsmac]
[<ffffffffc2142eb8>] wlc_phy_init_lcnphy+0x538/0x1f20 [brcmsmac]
[<ffffffffc2142980>] ? wlc_lcnphy_periodic_cal+0x5c0/0x5c0 [brcmsmac]
[<ffffffffc1ba0c93>] ? ieee80211_open+0xb3/0x110 [mac80211]
[<ffffffff82f73a02>] ? sk_busy_loop+0x1e2/0x840
[<ffffffff82f7a6ce>] ? __dev_change_flags+0xae/0x220
...

The report is valid: doing the math in this function, with an input value
N=63 the variable s16tableIndex gets a value of 31. This value is used as
an index in the array log_table with 32 entries. But the next line is:

	s16errorApproximation = (s16) qm_mulu16(u16offset,
				(u16) (log_table[s16tableIndex + 1] -
				       log_table[s16tableIndex]));

With s16tableIndex + 1 we are trying an out-of-bounds access to the array.

The log_table array provides log2 values in q.15 format and the above
statement tries an error approximation with the next value. To fix this
issue add the next value to the array and update the comment accordingly.

Signed-off-by: Tobias Regnery <tobias.regnery@gmail.com>
---
I am not that familiar with wireless drivers and thus don't know if this
is the right way to fix the issue. But the UBSAN warning goes away with
this patch and I don't see a regression with my wireless adapter afterwards.

As far as I can tell, this bug is present since the introduction of the
driver in mainline.
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c
index faf1ebe76068..b9672da24a9d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c
@@ -179,7 +179,7 @@ s16 qm_norm32(s32 op)
 	return u16extraSignBits;
 }
 
-/* This table is log2(1+(i/32)) where i=[0:1:31], in q.15 format */
+/* This table is log2(1+(i/32)) where i=[0:1:32], in q.15 format */
 static const s16 log_table[] = {
 	0,
 	1455,
@@ -212,7 +212,8 @@ static const s16 log_table[] = {
 	29717,
 	30498,
 	31267,
-	32024
+	32024,
+	32768
 };
 
 #define LOG_TABLE_SIZE 32       /* log_table size */
-- 
2.7.4
