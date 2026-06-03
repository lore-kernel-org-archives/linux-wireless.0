Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9021A2376FD
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 11:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780487467; cv=none; b=acyka2UaySP29O1qeNaB61o4LMCFq3mKVxvBrVeBqiX0WLpHeAfbR98mbPFKUwHx8N+TjLWpCdIH01Vg6iHOFBPHvsmOpPTeKcC7f3KrjmtnZ/N3/KYfILDpPtHa1WCRvbYA2HXACRvQ+6XW6+ueFjGKY10W8BLHRT06weGzghQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780487467; c=relaxed/simple;
	bh=MUzBG2byChqYWJazHpdbmj1KGZDDTPK5zFfTmwbfwFI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XPkr3Siw3kh5OVSF0cN4M9gRdNmzGODXX4RxVC6YNUiCBYs8ckdOx6BY6L/MIFn3u4WNgj6Ioi4JK33LKEmGZEQmdaseR+XITEaEg/fVhDaWa7NkT3bp/aADuA0E9e4qDnkCbYU4X8DGPd/V9+PqUE4lCwU76oAoyjV7+hQQMoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=i5xGKq2d; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="i5xGKq2d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=XS0JcBJcWZs0bYSxeEdhoTQC4sn4idqJunQcKiCYlrg=;
	t=1780487466; x=1781697066; b=i5xGKq2dcqEemQe8RGTWzIrHSpslCFo/b8kVyLhnSThpoQN
	9nL7U8KMmjXterr2iFOz1xPQ9a64ni4uSEpjI4Exi2muW/1/IZGVWM2ZbPy3RRKDT06Tiai947PNC
	HS0vTZuZ7n98c9Mg2DKGFQRDAIkgjQ6Bnbf/ti8o2RhqE9bxZCCq/Nv0EEFff8hPhKAsJ+WbBtb79
	27Idxy31yO0E1cpi/l8zUDEHPjDJ1EqlL8BYwrnRncOna7VcjtXlLuivd/tB9VbklXUfv1ixBGtZK
	JPz8POQCKiesTKhQ0//w3uLNL57oo5ZiyOE+DB8a8MP6rs8lwXz4I1owslGuuPNA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wUk7j-0000000H5yW-32u9;
	Wed, 03 Jun 2026 13:51:03 +0200
Message-ID: <65f29f24202259814399a10c8e5f0947e2842f8f.camel@sipsolutions.net>
Subject: Re: [PATCH wireless v2 2/4] wifi: mac80211: estimate expected
 throughput if not provided by driver/rc
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Wed, 03 Jun 2026 13:51:02 +0200
In-Reply-To: <20260528111756.848243-2-nbd@nbd.name>
References: <20260528111756.848243-1-nbd@nbd.name>
	 <20260528111756.848243-2-nbd@nbd.name>
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

On Thu, 2026-05-28 at 11:17 +0000, Felix Fietkau wrote:
>=20
> +static u32 sta_estimate_expected_throughput(struct sta_info *sta,
> +					    struct rate_info *ri,
> +					    struct ieee80211_bss_conf *bss_conf)
> +{
> +	struct ieee80211_hw *hw =3D &sta->sdata->local->hw;
> +	struct ieee80211_chanctx_conf *conf;
> +	u32 duration;
> +	u8 band =3D 0;
> +
> +	conf =3D rcu_dereference(bss_conf->chanctx_conf);
> +	if (conf)
> +		band =3D conf->def.chan->band;

That doesn't seem right, just return 0 if there's no chanctx.

>  		for_each_valid_link(sinfo, link_id) {
> +			struct link_station_info *lsi =3D sinfo->links[link_id];

better call this "link_sinfo" as elsewhere, even if lines get a little
longer.

Anyway, I had already, but the whole series doesn't build :-(

johannes
