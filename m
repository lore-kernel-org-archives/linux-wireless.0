Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EF03AE6F6
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2026 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039321; cv=none; b=sCbp2SE8rWjxXr0yCHVyseB7odBN2alQCChABT5rB8upQEaP6gDiQ1ioniVlAjWlTQNFyUMvT26kui0dV86NRH0nwBhgCrprhbt9csIdNtBb+VIeW25cLIr0bnzKd0ScQc56YnocRwY3AB4G8zjrpdyfcZ/OCSRaTqZ20g3IFxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039321; c=relaxed/simple;
	bh=nVqLCiAZim3d8SUs3mpcg32WpZQalaPjSXIu93/Cpho=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BA/HhE7XarMfZA0Q/YOJaSAsVzLdcxCr3TVFg2BooVlqnhVeoa8uQZEub67Mffyatj4TQuDZOsqoUfK8ozvA4NCkcw3Kw14ZvQPZQkJk23g9/A0sptKWpkUH07t76vP73k9Xihx99kLQy1D96X2JyQQaAgviv4kMSS5kaw1bK6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KyAnDE8y; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KyAnDE8y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zosPDEsCL4IDJynYyVoAQpFRfpUtCyzrVIjgHj1I490=;
	t=1772039319; x=1773248919; b=KyAnDE8yWcvzqpO0gRph2Bk5lchGAu7ZdbtVwMPD/efjnrh
	g2DtiNHZqRrHlenC4SSQrsyF3lBP6u+W06MjLv/Xz7d39aGjET5aVhCRxn0N17rJTfaaAWW6nriWI
	X/OdoCtyT0qgHkprk2grNsbOSSNQMN8NQBgFKM97OOB5Nuzf0uoDeq9S+OJy0VpsuvVAxQ3SazQhJ
	ClumdIrDyTuV3Zn3v6MPX4gP1csM47OUc/QuBtV36mxBIsA9qODwY22XnXHfvxZNY8e0f1qXbpnhA
	HHtf5Y6jKG4Iqci1CBcTu+c9f+8IIhKoQWhFZR8ZhJ5MhEH9dPbIh5u1j5CfRQCQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vvINJ-00000001XqU-1T5G
	for linux-wireless@vger.kernel.org;
	Wed, 25 Feb 2026 18:08:37 +0100
Message-ID: <4957d35e090d54f098d27f937da70770bc001397.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: move action code from per-type frame structs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 25 Feb 2026 18:08:36 +0100
In-Reply-To: <20260225175252.03c5c338a7b2.I9a24328e3ffcaae179466a935f1c3345029f9961@changeid>
References: 
	<20260225175252.03c5c338a7b2.I9a24328e3ffcaae179466a935f1c3345029f9961@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned


And a couple of other notes:

>  				struct{
> -					u8 action_code;
> +					u8 no_fixed_fields[0];
>  					u8 variable[];
>  				} __packed chan_switch;

This thing in a couple of places isn't ideal, but I think it doesn't
outweigh the benefits of this structural approach.

> @@ -2665,16 +2645,15 @@ static inline bool ieee80211_is_timing_measuremen=
t(struct sk_buff *skb)
>  {
>  	struct ieee80211_mgmt *mgmt =3D (void *)skb->data;
> =20
> -	if (skb->len < IEEE80211_MIN_ACTION_SIZE)
> +	if (skb->len < IEEE80211_MIN_ACTION_SIZE(wnm_timing_msr))
>  		return false;
> =20
>  	if (!ieee80211_is_action(mgmt->frame_control))
>  		return false;
> =20
>  	if (mgmt->u.action.category =3D=3D WLAN_CATEGORY_WNM_UNPROTECTED &&
> -	    mgmt->u.action.u.wnm_timing_msr.action_code =3D=3D
> -		WLAN_UNPROTECTED_WNM_ACTION_TIMING_MEASUREMENT_RESPONSE &&
> -	    skb->len >=3D offsetofend(typeof(*mgmt), u.action.u.wnm_timing_msr)=
)
> +	    mgmt->u.action.action_code =3D=3D
> +			WLAN_UNPROTECTED_WNM_ACTION_TIMING_MEASUREMENT_RESPONSE)
>  		return true;

This is, unfortunately, a bugfix, as is:

> @@ -2689,15 +2668,13 @@ static inline bool ieee80211_is_ftm(struct sk_buf=
f *skb)
>  {
>  	struct ieee80211_mgmt *mgmt =3D (void *)skb->data;
> =20
> +	if (skb->len < IEEE80211_MIN_ACTION_SIZE(ftm))
> +		return false;
> +
>  	if (!ieee80211_is_public_action((void *)mgmt, skb->len))
>  		return false;
> =20
> -	if (mgmt->u.action.u.ftm.action_code =3D=3D
> -		WLAN_PUB_ACTION_FTM_RESPONSE &&
> -	    skb->len >=3D offsetofend(typeof(*mgmt), u.action.u.ftm))
> -		return true;
>=20

because the original MIN_ACTION_SIZE didn't include the action_code
field, and thus these were accessing without checking that it exists.

I don't think it's a huge problem that we need to fix separately though
given tailroom and skb shared data etc. will always be there.

johannes
