Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f203.google.com ([209.85.212.203]:34344 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbZJKWsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 18:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <4AD21AB4.6010208@wpkg.org>
References: <4AD21AB4.6010208@wpkg.org>
Date: Sun, 11 Oct 2009 18:47:33 -0400
Message-ID: <b6c5339f0910111547w33a88f7dtd9d16cd3380877cd@mail.gmail.com>
Subject: Re: ath5k AP kernel panic when client uses SCP
From: Bob Copeland <me@bobcopeland.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-wireless@vger.kernel.org, linux-mips@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 11, 2009 at 1:49 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> The AP is Asus WL-500gP, it's a MIPS platform, running 2.6.31.1 kernel,
> hostapd v0.6.9.
>
> I can reproduce the issue reliably.
>
> Let me know if you need more info here.

Yes, please -- it would really be helpful if instead of just the addresses
we have all the function names in the stack trace.  Or at least what is
at 8006f058 and 80276190.  We've had a couple of reports of unaligned
accesses but I haven't yet seen a useful stack trace.

> [67359.700000] ------------[ cut here ]------------
> [67359.710000] WARNING: at net/core/dev.c:1566 0x80280890()
> [67359.710000] b44: caps=(0x0, 0x0) len=80 data_len=0 ip_summed=1
> [67359.720000] Modules linked in: tun sch_sfq cls_fw sch_htb ipt_MASQUERADE
> iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG xt_recent
> nf_conntrack_ipv4 nf_defrag1

Did you replace the wireless device?  I don't see ath5k in the
above list; IIRC that AP is originally some broadcom chipset.

> [67360.080000] Disabling lock debugging due to kernel taint
> [67360.560000] Kernel panic - not syncing: Fatal exception in interrupt

Why's it tainted?  I can't remember and can't check right now if
TAINT_WARN counts.

-- 
Bob Copeland %% www.bobcopeland.com
