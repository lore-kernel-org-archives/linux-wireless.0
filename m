Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:5185 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZELR0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 13:26:22 -0400
Received: by yw-out-2324.google.com with SMTP id 5so58101ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 10:26:22 -0700 (PDT)
Message-ID: <4A09B130.9000106@gmail.com>
Date: Tue, 12 May 2009 13:26:08 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT v9] rfkill: rewrite
References: <1242030669.6930.10.camel@johannes.local>
In-Reply-To: <1242030669.6930.10.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig512768A8155AF90AEC0A79F2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig512768A8155AF90AEC0A79F2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:
>
>  * all rfkill drivers need to implement polling where necessary
>    rather than having one central implementation
>
>  * updating the rfkill state cannot be done from arbitrary
>    contexts, forcing drivers to use schedule_work and requiring
>    lots of code
>
>  * rfkill drivers need to keep track of soft/hard blocked
>    internally -- the core should do this
>
>  * the rfkill API has many unexpected quirks, for example being
>    asymmetric wrt. alloc/free and register/unregister
>
>  * rfkill can call back into a driver from within a function the
>    driver called -- this is prone to deadlocks and generally
>    should be avoided
>
>  * rfkill-input pointlessly is a separate module
>  =20
Please leave rfkill-input available as a module, at least until the bug
I reported in my previous e-mail 'Soft Lockup With rfkill_input and
thinkpad_acpi' is resolved.  Otherwise it will render Thinkpads, and
possibly other systems, unusable with rfkill enabled.

Thank you,

Will Keaney


--------------enig512768A8155AF90AEC0A79F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoJsTkACgkQjfayWCA8dDHkcACdFCDjt6rK5Qnh23H49IWp9fnA
YTwAnAzowZohBJMvQaipdiid8TU2CGVz
=BTMn
-----END PGP SIGNATURE-----

--------------enig512768A8155AF90AEC0A79F2--
