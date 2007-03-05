Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457AbXCENFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 08:05:44 -0500
Subject: Re: Filtering in Monitor Mode (was Question about PRISM2 header  rate  field)
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <45EC1454.4080605@warmcat.com>
References: <45EA9E39.6080706@warmcat.com>
	 <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com>
	 <200703042210.52534.flamingice@sourmilk.net>
	 <1173094447.6131.56.camel@johannes.berg>  <45EC1454.4080605@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BLx+0kelDvC8gWuHdkKY"
Date: Mon, 05 Mar 2007 14:05:10 +0100
Message-Id: <1173099910.6131.71.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BLx+0kelDvC8gWuHdkKY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-05 at 13:00 +0000, Andy Green wrote:

> I used the libpcap filter stuff to limit what I saw to just the packets=20
> of interest.  This is the filtering that tcpdump uses to do the=20
> conditional filters like "port 22" or "host 192.168.0.1".  The filter=20
> uses something called BPF (Berkeley Packet Filter) which is done=20
> kernelside (at least libpcap is doing the filter install with ioctls in=20
> pcap-bpf.c).  So the cost of drinking from a Monitor firehose is much=20
> less than it sounds.

Actually, I think the cost can be significant, especially for embedded
systems. You traverse into userspace for each packet at least once, and
a management entity in userspace will not be concerned with data packets
at all. Also, a monitor interface currently always disables power save
mode for many drivers.

johannes

--=-BLx+0kelDvC8gWuHdkKY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7BWG/ETPhpq3jKURAkyLAJ9eJTXX5bu1PW9fR+8w2jAfL11z6QCffclp
7Lh5PpjijrgrS0sBUvGabU8=
=mu9x
-----END PGP SIGNATURE-----

--=-BLx+0kelDvC8gWuHdkKY--

