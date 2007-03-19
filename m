Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:57062 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964808AbXCSUkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 16:40:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: Faking powersave for fun and realtime channel muxing
Date: Mon, 19 Mar 2007 16:38:43 -0400
Cc: linux-wireless@vger.kernel.org
References: <45FEEB34.1000403@warmcat.com>
In-Reply-To: <45FEEB34.1000403@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart32623997.PdHQqjVhnN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703191638.48742.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart32623997.PdHQqjVhnN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 19 March 2007 15:57, Andy Green wrote:
> Hi folks -
>
> If you could generate and manage powersave protocol frames to an AP from
> the mac80211 stack, without actually putting the radio to sleep, you
> could do some interesting things.
>
Like in my scanning patch series?

http://news.gmane.org/find-root.php?group=3Dgmane.linux.kernel.wireless.gen=
eral&article=3D770

This requires a bit of kernel side support to queue up frames on the client=
=20
side to maintain the illusion that nothing happened. (except for a brief=20
latency jump) However, it does seem to work for the wireless cards I've=20
tested. Doing scanning like this in userspace will require some sort of=20
interface to stop/restart the TX for the appropriate network interfaces, bu=
t=20
will probably make your multichannel association idea possible.

As for how long the AP will hold your frames.. 802.11 defines a minimum tim=
e,=20
but the maximum depends on the AP.

=2DMichael Wu

--nextPart32623997.PdHQqjVhnN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF/vTYT3Oqt9AH4aERAn9eAKC432oUP9HBKkhnCTRUUdLL56F8cwCfQzOK
xb6hgcrBCBxJ9mxZWD7Gg0A=
=oVJJ
-----END PGP SIGNATURE-----

--nextPart32623997.PdHQqjVhnN--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
