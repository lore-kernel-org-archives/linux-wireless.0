Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:36119 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525AbZAPDbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 22:31:20 -0500
Received: by ewy12 with SMTP id 12so517887ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 19:31:18 -0800 (PST)
Message-ID: <496FFF83.8090204@gmail.com> (sfid-20090116_043126_865281_AEB56BAB)
Date: Fri, 16 Jan 2009 04:31:15 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901152042.42372.chunkeey@web.de> <496F9740.5010109@gmail.com> <200901152341.02130.chunkeey@web.de> <496FCDDD.7090203@gmail.com> <496FFC9F.1000907@lwfinger.net>
In-Reply-To: <496FFC9F.1000907@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> well... I'm still looking for an explanation for your other problem=
s:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>>> BUG kmalloc-4096: Poison overwritten
>>> -------------------------------------------------------------------=
----------
>>>
>>>   Object 0xddec18c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
>>>   Object 0xddec18d0:  >69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b ikkkkkkkkkkkkkkk
>>>   Object 0xddec18e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
>>>
>>> The odd thing is here that it's only a "single" bit in the object f=
lipped and not more!
>> yes, that does not look good. i didn't find anything obvious under w=
ireless/p54
>> that could be responsible for it, didn't look at the rest of the sta=
ck yet.
>> I'd say ignore this for now, until i'm able to reproduce it; one try=
 on a very
>> different machine didn't help and i didn't have a lot of time to ret=
est after
>> the kernel upgrade(s) today.=20
>>
>>> And we all have slub/slab debug options enabled as well (in fact, w=
e had to fix the usbdriver for that,
>>> see patch "p54usb: rewriting rx/tx routines to make use of usb_anch=
or's facilities" )
>>>
>>> can you check your RAM with memtest or something?
>> yes, i just need to plan for enough downtime...=20
>=20
> I too have seen real single bit changes - in my case 6b went to 6a,
> and my memory is fine. I wouldn't necessarily blame your hardware.

In fact i was just trying Christian's URB_ZERO_PACKET suggestion, and g=
ot this
(about the time when some useful packets started coming in):

BUG kmalloc-4096: Poison overwritten
-----------------------------------------------------------------------=
------

INFO: 0xdc8351c8-0xdc8351c8. First byte 0x6a instead of 0x6b
INFO: Allocated in dev_alloc_skb+0x19/0x30 age=3D3720 cpu=3D0 pid=3D195=
2
INFO: Freed in __kfree_skb+0xf/0x90 age=3D238 cpu=3D0 pid=3D0
INFO: Slab 0xc1390600 objects=3D7 used=3D6 fp=3D0xdc8350f0 flags=3D0x40=
0020c2
INFO: Object 0xdc8350f0 @offset=3D20720 fp=3D0x(null)

Bytes b4 0xdc8350e0:  fb 00 00 00 ae a2 fd ff 5a 5a 5a 5a 5a 5a 5a 5a =C3=
=BB...=C2=AE=C2=A2=C3=BD=C3=BFZZZZZZZZ
  Object 0xdc8350f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
[...]
  Object 0xdc8351b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdc8351c0:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkjkkkkkkk
  Object 0xdc8351d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
[...]
  Object 0xdc8360e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 k=
kkkkkkkkkkkkkk=C2=A5
 Redzone 0xdc8360f0:  bb bb bb bb                                     =C2=
=BB=C2=BB=C2=BB=C2=BB           =20
 Padding 0xdc836118:  5a 5a 5a 5a 5a 5a 5a 5a                         Z=
ZZZZZZZ       =20
Pid: 0, comm: swapper Not tainted 2.6.29-rc1-00273-g0d39407-dirty #47
Call Trace:
 [<c016b79e>] check_bytes_and_report+0xce/0xf0
 [<c016b9f7>] check_object+0x1e7/0x230
 [<c016d115>] __slab_alloc+0x245/0x4f0
 [<c016e3ff>] __kmalloc_track_caller+0xcf/0x110
 [<c03af9f9>] dev_alloc_skb+0x19/0x30
 [<c03af9f9>] dev_alloc_skb+0x19/0x30
 [<c03aed95>] __alloc_skb+0x55/0x110
 [<c03af9f9>] dev_alloc_skb+0x19/0x30
 [<c02f1fcc>] p54u_rx_cb+0x1cc/0x1f0
 [<c024552a>] kref_put+0x2a/0x80
 [<c0340f51>] usb_hcd_giveback_urb+0x41/0xa0
 [<c034f81f>] uhci_giveback_urb+0x7f/0x1f0
 [<c034fdef>] uhci_scan_schedule+0x33f/0xa40
 [<c035213d>] uhci_irq+0x7d/0x140
 [<c0340bf5>] usb_hcd_irq+0x25/0x60
 [<c0145ff8>] handle_IRQ_event+0x28/0x50
 [<c0147210>] handle_level_irq+0x0/0xb0
 [<c014725b>] handle_level_irq+0x4b/0xb0
 <IRQ>  [<c0103707>] common_interrupt+0x27/0x2c
 [<c0108392>] default_idle+0x42/0x50
 [<c0102139>] cpu_idle+0x39/0x80
=46IX kmalloc-4096: Restoring 0xdc8351c8-0xdc8351c8=3D0x6b

=46IX kmalloc-4096: Marking all objects used

artur
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
