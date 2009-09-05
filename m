Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZIEJ1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 05:27:03 -0400
Subject: Re: kmemleak reports on wireless-testing master-2009-09-04 +
 kmemleak  tree
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <43e72e890909041515s38e7c502kf552a5cf90e99d94@mail.gmail.com>
References: <43e72e890909041515s38e7c502kf552a5cf90e99d94@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rI2zjJ8rZHQ8PNb+OOT8"
Date: Sat, 05 Sep 2009 11:27:01 +0200
Message-Id: <1252142821.1175.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rI2zjJ8rZHQ8PNb+OOT8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-04 at 15:15 -0700, Luis R. Rodriguez wrote:
> I get these with today's wireless-testing + pulling Catalin's kmemleak
> tree. I nothing upon bootup, and then after a while I force a scan and
> get (besides some other acpi stuff):
>=20
> unreferenced object 0xffff880039c7d700 (size 256):
>   comm "events/1", pid 10, jiffies 4295050369
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
>     [<ffffffff81118a83>] kmem_cache_alloc_node+0x193/0x200
>     [<ffffffff8141dc6a>] __alloc_skb+0x4a/0x180
>     [<ffffffff814ddb82>] wireless_send_event+0x1f2/0x410

Do you have CONFIG_COMPAT? And if you do, can you figure out whether
this is "skb" or "compskb"?

johannes

--=-rI2zjJ8rZHQ8PNb+OOT8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKoi7iAAoJEODzc/N7+QmaPyoQAJzjNoZH1S0npUEr3Rirq2dw
YWXcklqluYyOuC5LNqvRgKng/5kFZChUuxa5J55DPnxDNWukrwZCug+4Qg5BLhfO
82UnV49SnQNvAmoVFOLkeP0iI7MMum07tvAvYlBfPxNygHl1+keWBtnDATbfJ9/D
JwfHHQ0UZ7hjRUajr8PXkx65yKUKPMIdfCfkJnnhDEeSnruT7G1DWuqddKp+t+8d
6Z48ma/Go+0gLASn6TWZYh6Hj/Ajai2wkEFAq+rAho5oR6TXDLASVKo3KB7a3zbm
DkGjEHkH0hXgEDvH8W600ApTPN0gTaFWqTRUH159bi7ijIZd19Z1JrqFzYx103Pz
ZxFNMvW3YRxdHcr1e6o4+Pn/Jz83m4enHevqMbIgoatEfGMrN/d2r6O+iXz3A3y1
oCUIGC/OPCkhlaS7XTpjm32VDLt9QPsuoaaS3R5nXctgw9rWK2oa1lLLBy1UZS2M
fXZRTcp9BNUlylz2OWPXVlMuiKrb3Hz7lDc3mtUxS1W5BmqOpRHJGW2HMugqIi1C
LqwsEDc5g0lL/qsawYVdeh9CRht+ueyQvQJi2QpooHQC1QR3TocqVvywgpJtee2W
3BKWOM00Npvoz5SMtSDEwiXkOMAAYLcZ1jXMlyIYkaDtNlgqLv9oBbbwGg7yfJOu
9IkZfsR9cbnmN86lxB4B
=JU1O
-----END PGP SIGNATURE-----

--=-rI2zjJ8rZHQ8PNb+OOT8--

