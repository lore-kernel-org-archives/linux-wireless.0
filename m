Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43687 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZK3WfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 17:35:25 -0500
Received: by fxm5 with SMTP id 5so4309247fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 14:35:31 -0800 (PST)
Subject: Re: Panic in iwl3945 driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1259617333.4653.91.camel@rc-desk>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>  <1259617333.4653.91.camel@rc-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 00:35:26 +0200
Message-ID: <1259620526.6559.34.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-30 at 13:42 -0800, reinette chatre wrote: 
> On Mon, 2009-11-30 at 07:55 -0800, Maxim Levitsky wrote:
> > > This is some very unpleasant problem.
> > > The thing is that this happens very rarely, and while you use X.
> > > I had recently few such embarrassing kernel panics (I never had any
> > > random and rare kernel panics) and I strongly suspect them to be of same
> > > origin.
> > >
> > > This one is first I captured, due to some code that I wrote recently
> > > that saves printk buffer in predefined location in system ram that isn't
> > > cleared on reboot in my notebook.
> > >
> > > I had put some NULL checks in iwl3945_rx_reply_tx, none did trigger yet,
> > > nor I had another kernel panic.
> 
> Did this problem happen with your NULL checks in place? Can you perhaps
> help here with which line the problem occurred? Any idea how to trigger
> this?

Second one is with the NULL checks.
It is very rare, it seems to be related to playing music, and using
wireless at same time, although both use MSI here.


Now did some disassembly, and this is the results:


......
0x0000000000016652 <iwl3945_rx_reply_tx+242>:	callq  0x16657 <iwl3945_rx_reply_tx+247>
0x0000000000016657 <iwl3945_rx_reply_tx+247>:	nopw   0x0(%rax,%rax,1)
0x0000000000016660 <iwl3945_rx_reply_tx+256>:	add    $0x48,%rsp
0x0000000000016664 <iwl3945_rx_reply_tx+260>:	pop    %rbx
0x0000000000016665 <iwl3945_rx_reply_tx+261>:	pop    %r12
0x0000000000016667 <iwl3945_rx_reply_tx+263>:	pop    %r13
0x0000000000016669 <iwl3945_rx_reply_tx+265>:	pop    %r14
0x000000000001666b <iwl3945_rx_reply_tx+267>:	pop    %r15
0x000000000001666d <iwl3945_rx_reply_tx+269>:	leaveq 
0x000000000001666e <iwl3945_rx_reply_tx+270>:	retq   
0x000000000001666f <iwl3945_rx_reply_tx+271>:	nop

0x0000000000016670 <iwl3945_rx_reply_tx+272>:	cmp    %edx,%r14d
0x0000000000016673 <iwl3945_rx_reply_tx+275>:	jl     0x16603 <iwl3945_rx_reply_tx+163>
0x0000000000016675 <iwl3945_rx_reply_tx+277>:	mov    0x40(%rdi),%rax
0x0000000000016679 <iwl3945_rx_reply_tx+281>:	movslq %edx,%rdx



/home/maxim/software/kernel/linux-2.6/include/net/mac80211.h: 487
	memset(&info->status.ampdu_ack_len, 0,
	       sizeof(struct ieee80211_tx_info) -
	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));

0x000000000001667c <iwl3945_rx_reply_tx+284>:	imul   $0x98,%rdx,%rdx
0x0000000000016683 <iwl3945_rx_reply_tx+291>:	mov    (%rdx,%rax,1),%r8
0x0000000000016687 <iwl3945_rx_reply_tx+295>:	mov    $0x0,%rdx
0x000000000001668e <iwl3945_rx_reply_tx+302>:	lea    0x38(%r8),%rdi
0x0000000000016692 <iwl3945_rx_reply_tx+306>:	lea    0x4f(%r8),%rax



	rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);

0x0000000000016696 <iwl3945_rx_reply_tx+310>:	movb   $0x0,0x9(%rdi)        <---------- RIP
0x000000000001669a <iwl3945_rx_reply_tx+314>:	movb   $0x0,0xc(%rdi)
0x000000000001669e <iwl3945_rx_reply_tx+318>:	movb   $0x0,0xf(%rdi)
0x00000000000166a2 <iwl3945_rx_reply_tx+322>:	movb   $0x0,0x12(%rdi)
0x00000000000166a6 <iwl3945_rx_reply_tx+326>:	movb   $0x0,0x15(%rdi)
0x00000000000166aa <iwl3945_rx_reply_tx+330>:	movq   $0x0,0x4f(%r8)
0x00000000000166b2 <iwl3945_rx_reply_tx+338>:	movq   $0x0,0x8(%rax)
0x00000000000166ba <iwl3945_rx_reply_tx+346>:	movq   $0x0,0x10(%rax)
0x00000000000166c2 <iwl3945_rx_reply_tx+354>:	movb   $0x0,0x18(%rax)
0x00000000000166c6 <iwl3945_rx_reply_tx+358>:	xor    %eax,%eax
0x00000000000166c8 <iwl3945_rx_reply_tx+360>:	movzbl 0x3(%rsi),%ecx
0x00000000000166cc <iwl3945_rx_reply_tx+364>:	nopl   0x0(%rax)
0x00000000000166d0 <iwl3945_rx_reply_tx+368>:	cmp    (%rdx),%cl
0x00000000000166d2 <iwl3945_rx_reply_tx+370>:	je     0x166e4 <iwl3945_rx_reply_tx+388>
0x00000000000166d4 <iwl3945_rx_reply_tx+372>:	inc    %eax


Even though addr2line seems to think that faulty instruction is outside the inlined function,
thus looks awfully similar to memset.


So the reason seem that, info somehow is null.

info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
ieee80211_tx_info_clear_status(info);


I will add checks for this now.


Best regards,
	Maxim Levitsky



