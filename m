Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547F73624CA
	for <linux-wireless@vger.kernel.org>; Thu,  5 Feb 2026 12:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770294147; cv=none; b=RTFNBu6stxkV4CPbUmFgKUiCa/NEKdpa39UpD8m4AUnc+WDGqaNshT1SGuahlhZ24ODfc/tMa6vIw0ZoQAzv+SsMn2KnIMg0/Ld2gApI3gDeNe9/xCAy1Fw9pCM1/w/CAKUAnKX+4xZEmzmHlrV6EUhj8Gzdp3JIx9s03zgOLgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770294147; c=relaxed/simple;
	bh=LYnHXKeVbZa+M4NR3WMbfS+Fa/yIxoQhcSqfaojjSpA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tuxII3wpaBiPqCyzLnOGLsOHX7bSsKVAru2fYsRls2bwp3fIJr7t1Ne/E1m64d3XvjZBRnGiWL9GpGd4KHGdigbzcctoVwrj4PdA1pH7hNSoG4NXxiPFTM4Wsz1muT5BOW7UrJbA6GLIoH+Hona2dxjAByILeoH/rSZvJkNFjAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cIQhJn9/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cIQhJn9/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3nXX8yKGlRfTYwWjY3zbRlrgDFtd4yUo3R6gCXvHPFQ=;
	t=1770294147; x=1771503747; b=cIQhJn9/xsTk062kx97TocgoqyvonLzMV1yi0Qj9DUMhYoa
	FIyvt41/a7DOhOvVwn2mKXoRtMOp3ngX31W91eI1E4MT3ZPppT9NpQt2TluZBQc53v7nf/yLVvD9k
	Slq1JbYx1WXz9GAfO/BJjlWLPcEfmpDJPsHdU7v0PgoVrNMKLEZ73/qP1aW563n+mhx8OzqJxHD/R
	xABEXvo4tCakvqadmnZoE5k0eAwTiurZhTyiaKucNqNIws5qbbfkcCptl9wRMPDI3ryGbn3CLksM4
	Zc0pwZtnustPfAibH7GAw64hgshC3PMtxYnRqJTIcvr5GinWtt8/C6CbEH0iFO3w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnyNM-0000000FZD1-07I9;
	Thu, 05 Feb 2026 13:22:24 +0100
Message-ID: <f28034e35e7b1e9c942de3b78a8b03de9e2833cb.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v4 1/3] wifi: cfg80211: add support to
 handle incumbent signal detected event from mac80211/driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Amith A <amith.a@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Hari Chandrakanthan
 <quic_haric@quicinc.com>
Date: Thu, 05 Feb 2026 13:22:23 +0100
In-Reply-To: <20260205112146.3997044-2-amith.a@oss.qualcomm.com>
References: <20260205112146.3997044-1-amith.a@oss.qualcomm.com>
	 <20260205112146.3997044-2-amith.a@oss.qualcomm.com>
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
> +++ b/include/net/cfg80211.h
> @@ -10423,4 +10423,27 @@ cfg80211_s1g_get_primary_sibling(struct wiphy *w=
iphy,
>  	return ieee80211_get_channel_khz(wiphy, sibling_1mhz_khz);
>  }
> =20
> +
> +/**
> + * cfg80211_incumbent_signal_notify - Notify userspace of incumbent sign=
al detection
> + * @wiphy: the wiphy to use
> + * @chandef: channel definition in which the interference was detected
> + * @signal_interference_bitmap: bitmap indicating interference across 20=
 MHz segments
> + * @gfp: allocation context for message creation and multicast; pass GFP=
_ATOMIC
> + *	if called from atomic context (e.g. firmware event handler), otherwis=
e
> + *	GFP_KERNEL
> + *
> + * Use this function to notify userspace when an incumbent signal is det=
ected on
> + * the operating channel in the 6 GHz band. The notification includes th=
e
> + * current channel definition and a bitmap representing interference acr=
oss
> + * the operating bandwidth. Each bit in the bitmap corresponds to a 20 M=
Hz
> + * segment, with the lowest bit representing the lowest frequency segmen=
t.
> + * Punctured sub-channels are included in the bitmap structure but are a=
lways
> + * set to zero since interference detection is not performed on them.
> + */
> +void cfg80211_incumbent_signal_notify(struct wiphy *wiphy,
> +				      struct cfg80211_chan_def *chandef,

chandef could be const, I guess?

johannes
