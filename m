Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287EC43D4EA;
	Thu,  4 Jun 2026 11:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780573597; cv=none; b=ogChQj0xQZEqm3ImNu+Qbh+TAME9CYgmZBCgXtjpz55NKb0rTk3e2X4ouReTXMIe5sMhqO+9BKl2Pg+Jm6Q3P3tOfNhG7bYDLWdITxE4t3O5wTNGI04G78kF3E9IdvwiTKQ0090Weunp8FHHnVb1SBP975DfSYUPPrwWEGENQhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780573597; c=relaxed/simple;
	bh=MZoTNUM0bLA4e4Pbq3sV7WNAMdw43dLUjyDx69xOSlk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NUjFzz1s+3Ceu5OEmy+7ZTTnjXfygKxikIWAYK6FoEg6iun4v6NG++x8rLY8yGWUzKx3AQZG1kPX5CPfXp7wpwphNXGM0n5M0eHPOlSwiZPlzIZe6NgROVlNyX7xdnf+TMo6kAguHKfpQwfjRUSZePsIC67XDcBmh5YgZ0hSqII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cdInJwL/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cdInJwL/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=sskuNj0//ghORhAy9iq8CDfjzaPnzOkkMQ5QDktBcsk=;
	t=1780573596; x=1781783196; b=cdInJwL/5DHC8L4aJF6f9eYoJUG/8Fa+FnAmIfO+PiJ1QgU
	ctuPAM4FPAcrhYC/modFPON9olGmONHM68hVnoCVJCZBz4FdLSK6/K7byBX2hYTOwN5Eu7Qvv1wjI
	9u9yU97XCv6vLhaJvq+IUNCo+333cug44Id/UyStbsdjaluPaFhNexTbMJg5Y48N+SK88bFod52o8
	69AOmqNvzERqT6MAOrZsg/E1oSil82WNg3NpFc6OCQbhvu6IYAdpZdH2h0YjJBp61x5QaqUjO1zY3
	dpu6bfnxiLS0DAI9DnBypVn4X0ert8x1HAMYfnREqW8uciOr/a68Z0hV06XxeZig==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wV6Wv-00000000SvT-0C0y;
	Thu, 04 Jun 2026 13:46:33 +0200
Message-ID: <e964f5728bde677dc837f55617a83b63c364cbf3.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 12/31] wifi: mm81x: add mac.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>, Dan Callaghan
	 <dan.callaghan@morsemicro.com>, Arien Judge <arien.judge@morsemicro.com>, 
 Nathan Chancellor
	 <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: ayman.grais@morsemicro.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Date: Thu, 04 Jun 2026 13:46:32 +0200
In-Reply-To: <20260430045615.334669-13-lachlan.hodges@morsemicro.com> (sfid-20260430_065745_504965_FA898F92)
References: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
	 <20260430045615.334669-13-lachlan.hodges@morsemicro.com>
	 (sfid-20260430_065745_504965_FA898F92)
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


> +static void mm81x_mac_ops_flush(struct ieee80211_hw *hw,
> +				struct ieee80211_vif *vif, u32 queues,
> +				bool drop)
> +{
> +	struct mm81x *mors =3D hw->priv;
> +
> +	/* We don't support IEEE80211_HW_QUEUE_CONTROL so flush all queues */
> +	if (drop) {
> +		/*
> +		 * No need to call mm81x_skbq_stop_tx_queues as mac80211
> +		 * has already cancelled each queue prior to calling .flush()
> +		 */
> +		mm81x_skbq_data_traffic_pause(mors);
> +
> +		flush_work(&mors->hif_work);
> +		flush_work(&mors->tx_stale_work);
> +
> +		mm81x_hif_clear_events(mors);
> +		mm81x_hif_flush_tx_data(mors);
> +		mm81x_hif_flush_cmds(mors);
> +
> +		/* Reenable data, not that there will be any */
> +		mm81x_skbq_data_traffic_resume(mors);
> +	}
> +}

Doing nothing in the !drop case seems questionable - mac80211 uses this
sometimes to e.g. make sure a deauth frame really went out before
shutting down the hardware.

> +static void mm81x_mac_ops_sta_rc_update(struct ieee80211_hw *hw,
> +					struct ieee80211_vif *vif,
> +					struct ieee80211_link_sta *link_sta,
> +					u32 changed)
> +{
> +	struct mm81x *mors =3D hw->priv;
> +	struct ieee80211_sta *sta =3D link_sta->sta;
> +	enum ieee80211_sta_state old_state;
> +	enum ieee80211_sta_state new_state;
> +
> +	dev_dbg(mors->dev,
> +		"Rate control config updated (changed %u, peer address %pM)",
> +		changed, sta->addr);
> +
> +	if (!(changed & IEEE80211_RC_BW_CHANGED))
> +		return;
> +
> +	/*
> +	 * Simulate the disconnection and connection to reinitialize the sta
> +	 * in mmrc with new BW
> +	 */
> +	old_state =3D IEEE80211_STA_ASSOC;
> +	new_state =3D IEEE80211_STA_NOTEXIST;

No real objection since it's driver internal, but note that this
transition is normally impossible from mac80211 since it doesn't go
through the intermediate states.

johannes
