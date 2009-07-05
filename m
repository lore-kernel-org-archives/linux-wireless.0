Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:46633 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZGEA5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 20:57:06 -0400
Received: by bwz25 with SMTP id 25so120754bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jul 2009 17:57:07 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Sun, 5 Jul 2009 04:56:59 +0400
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200907040053.05654.chunkeey@web.de>
In-Reply-To: <200907040053.05654.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907050457.00689.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patch tries to address a long standing issue: 
> how to survive serve memory starvation situations,
> without losing the device due to missing transfer-buffers.
> 
> And with a flick of __GFP_NOWARN, we're able to handle ?all? memory
> allocation failures on the rx-side during operation without much fuss.
> 
> However, there is still an issue within the xmit-part.
> This is likely due to p54's demand for a large free headroom for
> every outgoing frame:
> 
>  + transport header (differs from device to device)
>       -> 16 bytes transport header (USB 1st gen)
>       -> 8 bytes for (USB 2nd gen)
>       -> 0 bytes for spi & pci
>  + 12 bytes for p54_hdr
>  + 44 bytes for p54_tx_data
>  + up to 3 bytes for alignment
> (+ 802.11 header as well? )
> 
> and this is where ieee80211_skb_resize comes into the play...
> which will try to _relocate_ (alloc new, copy, free old) frame data,
> as the headroom is most of the time simply not enough.
> =>
>  Call Trace: (from Larry - Bug #13319 )
>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
>  [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
>  [<ffffffff802b6362>] new_slab+0xcf/0x28b
>  [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
>  [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
>  [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
>  [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
>  [<ffffffff802b7e60>] __kmalloc+0x119/0x194
>  [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
>  [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
>  [<ffffffffa0291c0f>] ieee80211_master_start_xmit+0x298/0x319 [mac80211]
>  [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
> (sl*b debug option will help to bloat even more.)
> 
> So?! how to prevent ieee80211_skb_resize from raping
> the bits of memory left?
> 
> the simplest answer is probably this one:
> https://dev.openwrt.org/changeset/15761
> --
> 
> back to rx  failures.
> the attached code below was only usb was tested so far!
> you have been warned!
> 
> regards,
> 	chr
> 
> btw: max what do you think about the p54spi changes, are they total ****?

Christian, I'm trying to test it, but it seems that many things have changed since 2.6.28.
Right now I see this:

[  416.738586] Freeing init memory: 140K                                                                                     
[  417.208801] cx3110x spi2.0: firmware: requesting 3826.arm                                                                 
[  417.272094] hub 1-0:1.0: hub_suspend                                                                                      
[  417.272155] usb usb1: bus auto-suspend                                                                                    
[  417.295501] phy0: p54 detected a LM20 firmware                                                                            
[  417.298034] p54: rx_mtu reduced from 3240 to 2376                                                                         
[  417.300598] phy0: FW rev 2.13.0.0.a.22.8 - Softmac protocol 5.6                                                           
[  417.303558] phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES                                                   
[  417.306732] cx3110x spi2.0: firmware: requesting 3826.eeprom                                                              
[  417.385742] firmware spi2.0: firmware_loading_store: vmap() failed                                                        
[  417.391540] cx3110x spi2.0: loading default eeprom...                                                                     
[  417.395568] phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow                                                        
[  417.468841] phy0: Selected rate control algorithm 'minstrel'                                                              
[  417.473693] cx3110x spi2.0: is registered as 'phy0'                                                                       
[  419.150909] g_ether gadget: notify connect false                                                                          
[  419.182891] g_ether gadget: notify speed 425984000                                                                        
[  420.409210] usb0: eth_open                                                                                                
[  420.409240] usb0: eth_start                                                                                               
[  420.409423] g_ether gadget: ecm_open                                                                                      
[  420.409454] g_ether gadget: notify connect true                                                                           
[  420.430908] g_ether gadget: notify speed 425984000
[  421.186340] phy0: device now idle
[  421.200958] skb_over_panic: text:bf000498 len:2 put:2 head:c793a200 data:c793a220 tail:0xc793a222 end:0xc793a220 dev:<NULL>
[  421.211669] kernel BUG at net/core/skbuff.c:127!
[  421.217407] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  421.223571] pgd = c0004000
[  421.229797] [00000000] *pgd=00000000
[  421.236236] Internal error: Oops: 817 [#1]
[  421.242736] Modules linked in: p54spi
[  421.249420] CPU: 0    Not tainted  (2.6.31-rc1-omap1-wl #4)
[  421.256378] PC is at __bug+0x1c/0x28
[  421.263458] LR is at __bug+0x18/0x28
[  421.270538] pc : [<c002f828>]    lr : [<c002f824>]    psr: 60000113
[  421.270568] sp : c798ff20  ip : 00000000  fp : 00000000
[  421.284851] r10: 00000000  r9 : 00000000  r8 : c7976b34
[  421.291870] r7 : c793a220  r6 : c793a222  r5 : c793a220  r4 : c793a200
[  421.298980] r3 : 00000000  r2 : c033cb84  r1 : 000045b2  r0 : 0000003a
[  421.306091] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  421.313323] Control: 00c5387d  Table: 87fe0000  DAC: 00000017
[  421.320526] Process phy0 (pid: 426, stack limit = 0xc798e268)
[  421.327697] Stack: (0xc798ff20 to 0xc7990000)
[  421.334747] ff20: 00000002 c01dc03c c793a200 c793a220 c793a222 c793a220 c02fba60 00000000
[  421.342346] ff40: c798ff40 c784abc0 c793a220 bf000498 c784abc0 c01dd1a8 00000058 c7976940
[  421.349975] ff60: c798ff6e bf000498 c798e000 80000058 c7976afc c7976940 50000000 c7976b0c
[  421.357574] ff80: 00000000 bf0008ec c796fd20 10000000 c0060510 bf000808 c796fd20 c798e000
[  421.365173] ffa0: c0060510 c0060650 c798ffd4 00000000 c78cc9a0 c00636ac c798ffb8 c798ffb8
[  421.372558] ffc0: c798ffd4 c7951d98 c796fd20 c0063440 00000000 00000000 c798ffd8 c798ffd8
[  421.379730] ffe0: 00000000 00000000 00000000 00000000 00000000 c002cca8 53384842 4e86725f
[  421.386993] Code: e1a01000 e59f000c eb0088c3 e3a03000 (e5833000)
[  421.394104] ---[ end trace 75ac12f5b28efc30 ]---

Looks like something's wrong with firmware loading. 
I hope to fix it tomorrow and see how your changes work.

Thanks.
-- Max
