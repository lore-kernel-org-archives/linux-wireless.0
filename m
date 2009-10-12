Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:33181 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbZJLIN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 04:13:58 -0400
Message-ID: <4AD2E511.1050808@wpkg.org>
Date: Mon, 12 Oct 2009 10:13:05 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: ath5k AP kernel panic when client uses SCP
References: <4AD21AB4.6010208@wpkg.org> <b6c5339f0910111547w33a88f7dtd9d16cd3380877cd@mail.gmail.com>
In-Reply-To: <b6c5339f0910111547w33a88f7dtd9d16cd3380877cd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Sun, Oct 11, 2009 at 1:49 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> The AP is Asus WL-500gP, it's a MIPS platform, running 2.6.31.1 kernel,
>> hostapd v0.6.9.
>>
>> I can reproduce the issue reliably.
>>
>> Let me know if you need more info here.
> 
> Yes, please -- it would really be helpful if instead of just the addresses
> we have all the function names in the stack trace.  Or at least what is
> at 8006f058 and 80276190.  We've had a couple of reports of unaligned
> accesses but I haven't yet seen a useful stack trace.

OK, will try to send it later today.


>> [67359.700000] ------------[ cut here ]------------
>> [67359.710000] WARNING: at net/core/dev.c:1566 0x80280890()
>> [67359.710000] b44: caps=(0x0, 0x0) len=80 data_len=0 ip_summed=1
>> [67359.720000] Modules linked in: tun sch_sfq cls_fw sch_htb ipt_MASQUERADE
>> iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG xt_recent
>> nf_conntrack_ipv4 nf_defrag1
> 
> Did you replace the wireless device?  I don't see ath5k in the
> above list; IIRC that AP is originally some broadcom chipset.

The AP device comes with a broadcom wireless card, which doesn't work well.
So I replaced broadcom with an ath5k card.
ath5k and other modules were probably "eaten" by the terminal/minicom/konsole/whatever.
This is the list of modules which should be loaded when the panic occurs:

# lsmod
Module                  Size  Used by
tun                    12160  2
sch_sfq                 4496  1
cls_fw                  3216  1
sch_htb                12480  1
ipt_MASQUERADE           976  1
iptable_nat             2800  1
nf_nat                 12496  2 ipt_MASQUERADE,iptable_nat
xt_MARK                  912  1
iptable_mangle          1008  1
ipt_ULOG                4144  1
xt_recent               5408  9
nf_conntrack_ipv4       4560  7 iptable_nat,nf_nat
nf_defrag_ipv4           624  1 nf_conntrack_ipv4
xt_state                 784  4
nf_conntrack           46640  5 ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4,xt_state
xt_tcpudp               1888  5
iptable_filter           768  1
ip_tables               8848  3 iptable_nat,iptable_mangle,iptable_filter
x_tables                9648  8 ipt_MASQUERADE,iptable_nat,xt_MARK,ipt_ULOG,xt_recent,xt_state,xt_tcpudp,ip_tables
ath5k                 131616  0
mac80211              130208  1 ath5k
ath                     6256  1 ath5k
ohci_hcd               17344  0
uhci_hcd               18048  0
cfg80211               72000  3 ath5k,mac80211,ath

 
>> [67360.080000] Disabling lock debugging due to kernel taint
>> [67360.560000] Kernel panic - not syncing: Fatal exception in interrupt
> 
> Why's it tainted?  I can't remember and can't check right now if
> TAINT_WARN counts.

Yes, WARN taints the kernel.


-- 
Tomasz Chmielewski
http://wpkg.org
