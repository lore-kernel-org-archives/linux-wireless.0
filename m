Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZFHXTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 19:19:17 -0400
Date: Mon, 8 Jun 2009 19:19:19 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BUG at net/wireless/reg.c:2132 on PowerPC
Message-ID: <20090608231919.GC23972@bombadil.infradead.org>
References: <1244501988.25158.57.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244501988.25158.57.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 08, 2009 at 06:59:48PM -0400, Pavel Roskin wrote:
> ------------[ cut here ]------------
> kernel BUG at /home/proski/src/linux-2.6/net/wireless/reg.c:2132!
> Oops: Exception in kernel mode, sig: 5 [#1]
> PowerMac
> Modules linked in: ath5k ath [last unloaded: scsi_wait_scan]
> NIP: c02f3eac LR: c02f3d08 CTR: 00000000
> REGS: ef107aa0 TRAP: 0700   Not tainted  (2.6.30-rc8-wl)
> MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 88002442  XER: 20000000
> TASK = ef84acb0[834] 'crda' THREAD: ef106000
> GPR00: ef953840 ef107b50 ef84acb0 ef1380bc 00000006 c035a5c8 ef107b90 c035a5c8 
> GPR08: 00080005 efb68980 c0445628 ef130004 28002422 10019ce0 10012d3c 00000001 
> GPR16: 1070b2ac 00000005 48023558 1070b380 4802304c 00000000 ef107ddc c035a5c8 
> GPR24: ef107b78 c0443350 ef8bcb00 00000005 ef138080 c04a6a70 c04a0000 ef8bcb00 
> NIP [c02f3eac] set_regdom+0x4c4/0x4ec
> LR [c02f3d08] set_regdom+0x320/0x4ec
> Call Trace:
> [ef107b50] [c02f3d08] set_regdom+0x320/0x4ec (unreliable)
> [ef107b70] [c02f9d10] nl80211_set_reg+0x140/0x2d0
> [ef107bc0] [c02aa2b8] genl_rcv_msg+0x204/0x228
> [ef107c10] [c02a97cc] netlink_rcv_skb+0xe8/0x10c
> [ef107c30] [c02aa094] genl_rcv+0x3c/0x5c
> [ef107c40] [c02a9050] netlink_unicast+0x308/0x36c
> [ef107c80] [c02a92bc] netlink_sendmsg+0x208/0x2f0
> [ef107cd0] [c0282048] sock_sendmsg+0xac/0xe4
> [ef107db0] [c02822b4] sys_sendmsg+0x234/0x2d8
> [ef107f00] [c0283a88] sys_socketcall+0x108/0x258
> [ef107f40] [c0012790] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfa6b3b4
>     LR = 0xfb4b5d4
> Instruction dump:
> 80690000 4bffc1e9 2c030000 4182003c 88a30039 88830038 3c60c03c 38632a18 
> 4802c20d 4bfffed0 7f83e378 8403003c <0f000000> 7fe4fb78 4bffe6d1 7c7b1b79 
> ---[ end trace c8eebdfbe3eb31de ]---
> 
> net/wireless/reg.c:2132 is:
> 
> BUG_ON(request_wiphy->regd);

Thank you for reporting this, try loading the system without ath5k present
(mv ath5k.ko ath5k.ignore is an easy way) then prior to loadin git in a window
get 'iw event' running.

I'm pretty sure this is another case of the kernel/userspace sending
two replies. In such a case we just drop as follows. 'iw event' will tell
us more.

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ea4c299..5e14371 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2129,7 +2129,12 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		 * driver wanted to the wiphy to deal with conflicts
 		 */
 
-		BUG_ON(request_wiphy->regd);
+		/*
+		 * Userspace could have sent two replies with only
+		 * one kernel request.
+		 */
+		if (request_wiphy->regd)
+			return -EALREADY;
 
 		r = reg_copy_regd(&request_wiphy->regd, rd);
 		if (r)
