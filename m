Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764513D333A
	for <linux-wireless@vger.kernel.org>; Thu,  5 Feb 2026 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770294248; cv=none; b=kl0suUOWXiMrRQ2qZbNJUYvckYG6QjS2O/q2WLvlJLiquXdFJU5GSbGxRc6SfAXDy49f0bwk5RYLoJl5+k3IJQeZpS+kI0FirGjEKtssUxg6jr3kfFHMUn5bfVBMsagWyc87a/L3EWjUR1pLRV66KAN1UoMJj2dAwpjYgG3SGQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770294248; c=relaxed/simple;
	bh=IPCeSh7V9EXSPopjN546VZyz0VWzlAb7l975RLqfZXc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bLp0gYMRYgKEjohC+7uCIL4aKPeCh2zYjY04rGhkGXVijGQMXzxXTBVn5FXhXnMTljs3ob88j83EGvPw5A6GX0vQPHahdMsQd9gtmz4zRzhjryGbxo4U3y7WIp5qtSVRB8+mVrGgIp4aB0RRny/WqLGkn71kDAqPXZVOb0XQKgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=MDLWmWer; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="MDLWmWer"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NFmb5bef6kcBLZUF6pwCGrUrbCKiJY54dA8EPt+wbcI=;
	t=1770294248; x=1771503848; b=MDLWmWerybvd4hmWPDOQLypb/8wTOCXIih+pIXnwtCVdB52
	9Gs9ANq6yspgklxoonAi+Mxay62BsDNKg74QH+KB4RMjHNBomLMM/+fhvn8deHYdofUxSdUj+ErZw
	u5uklG/azLuGGU+eJ+6x3c6e5ntkmEpJbsis6woe8Cr3omqdr/Gc2RuhliD5athhhJTcoh5wKjJnl
	661oSzMo4XhRVxVwCg7RwYKXcw+spYrxxKFwtWehPg9S+m9Gl7/KDdCie425NayAqDwFXNsZ0Adus
	kLwMVsLe7Mh4E4OpmOizodtwQ+TMnDzOuIUm1V1iCxWMq6rDO/vCIss18+fYgrSQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnyOz-0000000FZH1-1Z35;
	Thu, 05 Feb 2026 13:24:05 +0100
Message-ID: <858522d4e40ec73197bda6a9753b2eac8c07d145.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v4 3/3] wifi: mac80211_hwsim: add
 incumbent signal interference detection support
From: Johannes Berg <johannes@sipsolutions.net>
To: Amith A <amith.a@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Aditya Kumar Singh
	 <aditya.kumar.singh@oss.qualcomm.com>
Date: Thu, 05 Feb 2026 13:24:04 +0100
In-Reply-To: <20260205112146.3997044-4-amith.a@oss.qualcomm.com>
References: <20260205112146.3997044-1-amith.a@oss.qualcomm.com>
	 <20260205112146.3997044-4-amith.a@oss.qualcomm.com>
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

On Thu, 2026-02-05 at 16:51 +0530, Amith A wrote:
>=20
> +static void hwsim_6ghz_chanctx_iter(struct ieee80211_hw *hw,
> +				    struct ieee80211_chanctx_conf *conf,
> +				    void *data)
> +{
> +	struct ieee80211_chanctx_conf **out =3D data;
> +
> +	if (conf->def.chan && conf->def.chan->band =3D=3D NL80211_BAND_6GHZ)
> +		*out =3D conf;
> +}
> +
> +static int hwsim_write_simulate_incumbent_signal(void *dat, u64 val)
> +{
> +	struct mac80211_hwsim_data *data =3D dat;
> +	struct ieee80211_chanctx_conf *chanctx_conf =3D NULL;
> +
> +	ieee80211_iter_chan_contexts_atomic(data->hw,
> +					    hwsim_6ghz_chanctx_iter,
> +					    &chanctx_conf);
> +
> +	if (!chanctx_conf)
> +		return -EINVAL;

Wouldn't it make more sense require userspace to write also the
frequency, rather than randomly picking the first 6 GHz chandef?

> +++ b/drivers/net/wireless/virtual/mac80211_hwsim.h
> @@ -343,4 +343,6 @@ enum hwsim_rate_info_attributes {
>  	HWSIM_RATE_INFO_ATTR_MAX =3D NUM_HWSIM_RATE_INFO_ATTRS - 1
>  };
> =20
> +/* no longer used - previously used for debugfs iterator */

Hmm?

johannes
