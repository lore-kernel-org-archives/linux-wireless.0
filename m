Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:44810 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765392AbZAOSxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 13:53:45 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Thu, 15 Jan 2009 19:53:49 +0100
Cc: linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <496D163B.5030307@gmail.com> <496F7887.8070203@gmail.com>
In-Reply-To: <496F7887.8070203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901151953.49053.chunkeey@web.de> (sfid-20090115_195400_478489_F6895B04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 January 2009 18:55:19 Artur Skawina wrote:
> Artur Skawina wrote:
> > Artur Skawina wrote:
> >>>>> reboots, but locks up after only a few packets go over the hostap driven
> >>>>> p54usb device. I need the box to be up, that limits the number of tests i can
> > 
> >> after switching from SLUB to SLAB and enabling some debugging i finally caught this:
> > 
> > and slub debugging gave something a bit more useful:
> > 
> > =============================================================================
> > BUG kmalloc-4096: Poison overwritten
> 
> tried reproducing (using the old w-t/pending pull) on different machine,
> but no oops or crash there...
> (similar connectivity issues though, such as connecting only works
> exactly once after starting hostapd, to reconnect i have to restart
> hostapd)
hmm, maybe Windows Mobile uses another PS mechanism, e.g WMM-PS.

> Upgraded to current wireless-testing/pending on the problematic box
> and almost immediately got [1]. No slab corruption this time (at least
> not yet). Will switch to GFP_ATOMIC and retry w/ the new fw.
> 
> artur
yes that's a bug, p54_set_tim must use GFP_ATOMIC, do you want to post the patch?

> [1]:
> BUG: scheduling while atomic: named/2004/0x10000200
> Modules linked in: netconsole saa7134_empress saa6752hs lnbp21 s5h1420 saa7134 videobuf_dma_sg serio_raw budget videobuf_core tveeprom budget_ci budget_core saa7146 ttpci_eeprom ir_common [last unloaded: microcode]
> Pid: 2004, comm: named Not tainted 2.6.29-rc1-00271-ge9fa6b0 #45
> Call Trace:
>  [<c04d4ef7>] schedule+0x2a7/0x320
>  [<c03aed74>] __alloc_skb+0x34/0x110
>  [<c011f5b3>] __cond_resched+0x13/0x30
>  [<c04d501d>] _cond_resched+0x2d/0x40
>  [<c016d8c5>] kmem_cache_alloc+0x95/0xc0
>  [<c016b8d4>] check_object+0xc4/0x230
>  [<c03aed74>] __alloc_skb+0x34/0x110
>  [<c02ede91>] p54_alloc_skb+0x71/0xf0
>  [<c02ee36f>] p54_set_tim+0x3f/0xa0
>  [<c04ae064>] sta_info_set_tim_bit+0x64/0x80

Regards,
	Chr
