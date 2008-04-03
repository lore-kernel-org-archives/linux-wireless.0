Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbYDCNaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 09:30:11 -0400
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX
	non-WEP frame, but expected encryption"
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0804030624u40be9ad9rb1cadefadb13f889@mail.gmail.com> (sfid-20080403_142500_363034_CE408D97)
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 <1207226756.3636.66.camel@johannes.berg>
	 <a44ae5cd0804030615n3c3e906ey1db4513802bdf01@mail.gmail.com>
	 <a44ae5cd0804030624u40be9ad9rb1cadefadb13f889@mail.gmail.com>
	 (sfid-20080403_142500_363034_CE408D97)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CeD+tbpqgo2BcFrHRQAB"
Date: Thu, 03 Apr 2008 15:30:07 +0200
Message-Id: <1207229407.3636.79.camel@johannes.berg> (sfid-20080403_143020_473126_0D644FA1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CeD+tbpqgo2BcFrHRQAB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-04-03 at 09:24 -0400, Miles Lane wrote:
> Thanks.  I think I have a working build, but can you confirm that the
> linker messages are benign?

Yeah, seems ok, as long as it runs :)

> I will get to work now on getting the log for you.

I'm about to go offline now, I'll look at it tomorrow. You should be
able to identify the packet that caused the problem in wireshark by
adding a display filter like "=EF=BB=BFwlan.fc.protected =3D=3D 0"

>  CC   iw.o
> cc: -lnl: linker input file unused because linking not done

Hrm. Yes, my mistake, I suppose. I don't like Makefile hacking :) Maybe
I should just go back to the built-in rules.

> interface.c: In function 'handle_interface':
> interface.c:64: warning: 'err' may be used uninitialized in this function
> interface.c:64: note: 'err' was declared here
> interface.c:138: warning: 'err' may be used uninitialized in this functio=
n
> interface.c:138: note: 'err' was declared here

Strange. I don't get those, and I don't know how the compiler arrives at
that conclusion.

johannes

--=-CeD+tbpqgo2BcFrHRQAB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Tb3qVg1VMiehFYAQL89A/+KT3+5VJoFUU/Hz65VvPHz8O5sBPJbJYB
sSH9tvS3gGHcUvnc0/vBGbZ4TuQXiwjPqbCVWx1g95Kly3HKtTqVHHjypjPJQniX
ISdyncnhm1Ax3xrAArshHcfpZ8AkKnoc5KpyXOeXSmG0vbTEVsQ2EHCXqydilrGy
l5AVbT4eeMFm5CXIqmMhNwyM63ELJwi/esvIJcxvOa6TtZwXOEvm67rOmtaKA2Az
UTsJWtB3CTDiA0aCRyKEKu4k/3WrC86ko0knHP6ignz3NkokhoEQ1XxMxw35DFr9
xy+15njud8yXyCELwx/SGknsQ/2ffJl+qG4oocLJtDZ9Z0ykl+luaZRuPPXEiL1W
q7w/5aeJu+ZfbgTkfgsQOKWd9Ge+7GETkQn1MON9XTUWPEA1AVVdMWdj20CX6xAT
ptmFK6jdlXssZ2NLF5FPnt3860ld8+0dAWVwzmt5QcZBhP83+YqBi4nR7lAFXeLe
p3tP37wLUqj6J4WziqbnDjPQTiKIZAJfWYLayx8/Z5p/fg4Q5sWHVVPMiRvUwDxJ
aUrjmmpZjbnlQ/rI6xfbPXCs7t4TzxqQyi5GVLrF38ygNBnXaMS8WwdclD/OS+h3
1YeeuZsFSMXUBo3k7kEgQcda2C9bJkSysMTHVXSmn4uvXI1gv3Q2VEvkXVHNXN9y
Yv+mPBtMvHE=
=x9x/
-----END PGP SIGNATURE-----

--=-CeD+tbpqgo2BcFrHRQAB--

