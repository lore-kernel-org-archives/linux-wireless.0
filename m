Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DC3367B7E
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2026 08:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779955496; cv=none; b=bHeU4IMJrmYfZD3oULW4oUiuIJ/gQU38p6qjs5P/HMpxeTb9Dlq9pQ0T7ZjFsVKyoHb+pv/xiah/zF2w2vGgqtLZofOXdE6FgUpGu4KmXULCdh8YolOtZAFft0/EmMcmpaXkzgmaOv72cVNNACOSWNkJ5oFdDH1d1PbPrBksd24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779955496; c=relaxed/simple;
	bh=uzL6dkjocgBpnSg+uUrT3IJgsgEsCmrR2LwVbJU6+m8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cTsNNU7bqY/6OgplgLRu/uWAzHw+vEQ0IpJ5qh5OGrxppZNTD8u6fUY0/8gde/a4WQgruwETPgS8hvGwWwgbGv7TqmwfixkaO/xPzJgLmtl6cSQriDtKHVZzbf+xjmUeruRfx/vFUjUd32MJFd7OnJ6wlEg9v1n3a+bhkQyNbHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bHixHi0R; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bHixHi0R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=IVyJNux1B3pzKSR+3iEDuqJ7QC81+q5tTGHFtAP3G80=;
	t=1779955495; x=1781165095; b=bHixHi0R5NeNwp4/pJkFq3mL2aufzxdJbaa9jlf+1FxLODm
	NjDOCZiIx6Rrq46gSH09JsSoQCr/+JlKC3uISfJ+Jx1B+kJxSKUh7tKyqKnldt3k1r6kjWBuIwzoO
	6eF04iWq2z3/myZ9BoEKUiHtT3e+LtbtXhFVFh5GZJL3EsB267mPeWtHPKXD2oQYG78jn13YGbVNP
	hP1m6SejspwYkdA8THASJJfgYgQgciTSlnIPU1aEs67NjFiDu1aPrLZT7OzlKS8cafqHUtLUeq7lv
	VGGP9qWDoR6nfm5kCpGuXCvhvnlVEuQU93shFJ1N25vncooaKFRTkKHLZhzz+zBQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wSVjY-00000007Bh0-2zIv;
	Thu, 28 May 2026 10:04:52 +0200
Message-ID: <f268572dbc71a4941523c510349207afb3fbe34c.camel@sipsolutions.net>
Subject: Re: [PATCH v8 4/6] wifi: mac80211: Fix overread in PREQ frame
 processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>, linux-wireless@vger.kernel.org
Date: Thu, 28 May 2026 10:04:51 +0200
In-Reply-To: <20260521225842.31815-4-masashi.honma@gmail.com> (sfid-20260522_005857_938875_E4A88BEC)
References: <20260521225842.31815-1-masashi.honma@gmail.com>
	 <20260521225842.31815-4-masashi.honma@gmail.com>
	 (sfid-20260522_005857_938875_E4A88BEC)
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

On Fri, 2026-05-22 at 07:58 +0900, Masashi Honma wrote:
>=20
> +/* IEEE Std 802.11-2016 9.4.2.113 PREQ element */
> +static inline bool ieee80211_mesh_preq_size_ok(const u8 *pos, u8 elen)
> +{
> +	struct ieee80211_mesh_hwmp_preq_bottom *preq_elem_bottom =3D
> +		ieee80211_mesh_hwmp_preq_get_bottom(pos);
> +	u8 target_count;
> +	u8 needed;
> +
> +	/* Check if the element contains flags */
> +	if (elen < 1)
> +		return false;
> +
> +	/* Check if the element contains target_count */
> +	needed =3D sizeof(struct ieee80211_mesh_hwmp_preq_top) +
> +		 (ieee80211_mesh_preq_prep_ae_enabled(pos) ? ETH_ALEN : 0)
> +		 /* Originator External Address */ +
> +		 sizeof(struct ieee80211_mesh_hwmp_preq_bottom);
> +	if (elen < needed)
> +		return false;
> +
> +	target_count =3D preq_elem_bottom->target_count;
> +	if (target_count < 1 || target_count > 20)
> +		return false;

While this is correct now, I think it's perhaps too tricky ...

The reason it's correct is that needed starts out with at most
sizeof(top) + ETH_ALEN + sizeof(bottom) =3D=3D 17 + 6 + 9 =3D=3D 32, target
sizeof is 11, so 20*11+32 =3D=3D 252 and cannot overflow.

But I think it'd be far simpler to declare "needed" simply as 'int',
then even with target_count =3D=3D 255 and whatever else happened before
cannot overflow, the elen=3D=3Dneeded check will promote to int and refuse =
a
bad target_count implicitly instead of needing to do so explicitly to
avoid the integer overflow.

johannes
