Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbZFIRwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 13:52:35 -0400
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zZIf/Bn5AAEBc1ml1Ncq"
Date: Tue, 09 Jun 2009 19:52:06 +0200
Message-Id: <1244569926.18481.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zZIf/Bn5AAEBc1ml1Ncq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 19:48 +0200, gregor kowski wrote:

> > Right. But drivers are free to even only _encrypt_ tkip frames and neve=
r
> > _decrypt_ them after having accepted a hardware key, iow that is
> > perfectly valid behaviour and I don't think we should keep uploading th=
e
> > key to the driver. Worst case is that the proper upload fails and we
> > decrypt all frames in software until the next rollover.
> >
> What's the point of setting the tkip callback if we aren't interested
> in decrypting data by hardware ?

Might depend on something else? Anyhow I don't see the point of
continuing to call the callback. Maybe it should just be part of the key
todo instead when the key is initially uploaded to the hw.

johannes

--=-zZIf/Bn5AAEBc1ml1Ncq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLqFCAAoJEODzc/N7+QmaMA0P+gJoyoMInruxm3tRVn9944ae
QUTcy8lX2cg9IBLP+K1umYyC/magSXGR6Ju+fj835Y/opzZjv4q2iMCc88zqGLJz
gWn9dy0fVEffQQC2EBdxce0Ia8JPozYYff4kR51dKWZz03u8XKoXlU+kmh+1iHUX
fFh/qnnCEU5kXdAGvAgfVFJNiXddj5G7RL7eOL5bSLlWAlgrafejqhz3Dtkqhqgx
vrSDXeIXNRgakiPjh0SLJZzcQlzStrZMlz3wwGlOOwsmTSGWFURj4GTZHoD20pNy
q1P9nQLTFFL1QTDafKJ2UxTxujPbkxD7Vo87DCt/reYK+anHW2XnGXsJ9jwOwMAj
+lsMfg6ajmT+kbk6m/SkAgmAuYqxg1bM9YrqCyC+dRwT4YVugFpIHiyX9PTiEmxm
bcbzmu824xsD24ivrDqZlPJEF/D50KMUUvAJ06JOJnrPW/0r2DmDiYg0HvgU5DOB
0P9utBb1ET9f9mq0UImkBqAWgXuSLteymSxhwbbPeAKq3tZ56z6JhU7QM+WtSOyT
c08yD7raLXarO7htZSfdaktYEmWwhb9mjkbbEKrvEC/2ZL6lT2tlIeIHYMAgb+uR
A2Nkc9IJFEYQjaqUGe8adsE3uVtPGk8HuoOEEGoZo3LFAUI/Gv650yjliYSLOXkZ
veVHtSOobZS8j9gdBc+m
=hgBt
-----END PGP SIGNATURE-----

--=-zZIf/Bn5AAEBc1ml1Ncq--

