Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36432 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbXCHQwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 11:52:11 -0500
Subject: Re: wireless extensions vs. 64-bit architectures
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>,
	Jouni Malinen <jkm@devicescape.com>
In-Reply-To: <1173364747.14001.7.camel@johannes.berg>
References: <1173144447.15891.93.camel@johannes.berg>
	 <20070306171316.GA19669@bougret.hpl.hp.com>
	 <200703061943.07350.mb@bu3sch.de>
	 <20070307020310.GA20466@bougret.hpl.hp.com>
	 <1173364747.14001.7.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M+BU7xOXAoctaWZK8ZOO"
Date: Thu, 08 Mar 2007 17:51:54 +0100
Message-Id: <1173372714.3248.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M+BU7xOXAoctaWZK8ZOO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 15:39 +0100, Johannes Berg wrote:

> Now, I don't know what gcc for ia64 does and I don't have a cross
> compiler to check, but on powerpc it does this.

As expected, the same happens on x86_64 (thanks to Michael Wu for the
debug dump):

 <1><e13>: Abbrev Number: 17 (DW_TAG_structure_type)
     DW_AT_sibling     : <e4c>
     DW_AT_name        : (indirect string, offset: 0x33d): iw_event
     DW_AT_byte_size   : 24
     DW_AT_decl_file   : 100
     DW_AT_decl_line   : 1049
 <2><e20>: Abbrev Number: 18 (DW_TAG_member)
     DW_AT_name        : len
     DW_AT_decl_file   : 100
     DW_AT_decl_line   : 1050
     DW_AT_type        : <58b>
     DW_AT_data_member_location: 2 byte block: 23 0     (DW_OP_plus_uconst:=
 0)
 <2><e2f>: Abbrev Number: 18 (DW_TAG_member)
     DW_AT_name        : cmd
     DW_AT_decl_file   : 100
     DW_AT_decl_line   : 1051
     DW_AT_type        : <58b>
     DW_AT_data_member_location: 2 byte block: 23 2     (DW_OP_plus_uconst:=
 2)
 <2><e3e>: Abbrev Number: 18 (DW_TAG_member)
     DW_AT_name        : u
     DW_AT_decl_file   : 100
     DW_AT_decl_line   : 1052
     DW_AT_type        : <9bf>
     DW_AT_data_member_location: 2 byte block: 23 8     (DW_OP_plus_uconst:=
 8)

Hence, on those machines 32-bit userspace is also broken and we have the
information leak too.

johannes

--=-M+BU7xOXAoctaWZK8ZOO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8D8q/ETPhpq3jKURAmrAAJ9GSY5F9y5u+OJS7gPnrli7ZQDPSwCePkA+
LSHXACKZ+P1yHZw3+2wRV3A=
=Tz0P
-----END PGP SIGNATURE-----

--=-M+BU7xOXAoctaWZK8ZOO--

