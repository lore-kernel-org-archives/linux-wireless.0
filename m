Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEB631355C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2026 11:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769598657; cv=none; b=N5YXoehuJl1nxbYfvSzpRG70hSRcnTCVtng+6rO/iuRT6pvQ7V8j81IKCROuSAPI+HFfF0PogL/+bb473YUH6wMJlDaVwYfyWl6P/gVbwuznUzJ2hdfEFJbfhUuNntSEW5Z9XtWWlqTCiDGYCGgcYW5Y0QK1k57Hlv8XtIMBCos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769598657; c=relaxed/simple;
	bh=kr7QiherA0Yaoh+rHM9Q6KN//d67FkNCKUPVVFd0Qmo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=txj/XxzO8Rv+qLvDgD6myS67QqEBcuXVEIDwKsUZXWs8jrZcKwxCwhvEHEAsj1e8SO3YYEJ8CBzyaZxXqIArUGi78FtqNaY4cJJUYar7s9CS87T2Bgr557jMblHAhOQR5A+9Kq7Xy8OlewHLaqfsCOtfaaGvD+fmKwXdZLCUMGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rKgJ7Tkd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rKgJ7Tkd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=dmGuiaA6b43TSGwumVFUcB5MdZ1eHZ60U35lf1MrGaw=;
	t=1769598656; x=1770808256; b=rKgJ7Tkd/PN9Fv3Y7ik+f0bMGqKTWdDVTZ62GcuZzbFE+G4
	wg2wuw8B1reFN5h8+Nyd749KlbeOYlHxnfmhEDg50ewrQpBFdX2pAkC4/LzY87lEFcJbzVdFTFIHF
	5O5PbuNPXZVDw3vtX5Hvqiv+gmRx4CHbjClNGMsB1AImDNgELgnsI61Rtj0V11A8oTYKF7PfkEOX7
	iG6U2o4ZX9XSbHFmdeaMpFwx1rZwdXyAtitoQBTGYp1lsw/qbnSkSmbd7AWVhQKvpw4FBKcNG1yCJ
	ZzWn1aJWK6ueRBqcWi02sATdhlSHOMa81vXxFGxCi68IC7lkUCAru39b4tisFTMw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vl3CF-00000005mhZ-1owA;
	Wed, 28 Jan 2026 11:54:51 +0100
Message-ID: <eedda8cfed21475dd98ddbe27f0fe8268093ef7a.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v3 3/3] wifi: mac80211: add initial UHR
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo MARTIN-GOMEZ <pmartin-gomez@freebox.fr>, 
	linux-wireless@vger.kernel.org
Date: Wed, 28 Jan 2026 11:54:50 +0100
In-Reply-To: <b9b2cf39-8989-40c9-8ffa-b1626217b773@freebox.fr> (sfid-20260127_171219_453132_DF89D731)
References: <20260127141005.583581-5-johannes@sipsolutions.net>
	 <20260127151005.751175e8035e.Ieec940b58dbf8115dab7e1e24cb5513f52c8cb2f@changeid>
	 <b9b2cf39-8989-40c9-8ffa-b1626217b773@freebox.fr>
	 (sfid-20260127_171219_453132_DF89D731)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-01-27 at 17:12 +0100, Pablo MARTIN-GOMEZ wrote:
>=20
> > @@ -1040,8 +1064,15 @@ static inline u32 sta_stats_encode_rate(struct i=
eee80211_rx_status *s)
> >  =20
> >   	r =3D STA_STATS_FIELD(BW, s->bw);
> >  =20
> > -	if (s->enc_flags & RX_ENC_FLAG_SHORT_GI)
> > -		r |=3D STA_STATS_FIELD(SGI, 1);
> > +	switch (s->encoding) {
> > +	case RX_ENC_HT:
> > +	case RX_ENC_VHT:
> > +		if (s->enc_flags & RX_ENC_FLAG_SHORT_GI)
> > +			r |=3D STA_STATS_FIELD(SGI, 1);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> Not sure this change should be in this commit

Well, it is needed here, and I didn't think it was worth its own commit.
It didn't previously matter because the SGI bit wasn't overloaded, but I
also repacked all the bits and overloaded the SGI bit (HT/VHT only) with
other bits for HE/EHT/UHR, since now I couldn't keep it all separate any
more.

I guess I could do it separately _before_ this commit, but that seemed
fairly pointless.

johannes
