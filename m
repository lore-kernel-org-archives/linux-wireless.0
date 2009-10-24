Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2836 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbZJXMwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 08:52:49 -0400
Date: Sat, 24 Oct 2009 08:52:17 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org,
	linux-mips@vger.kernel.org
Subject: Re: ath5k AP kernel panic when client uses SCP
Message-ID: <20091024125217.GA31897@hash.localnet>
References: <4AD21AB4.6010208@wpkg.org> <4AE1AC69.7010904@wpkg.org> <69e28c910910230621j2176813dpe7f77b7dff5b1b44@mail.gmail.com> <4AE1AE74.4020600@wpkg.org> <4AE2EC3E.3000503@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4AE2EC3E.3000503@wpkg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I'll recompile...
>
> Is this one more useful?

Much!  Thanks.

> [  516.430000] ------------[ cut here ]------------
> [  516.430000] WARNING: at net/core/dev.c:1566 skb_gso_segment+0x110/0x298()
> [  516.440000] b44: caps=(0x0, 0x0) len=52 data_len=0 ip_summed=1

So this looks like the ethernet driver b44 instead of ath5k, I think.

> [  516.450000] Modules linked in: configs aes_generic tun sch_sfq cls_fw sch_htb ipt_MASQUERADE iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG xt_recent nf_conn1
> [  516.480000] Call Trace:
> [  516.480000] [<80013ac4>] dump_stack+0x8/0x34
> [  516.480000] [<8002f2a0>] warn_slowpath_common+0x70/0x98
> [  516.490000] [<8002f308>] warn_slowpath_fmt+0x24/0x30
> [  516.490000] [<801f0398>] skb_gso_segment+0x110/0x298

...but this is higher up the stack.  skb_gso_segment is about a year old
so it would be odd if there were a bug here.  Can you do the following?

objdump -S net/core/dev.o, then find the address for skb_gso_segment, 
it should look something like this (your numbers and disassembly will
differ):

00004190 <skb_gso_segment>:
 *
 *      It may return NULL if the skb requires no segmentation.  This is
 *      only possible when GSO is used for verifying header integrity.
 */
struct sk_buff *skb_gso_segment(struct sk_buff *skb, int features)
{
    4190:       55                      push   %ebp
    4191:       89 e5                   mov    %esp,%ebp
    4193:       57                      push   %edi
    4194:       56                      push   %esi

Then find whatever 0x4190 (your offset here) + 0x110 is, and pick about
10 lines before and after that and paste it -- the opcodes in the second
column should match up with the code lines below:

> [  516.650000] [  516.650000] [  516.650000] Code: 3c048007  08010d50  
> 248436fc <8c820000> 3042c000  10400003  00803821  0801ca7f  00000000 [  

Or you can send me the whole objdump -S output off-list if that's easier.

-- 
Bob Copeland %% www.bobcopeland.com

