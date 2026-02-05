Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B866F3A9628
	for <linux-wireless@vger.kernel.org>; Thu,  5 Feb 2026 12:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770294113; cv=none; b=dDGT68HsGjT4J4sp9mG5VXer5CWnZ5ozFjNXl2+avHFGD1W0+7Xf2GsQCAEGkiyCaSbo8g6MN47TbZVjgWSCEV7osUB0Lh7BivXtkyWuxyWCC7YXfNVCw9yeiY8wioeHtuG5W7as8Utqxnhso42HsCyf6ekTsReD9R8cEiEvBrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770294113; c=relaxed/simple;
	bh=1u0VtszlMh4FQhBKYDp5+Rrh9feHnQHVPMRn2Ho7Jpw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K29vKudXaLwj9HuvxumulJX089wKAV6agBwUqFvpLH3R1Twhv3Wa2jOz4r14c0Dto+sHmVU7E3+M1b+6CgS8rE0Lfoski9I9Cfdoi+SSdytv5MkniyP6MoNZ+IFxvmrEshe0z352T4kLFNo6qfoQINPv3qeoCCx/inzPCLfbqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ng5S71de; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ng5S71de"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ToATEogP6EfcG/xuWj7xP8g8AVqoxg+ZL59tPYZhSc0=;
	t=1770294112; x=1771503712; b=ng5S71deuR27YHTX6EhrnECWuRp9stb37N6a11CBnSAgIdD
	av5sI4TndK8s5+NE+GTajQGLiQVEOfSK9eb0w5+cUaUp/KwVWz2wcLx0VaKQ9qP6OURIwD2bygZbQ
	HvqICzKtlcXka/0sQtVwRVA8z7oX5R9FKmogks+7dWrCp+mMODFQxHfy7puKe6814u0rwerQj6M4i
	TO4JPskQ0PStSPuUZCjDLWxJ5auIW4bUAJO2M6ulfLDMMaC10+QYQmQhdFG685mC9ZhvPR0AS2LyP
	ILOZaz2/20h+Vn5sCXoUwZ8i43Ooha99UGMZFZ33HeCejNg6pddzG7EK0leLO0Wg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnyMn-0000000FZAL-0b71;
	Thu, 05 Feb 2026 13:21:49 +0100
Message-ID: <6d5004e1e1af3f18c42c3a370db815fb4bf82b44.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v4 2/3] wifi: mac80211: add support to
 handle incumbent signal detected event from driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Amith A <amith.a@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Hari Chandrakanthan
 <quic_haric@quicinc.com>,  Aditya Kumar Singh
 <aditya.kumar.singh@oss.qualcomm.com>
Date: Thu, 05 Feb 2026 13:21:48 +0100
In-Reply-To: <20260205112146.3997044-3-amith.a@oss.qualcomm.com>
References: <20260205112146.3997044-1-amith.a@oss.qualcomm.com>
	 <20260205112146.3997044-3-amith.a@oss.qualcomm.com>
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
> +void ieee80211_incumbent_signal_detected(struct ieee80211_hw *hw,
> +					 struct ieee80211_chanctx_conf *chanctx_conf,
> +					 u32 incumbt_sig_intf_bmap)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +
> +	trace_api_incumbent_signal_detected(local, chanctx_conf, incumbt_sig_in=
tf_bmap);
> +	cfg80211_incumbent_signal_notify(hw->wiphy,
> +					 &chanctx_conf->def,
> +					 incumbt_sig_intf_bmap,
> +					 GFP_ATOMIC);
> +}
> +EXPORT_SYMBOL(ieee80211_incumbent_signal_detected);

There's nothing here that couldn't be done directly by the driver
(except tracing), do we even need this indirection? Caller could just
call cfg80211 directly, no?

johannes
