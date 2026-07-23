Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BAD470449;
	Thu, 23 Jul 2026 11:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807495; cv=none; b=N95zYVlPjpYELiFoRA8w1SyhdMyZv7mNPjgQPEcL+HGxwV5Fpq3nSwrWgFp03wUysSCqCcgyUXL90516UWDvdkJ8fgoGUjYoE3NWQPgnYBdB7zuIjxPfjty8Dx8SE6CCjT5gvUCtAoccDyUZDtIqrr3KDwcaDO+G3pKyuNVN3d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807495; c=relaxed/simple;
	bh=4cremXzyNwOkOqPxCxyprtBbUCrYRn3SXpK0utExZv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EuLg3Cds4w8ax3k5bE7svZeSpL9z2nHtjKJWNPW6RF9IDkgX4XyjSGgEu03PfbSoucTQeoce0ltfIq5SFoX26sl6zpbWcdbwOufvFubWd9Mo57oIy4aarhDfx7+XB59wsGqyTYfvrAPqRi+fjatubveOPiwkJ/lTIwRtk49vApU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928C61F000E9;
	Thu, 23 Jul 2026 11:51:24 +0000 (UTC)
Date: Thu, 23 Jul 2026 12:51:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Enderaoe Lyther <enderaoelyther@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 origin tree
Message-ID: <ac48f782-3fbd-4c61-89d0-4dd032ca81b9@sirena.org.uk>
Mail-Followup-To: Enderaoe Lyther <enderaoelyther@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
References: <amDoh8ypkkAY-vvc@sirena.org.uk>
 <CACHPgzzDmfDii3MVsjukiGYqZrd+iKur6T2+iRV11YBdqof3=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TPcIYLsJMIho0AIz"
Content-Disposition: inline
In-Reply-To: <CACHPgzzDmfDii3MVsjukiGYqZrd+iKur6T2+iRV11YBdqof3=w@mail.gmail.com>
X-Cookie: (null cookie


--TPcIYLsJMIho0AIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 03:53:59PM -0500, Enderaoe Lyther wrote:

> Thanks for carrying the conflict resolution.
>=20
> I noticed one semantic conflict later in ieee80211_rx_mgmt_assoc_resp().
>=20
> Commit 035ed430ce6a2 ("wifi: mac80211: avoid non-S1G AID fallback for S1G
> assoc") added:
>=20
> 	else if (status_code =3D=3D WLAN_STATUS_SUCCESS)
> 		goto abandon_assoc;
>=20
> where abandon_assoc destroyed the association data with ASSOC_ABANDON and
> notified the driver.
>=20
> After f13e573ab3f12 ("wifi: mac80211: notify driver before destroying
> assoc link") folds the driver notification into
> ieee80211_destroy_assoc_data(), the equivalent target is
> destroy_assoc_data, since assoc_status is initialized to ASSOC_ABANDON.
>=20
> next-20260722 instead has:
>=20
> 	else if (status_code =3D=3D WLAN_STATUS_SUCCESS)
> 		goto notify_driver;
>=20
> which bypasses ieee80211_destroy_assoc_data(). I believe this should
> instead be:
>=20
> 	else if (status_code =3D=3D WLAN_STATUS_SUCCESS)
> 		goto destroy_assoc_data;

I can't tell which bit of code you are talking about here.  I see there
is a block at line 7274 of -next:

        if (elems->aid_resp)
                aid =3D le16_to_cpu(elems->aid_resp->aid);
        else if (!assoc_data->s1g)
                aid =3D le16_to_cpu(mgmt->u.assoc_resp.aid);
        else if (status_code =3D=3D WLAN_STATUS_SUCCESS)
                goto notify_driver;

but that is immediately after another goto notify_driver, there's
further notify_driver error handling afterwards and all the earlier
error handling is return statements so it looks at least unclear what's
supposed to be going on.

Please don't top post, reply in line with needed context.  This allows
readers to readily follow the flow of conversation and understand what
you are talking about and also helps ensure that everything in the
discussion is being addressed.

--TPcIYLsJMIho0AIz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiADcACgkQJNaLcl1U
h9CQfAf+MBSPPrNS+xcyPKnQI8hhoKpCpl3HE4M/nXx05QkgdAVw2Etk7eVbIw0H
kbd8Yj9E0LzglqInONMuTT/MJocmgmVm5W/8YD8CJZlT73Bl2xGukdKXC9JXMm24
dA35Z42OnYsYbwxrY9k1M6Nj/tT+Wb8D1A0z61kJ5iq1XVyIpdmV0ZWecNRqpHTL
O8HAudm2yo0Y9JOknJdJiVMTv0OucDr8FBK71mTFldRSrTbMR8PXYXDrMRQSc9S4
JiQ8Aa7jsDPOcbdgn3/hoD0UOaVNZjFoU41TfTmrNu0qXMr/iVENaiURUxsDzSCh
chsxIcLSgcNXTNCyaAJjzzlLktalRg==
=TA/c
-----END PGP SIGNATURE-----

--TPcIYLsJMIho0AIz--
