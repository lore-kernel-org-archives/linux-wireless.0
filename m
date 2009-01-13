Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50664 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZAMNtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:49:36 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Tue, 13 Jan 2009 14:49:41 +0100
Cc: linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200812161510.09499.chunkeey@web.de> <496B795B.8090700@gmail.com>
In-Reply-To: <496B795B.8090700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901131449.41189.chunkeey@web.de> (sfid-20090113_144941_274827_E877C91F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 January 2009 18:09:47 Artur Skawina wrote:
> kernel: phy0: p54 detected a LM86 firmware
> kernel: p54: rx_mtu reduced from 3240 to 2392
> kernel: phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
Well, I guess you got the latest wireless-testing tree, right?
Then you can try if the "latest" firmware (the ones for => 2.6.29) improve the situation.

> so to test the device further i set up hostapd, which mostly worked; after 
> a few tweaks (eg patching out country code setting in hostapd)
patching out country code?! why that?
currently, hostapd is the only thing that works out-of-the-box :-D

you should execute "iw reg set XY" where XY is a 2-(upper-case)-letter ID of your country, e.g US = USA, CZ, DE, FR, etc...
(see http://wireless.kernel.org/en/users/Documentation/iw )
and then you have to wait a bit (e.g sleep 1) before you can start hostapd.

> i got an almost working AP. "Almost" because connecting a client works sometimes,
> but not always, and there seems to be way too much packet loss going on.
> "dtim_period=1" seemed to improve things enough to achieve basic ipv4
> connectivity (w/o it dhcp seemed to work, but arp usually did not).
well, do you have another wifi device which has sniffer/monitor mode?
It sounds like your client or AP has a problem with power save management.

> But then i ran into a more serious issue -- the machine locks up completely
> when trying to use the device (just connecting and disconnecting a client is
> often enough). Happens after ~ a minute, the computer freezes, isn't
> responsible over network, nothing in logs. It's a headless box, tried
> hooking up a kbd and monitor, but that didn't help - console was dead too.
> After setting up netconsole i first got two skb truesize warnings [1], then
> after a short while again a complete lock up, nothing on the console.
> Then tried plugging in a keyboard and that provoked a stream of order 0 page
> allocation failures, but the machine remained dead.
"order 0 page allocation failures"? Your machine suffers from a serios memory starvation.
Either something is leaking, or you have not very much memory do you in your "headless box", or both...

> ------------[ cut here ]------------
> WARNING: at net/core/skbuff.c:154 skb_truesize_bug+0x4c/0x50()
> SKB BUG: Invalid truesize (288) len=111, sizeof(sk_buff)=180
> Modules linked in: netconsole saa7134_empress saa6752hs lnbp21 s5h1420 saa7134 budget videobuf_dma_sg budget_ci budget_core serio_raw videobuf_core tveeprom saa7146 ttpci_eeprom ir_common [last unloaded: microcode]
> Pid: 3797, comm: hostapd Not tainted 2.6.28-rc8-00519-g90435df #41
> Call Trace:
>  [<c0122f3f>] warn_slowpath+0x6f/0x90
>  [<c03b7efb>] __qdisc_run+0x1ab/0x200
>  [<c03a7f34>] dev_queue_xmit+0xd4/0x4e0
>  [<c04acb7a>] ieee80211_monitor_start_xmit+0x6a/0xa0
>  [<c03a7cda>] dev_hard_start_xmit+0x1aa/0x210
>  [<c03b7efb>] __qdisc_run+0x1ab/0x200
[...]
That's a known mac80211 bug:
http://wireless.kernel.org/en/developers/todo-list#APsupport (see under bugs, or take a look at the linux-wireless ML)


Regards,
	Chr
