Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.111.66.105] ([78.111.66.105]:57014 "EHLO mx03.syneticon.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZJXP2S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 11:28:18 -0400
Message-ID: <4AE31CFC.1080803@wpkg.org>
Date: Sat, 24 Oct 2009 17:27:56 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, linux-net@vger.kernel.org,
	linux-mips@vger.kernel.org
Subject: Re: ath5k AP kernel panic when client uses SCP
References: <4AD21AB4.6010208@wpkg.org> <4AE1AC69.7010904@wpkg.org> <69e28c910910230621j2176813dpe7f77b7dff5b1b44@mail.gmail.com> <4AE1AE74.4020600@wpkg.org> <4AE2EC3E.3000503@wpkg.org> <20091024125217.GA31897@hash.localnet>
In-Reply-To: <20091024125217.GA31897@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:

>> [  516.430000] ------------[ cut here ]------------
>> [  516.430000] WARNING: at net/core/dev.c:1566 skb_gso_segment+0x110/0x298()
>> [  516.440000] b44: caps=(0x0, 0x0) len=52 data_len=0 ip_summed=1
> 
> So this looks like the ethernet driver b44 instead of ath5k, I think.

Could be, but!

I can trigger it when doing this kind of SSH traffic:

PC >--100Mbit--> b44 (Asus WL-500gP) ath5k >--wireless--> laptop


When I transfer over wired ethernet only through this device, everything 
works properly, no page allocation failures, no warnings, panics.


>> [  516.450000] Modules linked in: configs aes_generic tun sch_sfq cls_fw sch_htb ipt_MASQUERADE iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG xt_recent nf_conn1
>> [  516.480000] Call Trace:
>> [  516.480000] [<80013ac4>] dump_stack+0x8/0x34
>> [  516.480000] [<8002f2a0>] warn_slowpath_common+0x70/0x98
>> [  516.490000] [<8002f308>] warn_slowpath_fmt+0x24/0x30
>> [  516.490000] [<801f0398>] skb_gso_segment+0x110/0x298
> 
> ...but this is higher up the stack.  skb_gso_segment is about a year old
> so it would be odd if there were a bug here.  Can you do the following?
> 
> objdump -S net/core/dev.o, then find the address for skb_gso_segment, 
> it should look something like this (your numbers and disassembly will
> differ):
> 
> 00004190 <skb_gso_segment>:
>  *
>  *      It may return NULL if the skb requires no segmentation.  This is
>  *      only possible when GSO is used for verifying header integrity.
>  */

Hmm, I get:

00000000 <skb_gso_segment>

So I better leave the files here:

http://www1.wpkg.org/skb_gso_segment/

Let me know if you need anything else.


-- 
Tomasz Chmielewski
http://wpkg.org
