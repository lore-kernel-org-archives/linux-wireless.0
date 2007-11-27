Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.227]:34262 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbXK0RR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 12:17:58 -0500
Received: by nz-out-0506.google.com with SMTP id s18so799201nze
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 09:17:58 -0800 (PST)
Message-ID: <43e72e890711270917o309441a0g99ac435a629b6d5e@mail.gmail.com> (sfid-20071127_171802_527611_3C6FE252)
Date: Tue, 27 Nov 2007 12:17:57 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: loswillios <loswillios@gmail.com>
Subject: prism54 - MIPS do_be() trap caught
Cc: kyle@mcmartin.ca, linux-wireless@vger.kernel.org,
	developers@islsm.org, linux-mips@linux-mips.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changing subject, CC'ing linux-mips, perhaps they can help.

On Nov 26, 2007 7:54 PM, loswillios <loswillios@gmail.com> wrote:
> Jan Willies wrote:
> > Luis R. Rodriguez wrote:
> >> Actually I've been informed this is not unaligned access problem but
> >> instead it occurs on do_be() or ip22_be_interrupt() on MIPS. I'll have
> >> to check how that works, I do not yet understand how this is reached.
> >
> > I will try a new build with prism54 in the next days and let you know if
> > that issue is still present.
>
> Still the same problem with 2.6.23.1:
>
> root@OpenWrt:/# ifconfig eth1 up
> eth1: resetting device...
> eth1: uploading firmware...
> eth1: firmware version: 1.0.4.3
> eth1: firmware upload complete
> eth1: interface reset complete
>
> root@OpenWrt:/# iwlist eth1 scanning
> Data bus error, epc == c011518c, ra == c01146cc
> Oops[#1]:
> Cpu 0
> $ 0   : 00000000 1000b800 abad0000 00000032
> $ 4   : 00000001 c00c8000 00000013 00000001
> $ 8   : 0000003c 80102bd4 ffffffff 81e2101c
> $12   : ffffffff 00000580 2ab8af24 00000498
> $16   : 81e21680 000000fa 81339380 0000004a
> $20   : 81339380 00000000 a1e80000 81339000
> $24   : 00000000 2abd55e0
> $28   : 813b4000 813b5cc8 00000019 c01146cc
> Hi    : 00000000
> Lo    : 00000580
> epc   : c011518c     Not tainted
> ra    : c01146cc Status: 1000b803    KERNEL EXL IE
> Cause : 0000001c
> PrId  : 00029007

I can see that this comes from arch/mips/kernel/traps.c do_be() but I
fail to see when this is triggered. Perhaps someone from linux-mips
might be able to help shed some light here. I tried looking into the
stack trace before but I couldn't find any code that made me suspect
of a possible big endian problem (it seems that may be the problem?).
The stack trace used to look like this:

Call Trace:
[<c007e16c>] isl38xx_trigger_device+0xc/0x60 [prism54]
[<c007d6c0>] islpci_mgt_transaction+0x380/0x614 [prism54]
[<c0086cd0>] mgt_get_request+0x100/0x2ec [prism54]
[<c0081628>] prism54_set_mac_address+0x1a0/0xfd8 [prism54]


> Modules linked in: prism54 ehci_hcd ohci_hcd nf_nat_tftp
> nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp
> nf_conntrack_ftp ppp_async ppp_generic slhc crc_ccitt usbcore arc4 aes
> deflate ecb cbc blkcipher crypto_hash cryptomgr crypto_algapi
> switch_robo switch_core diag
> Process iwlist (pid: 680, threadinfo=813b4000, task=810a10c8)
> Stack : ffffff9c 2ab3549b 80074a50 7fd23300 00000000 810a10c8 8003cac4
> 81339710
>          81339710 8008c054 0000003e 00000000 00000000 813b5e60 00000060
> 17000012
>          81339380 813b5d78 00000498 c011dce0 81052920 00000000 17000012
> 00000009
>          0000003e 813b5d30 00000000 81052920 813b5e70 802a6000 802a6000
> 813b5e60
>          813b5e70 00000000 81339380 00008b0b c01187ec 00008b0b 81047360
> 000080d0
>          ...
> Call
> Trace:[<80074a50>][<8003cac4>][<8008c054>][<c011dce0>][<c01187ec>][<c01186a4>][<801ec8ec>][<8005ecc4>][<8005ecc4>][<800cbc34>][<80118d8c>][<c01186a4>][<801ecb10>][<80060f6c>][<80164b28>][<8008d4a8>][<8008630c>][<8008661c>][<8008669c>][<8000c12c>][<80003a00>]
>
> Code: 10800014  24020002  3c02abad <8ca30010> 3442face  1462000f
> 24020008  08045470  00000000
> Segmentation fault

Can you enable KALLSYMS again?

> Sometimes I even get this weird stuff:
>
> root@OpenWrt:/# ifconfig eth1 up
> eth1: resetting device...
> eth1: uploading firmware...
> eth1: firmware version: 1.0.4.3
> eth1: firmware upload complete
> eth1: no 'reset complete' IRQ seen - retrying
> eth1: no 'reset complete' IRQ seen - retrying
> eth1: interface reset failure
> prism54: Your card/socket may be faulty, or IRQ line too busy :(
> ifconfig: SIOCSIFFLAGS: Timer expired

Hm, seems schedule_timeout_uninterruptible() and the time remaining
was misused.  This just is a stupid way to wait, not sure why the
check on islpci_reset_if() is used that way. I'll also test something
later with actual hardware. If anyone has some spare fullmac cards
please send one, all of mine except one which I've put on Orbit for
anyone to use have died. Pasting a quick patch for this, sorry, you
may need to edit manually. I need to get an inline append plugin for
firefox...

diff --git a/drivers/net/wireless/prism54/islpci_dev.c
b/drivers/net/wireless/prism54/islpci_dev.c
index 0847953..62d1797 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -491,7 +491,7 @@ islpci_reset_if(islpci_private *priv)

                remaining = schedule_timeout_uninterruptible(HZ);

-               if(remaining > 0) {
+               if(remaining >= 0) {
                        result = 0;
                        break;
                }
