Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C394535C686;
	Tue, 15 Sep 2026 14:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482027; cv=none; b=U4GaWoEvn2os9ysiLk665dNruCaa2S3DVyuclir0H5ZGuvB/7oasvAdNqzVNA2EtjShTunbleiyK56oBLoE8I4BKYTQQ4oYslu5B6PXQlvraLR5/DetN9N8sQ1molQpkm3hp//3YcP9SFuTw2La3N5TdxlIOPt2Zc0Q0KbvsvGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482027; c=relaxed/simple;
	bh=PdjuIbUKue1uQ3zmvIysQrJ+zfckfYP7m5mfNpqQ4Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YkLMXJ2/tvdzOSIkXjCBvPRW3Np88E70jTzlszsP/DP4SwKJkWefsDOaN2QMFfRtH95hHkAhKSzjKXEUvYk3PIOclku/SGXgmwr1mtvEuRA+vfuS2W9FsNSXvHHCSaWpyk2JRoO9L1wKClX2XZ/ub+/wLjViGCbtP5uNQcIsnrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrG7dgY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrG7dgY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9B11F00898;
	Tue, 15 Sep 2026 14:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482026;
	bh=MEsKI0LWezyhAWDQneqjdlMYSgB+3NODkCoVF3H5uR8=;
	h=Date:From:To:Cc:Subject;
	b=VrG7dgY4EunCHTT2EDJCct8kZjT5Iw72myINzHmivsb4o9OLT3yEY1Csgm/QTYVOy
	 RxY1aG6Vy86EoQRasC837V03GAfJ28JwGRhtC0qEBcc9VAKQuZOwb+DQZIFXMdCvjR
	 uJacPPq8FM44Xxxcc5x6pSi+yMIbRheV0BDvMjc/VyMHbij0L5nB/EB63L89BXF97m
	 K+5MYyo9miXJZX+KYEI+QO7s/6ybWmOIdF9MHwrA+9mxn6OkaaLFNQS2kqDeil/6jj
	 lUvP721w8vpjIFXjWbDfUsTXphkcUGquGOf14+yR0qlp1OEGLMmQJHKPNSmrjIcCbq
	 qChJ4hJyd/+hQ==
Date: Tue, 15 Sep 2026 15:20:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the wireless-next tree with the wireless
 tree
Message-ID: <aqlUJnjxj1lroNev@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IBC+52lWwiJAH663"
Content-Disposition: inline


--IBC+52lWwiJAH663
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-next tree got a conflict in:

  drivers/net/wireless/virtual/mac80211_hwsim_main.c

between commit:

  87840d4a3a21b ("wifi: mac80211_hwsim: don't hand frames to mac80211 while=
 stopping")

=66rom the wireless tree and commit:

  41416127e37e4 ("wifi: mac80211_hwsim: overwrite report SKB")

=66rom the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/net/wireless/virtual/mac80211_hwsim_main.c
index b9446577ff499,9f895ad718e9b..0000000000000
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@@ -6540,13 -6543,51 +6548,58 @@@ static int hwsim_cloned_frame_received_
  			goto out;
  	}
 =20
 +	/*
 +	 * Serialise against mac80211_hwsim_stop() - mac80211 doesn't allow
 +	 * frames reported while the HW is down, hence the ->started check
 +	 * must be under mutex.
 +	 */
 +	mutex_lock(&data2->mutex);
 +
+ 	/* look for the skb matching the cookie passed back from user */
+ 	if (info->attrs[HWSIM_ATTR_COOKIE] &&
+ 	    info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]) {
+ 		u64 cookie =3D nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
+ 		struct sk_buff *orig_skb, *found =3D NULL;
+ 		struct mac80211_hwsim_data *txdata;
+ 		struct ieee80211_tx_info *txi;
+ 		const u8 *transmitter;
+ 		unsigned long flags;
+=20
+ 		transmitter =3D nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
+ 		txdata =3D get_hwsim_data_ref_from_addr(transmitter);
+ 		if (!txdata || txdata->netgroup !=3D data2->netgroup)
 -			goto out;
++			goto out_unlock;
+=20
+ 		spin_lock_irqsave(&txdata->pending.lock, flags);
+ 		skb_queue_walk(&txdata->pending, orig_skb) {
+ 			uintptr_t skb_cookie;
+=20
+ 			txi =3D IEEE80211_SKB_CB(orig_skb);
+ 			skb_cookie =3D (uintptr_t)txi->rate_driver_data[0];
+=20
+ 			if (skb_cookie =3D=3D cookie) {
+ 				found =3D orig_skb;
+ 				break;
+ 			}
+ 		}
+=20
+ 		/* that's weird */
+ 		if (!found) {
+ 			spin_unlock_irqrestore(&txdata->pending.lock, flags);
 -			goto out;
++			goto out_unlock;
+ 		}
+=20
+ 		if (frame_data_len > found->len &&
+ 		    pskb_expand_head(found, 0, frame_data_len - found->len,
+ 				     GFP_ATOMIC)) {
+ 			spin_unlock_irqrestore(&txdata->pending.lock, flags);
 -			goto out;
++			goto out_unlock;
+ 		}
+ 		skb_trim(found, 0);
+ 		skb_put_data(found, frame_data, frame_data_len);
+ 		spin_unlock_irqrestore(&txdata->pending.lock, flags);
+ 	}
+=20
  	/* check if radio is configured properly */
 =20
  	if ((data2->idle && !data2->tmp_chan) || !data2->started)

--IBC+52lWwiJAH663
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqpVCUACgkQJNaLcl1U
h9B38Af/eKnFBgtukYy3uaCoiS2tMZBywYhcddFGeS3lTwc0NgZEIHQSlOlbQ61R
XZ84CAPu69WaEV5T8mFybJiqDlKSpYMzX3IGAlu24eUL7MZz2D1b5D8tqzC3w52Z
rAI5Droy4LblWw7Lfa/8wrswyrjqhW9ASonWBNdUD2a9ptzKN1vZyav4tY/ZopeF
3j6+laxXnpY5lVWngVSFg3Q8DqqJdr2FE5cm9iZhnIYL0QsIqKaE3l+DOGtx3nIn
2gxk4tjf5rF1xNKsJ9vdamC89jGuE6T6969kfoGMAz+ePj6LBTIKBXXvDbOwc84o
e4MS487B8onAPdGQ2cYImV5tlJtlAw==
=u395
-----END PGP SIGNATURE-----

--IBC+52lWwiJAH663--
