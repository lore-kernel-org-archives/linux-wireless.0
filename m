Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYKFOks (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:40:48 -0500
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association
	in 5Ghz band
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1225982253.3619.233.camel@johannes.berg> (sfid-20081106_153741_829069_B924979C)
References: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
	 <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
	 <20081106134950.GB14184@tuxdriver.com>
	 (sfid-20081106_153132_117397_0A76B85E)  <1225982253.3619.233.camel@johannes.berg>
	 (sfid-20081106_153741_829069_B924979C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0TQHaLXUS9n40D46hVWA"
Date: Thu, 06 Nov 2008 15:40:48 +0100
Message-Id: <1225982448.3619.237.camel@johannes.berg> (sfid-20081106_154051_559885_516C936C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0TQHaLXUS9n40D46hVWA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 15:37 +0100, Johannes Berg wrote:

> I agree, also, I thought the problem was that iwlwifi misbehaved if
> there were no active channels in the 5 GHz band and there was a patch to
> fix that? This can happen _regardless_ of the setting of old regulatory,
> it just happens that without the setting, the default is no 5 GHz
> channels, while with it the default has 5 GHz channels.

Or put it this way: regardless of the OLD_REGULATORY setting, what will
happen if you install iw and crda and do:

# iw set reg IL

(if you don't have crda installed, then run the above command and
afterwards run "COUNTRY=3DIL ./crda")

I was under the impression that would run into the same bug as not
having OLD_REGULATORY turned on.

johannes

--=-0TQHaLXUS9n40D46hVWA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEwHsAAoJEKVg1VMiehFYlGAP/0aIC89pZqF3xjxWyZsgL6Bb
21yIHuzyMyo/d2EoArcH3GdmY0ze8rhKR+558iPAHOvEQB2nmOSN6Ed6mxIlU3ZI
k2KZvDFi969c8t97Bd4PUWRSwZjGCjRL80/gXAZrsiFWhuMkeOK4J1ZP4V9iTX5J
L+H+AP8wfAqL394wjXiZIgOQhs19vTQG5fDwglPobgrKgSicRoTyfoKKAEATaTRA
4RuxyPCKLhxQOEumcWp9zHoNNC3Bt02yywmIRQm0SqmJCUlDdl0dxCHPJJ6AEXYu
884Okl5JxFopZL5hsQ4mbJHMIsA2q6Sj8UGdr1KEAiyz+3YkIm0sYxKNnScYGIlh
1Ov/q7+PAM7GXq36wEEP4A0iZNy5q+S3y6wIpCkDWdGg35keqVgz/OpcPgWPYA5n
id1QDf1RmFuuW/H1J0IJJgm0ycUZuDXDbPmbe1DE86NHmC4aNs0dsQ6+k/FDNFWp
51GaAOs8oFpDUx2vPq2A/o86nIRsbcvVRAj/UzvxETY6gw1z2OeabmEXpf6Bol0u
TuMRCkFR65vpdJveHkSTiWQclrx26sh9IxR47UP8Qj5VR8IH0Cx9zMB3pVN59Yyb
B8QDFrPY8Gy3UN/y9YtMGNaTl/rUwqh6W6jNN4uvQTw8XfxOSToyOmZGptPyjivk
LHMhHf5MZuBdt2uXAGA8
=mOVj
-----END PGP SIGNATURE-----

--=-0TQHaLXUS9n40D46hVWA--

