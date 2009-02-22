Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:54621 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZBVMB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 07:01:26 -0500
Message-ID: <49A13E91.1090601@gmail.com> (sfid-20090222_130130_868841_26A9352E)
Date: Sun, 22 Feb 2009 13:01:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org>
In-Reply-To: <20090222111807.GB5538@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22.2.2009 12:18, Sitsofe Wheeler wrote:
> While testing a linux-tip from yesterday, a
> BUG kmalloc-4096: Poison overwritten
> warning appeared inside dmesg. I'm not aware of what I was doing othe=
r
> that browsing a few web pages and using ssh in the lead up to it. Out=
put
> is attached below:
>
> [ 3666.410818] ath5k phy0: unsupported jumbo
> [ 4432.305651] ath5k phy0: unsupported jumbo
> [ 4466.022644] totem[4664]: segfault at 5bf7b980 ip b5b39cbb sp b0d5f=
130 error 6 in libpulse.so.0.4.1[b5afb000+4d000]
> [ 4617.353923] totem[5189]: segfault at 4c7a2ee0 ip b59bfdca sp b1c12=
ec0 error 6 in libpulse.so.0.4.1[b5981000+4d000]
> [ 7412.846146] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 7412.846159] BUG kmalloc-4096: Poison overwritten
> [ 7412.846163] ------------------------------------------------------=
-----------------------
> [ 7412.846166]
> [ 7412.846172] INFO: 0xf6438010-0xf6438053. First byte 0x80 instead o=
f 0x6b
> [ 7412.846188] INFO: Allocated in dev_alloc_skb+0x21/0x40 age=3D629 c=
pu=3D0 pid=3D0
> [ 7412.846197] INFO: Freed in skb_release_data+0x5e/0x90 age=3D21 cpu=
=3D0 pid=3D0
> [ 7412.846204] INFO: Slab 0xc17a27e0 objects=3D7 used=3D5 fp=3D0xf643=
8000 flags=3D0x400020c3
> [ 7412.846210] INFO: Object 0xf6438000 @offset=3D0 fp=3D0xf643a060
> [ 7412.846212]
> [ 7412.846216]   Object 0xf6438000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [ 7412.846245]   Object 0xf6438010:  80 00 00 00 ff ff ff ff ff ff 00=
 30 ab 1a 32 3f ....=FF=FF=FF=FF=FF=FF.0=AB.2?

Hmm, beacon written after the memory was freed.

> [ 7412.846273]   Object 0xf6438020:  00 30 ab 1a 32 3f e0 24 59 62 25=
 b5 01 00 00 00 .0=AB.2?=E0$Yb%=B5....
> [ 7412.846301]   Object 0xf6438030:  64 00 31 00 00 08 57 69 72 65 6c=
 65 73 73 01 04 d.1...Wireless..
> [ 7412.846329]   Object 0xf6438040:  82 84 8b 96 03 01 06 05 04 01 02=
 00 00 55 fa af .............U=FA=AF
> [ 7412.846357]   Object 0xf6438050:  5d 55 fa 5d 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b ]U=FA]kkkkkkkkkkkk
> [ 7412.846385]   Object 0xf6438060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk

=2E..

The unsupported jumbo message might be a clue. When we jump to the next=
:=20
label, the buffer is at the end of the list in software, while in=20
hardware it isn't. In theory, we might hit the bug with rx buffers=20
exhaustion, because the test (bf_last =3D=3D bf) doesn't work as expect=
ed then.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
