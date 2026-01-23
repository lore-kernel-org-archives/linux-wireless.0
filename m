Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8632AD3D
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2026 19:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195316; cv=none; b=PoxiVlljwOOrAFjv/7bwbJNXRMDIxY/ygSvVjO8f3XQ61Rma/SY9QbvSjapCFywg29nrHgeXb3Aog2qCfr8B3qu5G+WhodDHd3hYGyjMJgn7JdvlR9cln4aPtdALxzCjCHzXxWUzjJtjFoUmoNys2VrZy7ol6dxy3FEj/+os/KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195316; c=relaxed/simple;
	bh=BT5WvT6ihb9n+xd7mCsyz0hB+jv97svxCIvVBIbuRtU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rdFtiOPJEUZvGursvz+DQaeAvzOgfNopV5GjpiwGMzd82QVAMkXscaUdavhoD9U2Nx68svAD+2YhJO6s2dBxgdFf3e9f/18TlP8vAKv9fjPQaUOv2/OHCghLgxVaLo5icC2YSPvV+3+Hd8e71YohCljUjj5szeYu4QuO+cg1hDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=yaA5M1MS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="yaA5M1MS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+lvFd0/mWJQ6ENIAOZ/bB5AWBB9sjd4l9xVMv6ZlsWc=;
	t=1769195315; x=1770404915; b=yaA5M1MSvbESdL2g04fv6u2AjkRc9WmMdk5NwcjPvXlMPDF
	mgu1oCZ1LwtUrWUeAU5Sw2awuS7L4DgTsk1WILLYYqsn27o7rbCvkH5hOsB3A6vO8jS/jKMhgNI1h
	WwTgbdQQGBCRTnZ6WRy46cU7UKNh8Q9sH1U+WRXiFlCpnrAnXUJBV8qaiufdWeJ8Jxj2mVFvdCmzx
	0rcTYu8IoHt3px5jmhTnFNNqX6D8xPtqdrXOt3Wnnb8+iVK0G3tNftxejkRRMVhSOdU0s2JoY69Ez
	j8FPSw3YfuZ9jLARG3N+aSyRUyEOFmyPYPCY7Fch4S0klkMxxV8tOjwTAtbNBWUQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vjMWF-00000001phA-38b6;
	Fri, 23 Jan 2026 20:08:31 +0100
Message-ID: <bfed10db742d29f0609acb04d3354695f87b24e2.camel@sipsolutions.net>
Subject: Re: [PATCH ath-next] wifi: ath12k: avoid setting 320MHZ support on
 non 6GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo MARTIN-GOMEZ <pmartin-gomez@freebox.fr>, Nicolas Escande
	 <nico.escande@gmail.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2026 20:08:31 +0100
In-Reply-To: <d26ee979-b5d5-4f50-b423-f8783122f603@freebox.fr> (sfid-20260123_193336_255577_6E33DF75)
References: <20260123144224.2216923-1-nico.escande@gmail.com>
	 <d26ee979-b5d5-4f50-b423-f8783122f603@freebox.fr>
	 (sfid-20260123_193336_255577_6E33DF75)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-01-23 at 19:33 +0100, Pablo MARTIN-GOMEZ wrote:
>=20
> > @@ -4901,8 +4902,14 @@ static void ath12k_wmi_eht_caps_parse(struct ath=
12k_pdev *pdev, u32 band,
> >   	for (i =3D 0; i < WMI_MAX_EHTCAP_PHY_SIZE; i++)
> >   		cap_band->eht_cap_phy_info[i] =3D le32_to_cpu(cap_phy_info[i]);
> >  =20
> > -	if (band =3D=3D NL80211_BAND_6GHZ)
> > +	if (band =3D=3D NL80211_BAND_6GHZ) {
> >   		cap_band->eht_cap_phy_info[0] |=3D support_320mhz;
> > +	} else {
> > +		phy_cap[0] &=3D ~IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ;
> > +		phy_cap[1] &=3D ~IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK;
> > +		phy_cap[2] &=3D ~IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_320MHZ_MASK;
> > +		phy_cap[6] &=3D ~IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_320MHZ;
> > +	}
> If you want to clear all 320 MHz fields, you'll also have to clear=20
> IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_320MHZ and=20
> IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_320MHZ (not sure why it is not done=
=20
> in mac80211)
>=20

This is, effectively, a firmware workaround. It doesn't belong into
mac80211. All other drivers just have their capabilities managed in the
driver anyway.

johannes
