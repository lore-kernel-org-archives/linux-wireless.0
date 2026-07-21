Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00CF46AA72;
	Tue, 21 Jul 2026 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647908; cv=none; b=Iv9X9kqhRiP4BHuXjVAc3nKaR0Au7F8CXsa2X+P4NqhmHoWbFTChoPPdwO2p8rUIwl6IPrqcqJ7GMZ6IwPMuzu+Za5kT3/U85VPzMBYljgzX86IcooR9RlthRY/9hQGaWhXcCg8QixPdu743m6e3Wn9EoQuuD/D9agECEHPonE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647908; c=relaxed/simple;
	bh=b7leHrNt7HQnZJdrHy+OvMuor5X1wVjS6HQzGmh7uCA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z8eUJT9EsUopQ/J+Xo3LCpF4B0GvZjy7B9aQk5dM7CR5Yblr4O23HESJX86lSEZ/Ro1IwvrnAOmKvmQ+iffwLcCqNgZht5V7NQFci1p0bBIX1TogqwStO3oHws8tA/KQTR6AdavAlkxJZUGc1aSxnsEP3V62XGIUPDogzxBbtr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ETjrctAI; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ETjrctAI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KsLbwGn1oIwL/2R+4c5lMw+n1JqMOoF3a22gFY61ez8=;
	t=1784647906; x=1785857506; b=ETjrctAIL4jVsnvF1tn0d9EtUUve1mhpaeBpkJZhZ7AVfaH
	35vn88MKoDmAbdLIgxQKYvvU4X9ubh0M+opZhhgtzFM069MvdTH1SrzEK0AWpPYjmaOPpXwjUHNmi
	qJM8pSr4UmrX11X80yIrzajwin66sYSKH75OIOJ7dUoXc+b9ZzdupA1iWAMbKAc9Jvm0Qk86JdvN0
	gIrrCqGPwu9y3meVeuNJwm/v9aCjAcm/z6avcXX904jcUSdaFT18Cb7cMWjELe6QqsSyw2IZNiGFO
	Uo+LU17Wkkj6YkHvDoEJTB4NTvvwKVMk+Zyz06TgQ6Kzc9uruUAp7RG52G3ICdYg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmCRc-000000028Hq-0rqe;
	Tue, 21 Jul 2026 17:31:44 +0200
Message-ID: <2629d83dd460f3d9a60566f3fad975db13b045c3.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: nl80211: say why the association BSS lookup failed
From: Johannes Berg <johannes@sipsolutions.net>
To: Louis Kotze <loukot@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 21 Jul 2026 17:31:43 +0200
In-Reply-To: <20260711043432.2767225-1-loukot@gmail.com>
References: <20260711043432.2767225-1-loukot@gmail.com>
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

On Sat, 2026-07-11 at 06:34 +0200, Louis Kotze wrote:
>=20
> +/* why __cfg80211_get_bss() found no usable BSS entry */
> +#define CFG80211_BSS_MISS_EXPIRED	BIT(0)
> +#define CFG80211_BSS_MISS_USE_FOR	BIT(1)
> +
> +u32 cfg80211_get_bss_miss_reasons(struct wiphy *wiphy,
> +				  struct ieee80211_channel *channel,
> +				  const u8 *bssid,
> +				  const u8 *ssid, size_t ssid_len,
> +				  enum ieee80211_bss_type bss_type,
> +				  enum ieee80211_privacy privacy,
> +				  u32 use_for);

This seems ... messy, and also racy? I really don't like it, so you're
going to have to work extra hard to convince me of it.

> @@ -13068,8 +13073,23 @@ static struct cfg80211_bss *nl80211_assoc_bss(st=
ruct cfg80211_registered_device
>  				 IEEE80211_BSS_TYPE_ESS,
>  				 IEEE80211_PRIVACY_ANY,
>  				 use_for);

can't we just pass the info (or NULL) to __cfg80211_get_bss() directly
and have that fill the right problem message there? There aren't even
any callers to it outside of cfg80211, and cfg80211_get_bss() can just
pass NULL.

johannes
