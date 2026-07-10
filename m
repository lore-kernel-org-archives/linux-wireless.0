Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC153A3816;
	Fri, 10 Jul 2026 06:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783665588; cv=none; b=bqPQI2njVNVkSYLFOicVvoqIwhwsyMoph76qCpOqpVjnbF8JS5KTo545ufRx2sFRcqwuJWmBwoV0xKIbi8XohqZYk9vh+Es4gCvagkHVzilHuWVbRhmnov571gBKN6LL8VubeL+GMwXe+uDpnv3yOJ/Hrl4b/MZW8sPgbm94azc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783665588; c=relaxed/simple;
	bh=uvwC1xV5faI68gjI1weMPLwe8itefRUthxTz0voFJps=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xaijj2gbTJGyLUUFJwfCqH7EowSBpMoORHeJ8flBnPMXAthYf2PjYMVV9vtuYbC7tFhQVLjcHd4vc2kxCUlKWeNqSYnp4Y/VosyPhW6kFYYF8SCtlMiawDx5lNxLO1/D5g897TZcdBKJSNP4shwJ+Xcv11PYcUkqhRMgTJGrnzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RCcNiaGd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RCcNiaGd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=299SMD9UDfkbdGNtEVQk7Hr4iqxQ+YQoz1GOFSUth74=;
	t=1783665584; x=1784875184; b=RCcNiaGdf9O21eaVXqqjJ0glz5x/r51wOvNUuXtQ12lBgoA
	94qoDwGNPI2yRGkQN8hA8wLVvvs6d4xlc6S6ttlZpuOk+7ab3anmFTVTUTaQB2icQmQLoqEicRNSX
	23QQmWXTRosO+xSTqx3E+la9y4o1Gs4ZEuWd1DlVZcRNhhjZ3cMdZr4v0CIn/8X8KLI5ztdmHBbFh
	ObTzkYjb56vzlEp8Rw+wceJaomJAJqdE+wV6QJZq+90rPUHMPY1ME9IAGx+k6jvi4pH6H03+4L6bR
	PI0U002ecUAnt/XNz6IdaBpeopHg4yi9D+DoAMs5/gmWC8T5s9ByBO+XOpzMsmDQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wi4th-0000000CFI1-30uo;
	Fri, 10 Jul 2026 08:39:41 +0200
Message-ID: <6be574903752d95ae7125461c38cc30b8a641d24.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
From: Johannes Berg <johannes@sipsolutions.net>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Date: Fri, 10 Jul 2026 08:39:41 +0200
In-Reply-To: <20260710024637.16729-1-kartikey406@gmail.com> (sfid-20260710_044649_032516_DA33F864)
References: <20260710024637.16729-1-kartikey406@gmail.com>
	 (sfid-20260710_044649_032516_DA33F864)
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

On Fri, 2026-07-10 at 08:16 +0530, Deepanshu Kartikey wrote:
>=20
> +bool cfg80211_validate_ies(const u8 *ies, size_t ies_len)
> +{
> +	size_t pos =3D 0;
> +
> +	while (pos < ies_len) {
> +		if (pos + 2 > ies_len)
> +			return false;
> +		if (pos + 2 + ies[pos + 1] > ies_len)
> +			return false;
> +		pos +=3D 2 + ies[pos + 1];
> +	}
> +
> +	return true;
> +}
> +EXPORT_SYMBOL(cfg80211_validate_ies);

I don't believe you'd need to even export this, and we also already have
validate_ie_attr() in nl80211, written in a better way too...

johannes
