Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYK0JJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 04:09:08 -0500
Subject: Re: [PATCH 2/2] zd1211rw: enable an AP that can't support fully PS
	clients (wireless-testing).
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <eb3ff54b0811240338t7b11a1bam669f1ffa841a5e87@mail.gmail.com> (sfid-20081124_123853_670351_EFA6C16E)
References: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com>
	 <1227522918.3599.63.camel@johannes.berg>
	 <eb3ff54b0811240309u31944469xa444ee25f8ac8496@mail.gmail.com>
	 <1227525694.3599.95.camel@johannes.berg>
	 <eb3ff54b0811240338t7b11a1bam669f1ffa841a5e87@mail.gmail.com>
	 (sfid-20081124_123853_670351_EFA6C16E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TtnQPXYqokCjtXAluJ0N"
Date: Thu, 27 Nov 2008 10:06:30 +0100
Message-Id: <1227776790.3809.5.camel@johannes.berg> (sfid-20081127_100913_818144_9D2181B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TtnQPXYqokCjtXAluJ0N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 13:38 +0200, Rami Rosen wrote:
> Hello,
>   I indeed intend to fix the driver to do the buffering and use
> _get_buffered_bc() (and also add sequence numbering, which is easier).

Sequence numbers are provided by the firmware, I think? At least beacons
do have sequence numbers.

Anyway, so I got some information, to fix this use _get_buffered_bc()
when in zd_process_intr you get INT_CFG_NEXT_BCN; but this indicates
that the beacon has _just_ been sent so you need to use _get_beacon()
*after* _get_buffered_bc().

johannes

--=-TtnQPXYqokCjtXAluJ0N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLmMPAAoJEKVg1VMiehFYS+gQAKd0FY3qUCr+EPXU0cyujVMv
peoKzWmRblfiGoljwqWCp9NcmYcVdcOmKxF+5R1uaR712hqREVvtZn9ZqjYo/u4f
FSJcfY3OYRcrZ8eaumzoFJ7EbHuKUXdHgFNpj0mre2mN1awhUoYlqZGX/OqHDajV
/NgTpzUbghHxwX5KanCw27ksnleQLHDPaozLPSON+JMZu59xxMRTYYrbHnC6ryW1
HbrLCNvnoH1fkGfq9ZZ3E/a4PJQeMVNYkW51ZE7e+48N9jcu/Yvs1cNRUWVvIcD/
ur55qzvX4TuneIA5QH2DLH2IGfXYSxrHclehBpDmR61Csa1sFcEmaWGQl4R1x7Xn
ad73NVo0ulWmLHlSpODIjtGatJdAcIeNd/JrDsdHx7QABIH/z6kQSgQK6XU766P6
p5kfD23KT4g2Pzy6QhCtexHCLdVqLjxaK6RBp0cGgNn7zqZa8yurK9kIjg3TMYZk
PZeihAPSlCZUj8OT8f5U5T1BUlRwXN/eajwILclljeNzBCq3V8BdJFUxueqlmW99
Q9HupPO5BAQvxukKeXYZs2AtTXtKfc4sH5xzf/rg7NNRtIVLJKd/8HipJX1maufG
acZOBdkVmG9uSSE4+CBU20i2GRPYpOWwSaKU8TpB5/MAia39SWTeP5drH6OpTmxv
dHuReNe5s4GSTjOpVRV2
=W+Hc
-----END PGP SIGNATURE-----

--=-TtnQPXYqokCjtXAluJ0N--

