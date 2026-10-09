Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A21370D5E;
	Fri,  9 Oct 2026 21:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791581999; cv=none; b=fQhh/ttoqS/QbLrD5/z0RW80NSICA1EzbefB6B0xjNynj1KqIMTluCHnC1JWMjaVGEio9nee9GtidCgto0PeOL7BTkOXEvmb5bSwPCf6CKWulZEMAVoidvdfLnWtUouFLadR5RJAQrtFMh4w4sSF8Tv2nIeyzzwfprLQGCZDuyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791581999; c=relaxed/simple;
	bh=H1oSWJh5fZjQ1XNCXmsBBbTHrJYv8weii6T1h1C2/ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M13aNuvCb+2gvvyCk9mDLJfdXvEsDSGGKfr75kXhLsfwDG6zBFmpu2hRdkn4Hv9baO7Fhl6KqDyZUWDKnYuF+6114E+abR0/cL1hfjJua+GUdwzDxBzLwSlRX3fJz45479yUrewZtgrdmGv7UPvFjJgF0Nv4dD/jeTHrk64J148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVDKU9Rv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVDKU9Rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5273F1F000FF;
	Fri,  9 Oct 2026 21:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791581998;
	bh=/DIGfdosI8HTT4ZSUkh5GCIGuTYsQcGon1rOmhIuxoY=;
	h=Date:From:To:Cc:Subject;
	b=JVDKU9Rvbak1j1Rct1f8kmkQTPknc7TnLbU9EA9IzH0J1/mYVXeulZbc588DR/rlY
	 kPb95slpoe6tIl/sPlWfwPEqvG0z9FgD8yEuuMZPqerfU2oLT4A+5+2eHjRU+Nqy4G
	 EKKmz53PfDlHH0RhyeTwXgbdfdvNPpXwjnE8Xd0hxtkj5OY4qkgP4HtzIhvqIE/UzS
	 KiC7Aggb1MenRx9WwjmyFTuTNajXPcUk9Vt17tgxYzn5acnu88aTcWPTEugeTcGAhm
	 3lqu2ahELOY9U5y6b3zRz8T3I3wh0ug0vjClz6ZZLCVwkvEZEwZHCip2yZbW+1Ofgm
	 LpCfV0rlUIMvg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 93BD01AC57D0; Fri, 09 Oct 2026 22:39:46 +0100 (BST)
Date: Fri, 9 Oct 2026 23:39:46 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: AmirHossein HajiMohammadi <info@hajimohammadi.net>,
	David Miller <davem@davemloft.net>,
	Franco Hector Hugo Montenegro <franco.montenegro.ruke@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Leonardo Martins Martins <dev.lmmrtns@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Networking <netdev@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Ping-Ke Shih <pkshih@realtek.com>,
	Rishik Yechuri <epicrishik@gmail.com>,
	Rishik Yechuri <rishik.yechuri.code@gmail.com>,
	Rishik Yechuri <rishikyechuri@protonmail.com>,
	Siho Kim <siho93.kim@gmail.com>,
	Svyatoslav Nikolenko <nsvatoslav515@gmail.com>
Subject: linux-next: manual merge of the staging tree with the wireless-next
 tree
Message-ID: <aslfIkFxsc9oIqku@sirena.co.uk>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	AmirHossein HajiMohammadi <info@hajimohammadi.net>,
	David Miller <davem@davemloft.net>,
	Franco Hector Hugo Montenegro <franco.montenegro.ruke@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Leonardo Martins Martins <dev.lmmrtns@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Networking <netdev@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Ping-Ke Shih <pkshih@realtek.com>,
	Rishik Yechuri <epicrishik@gmail.com>,
	Rishik Yechuri <rishik.yechuri.code@gmail.com>,
	Rishik Yechuri <rishikyechuri@protonmail.com>,
	Siho Kim <siho93.kim@gmail.com>,
	Svyatoslav Nikolenko <nsvatoslav515@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hSDyjtiM2P12w3nY"
Content-Disposition: inline


--hSDyjtiM2P12w3nY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the staging tree got a conflict in:

  drivers/staging/rtl8723bs/

between commit:

  c520f3af7df42 ("staging: rtl8723bs: remove the obsolete driver")

=66rom the net-next tree and commits:

  dbc2fa996f446 ("staging: rtl8723bs: Remove manual ifname allocation")
  eb903412616ff ("staging: rtl8723bs: make rtl8723_dequeue_writeport() retu=
rn bool")
  94f8dd8b96b03 ("staging: rtl8723bs: remove unused monitor interface name")
  0e5058a181451 ("staging: rtl8723bs: rename PHY_ConvertTxPowerLimitToPower=
Index()")
  36d9b855cf944 ("staging: rtl8723bs: make xmitframe_swencrypt() return voi=
d")
  18a42264074ae ("staging: rtl8723bs: remove unnecessary parentheses around=
 prframe->u.hdr.list")
  6b4405c0f6001 ("staging: rtl8723bs: align function parameters in aes_deci=
pher")
  2268c1bf1a861 ("Staging: rtl8723bs: fixed camel case coding style issue.")
  bbcc68a61f3be ("staging: rtl8723bs: fix block comment style")

et al from the staging tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

(deleted the files)

--hSDyjtiM2P12w3nY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCaslfHQAKCRAv73Ows9A4
idVTAQCs9er5Tjczolpw7ZuWp0gNJlb3KN8ExwRqXiSYmMGuowD+LdRvPUbAYuLm
TqyWXQzFnYiRWYw3H3LsHhYap01LtAM=
=xqIq
-----END PGP SIGNATURE-----

--hSDyjtiM2P12w3nY--
