Received: from smtpcmd10101.aruba.it (smtpcmd10101.aruba.it [62.149.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B82541A561
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792095266; cv=none; b=Qh8Py4Gj8UzuyKpFgmexOC45O6FULxtu0PT86rJzbw+pwwafXQSipCY1qy0ASzc1CYAIHmm8M3hvKn78qSmPH/Qzai7JaFl8Wf9TcgkKY9r3DQSGObNp0h8ExKkBS2LCM3mN3AHH8Lep2K8AU4pmyZJe0azhecrJIdsiKBVn4Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792095266; c=relaxed/simple;
	bh=HojjwIF6mPv2+Mx1dmhXz+yurqqBob/ezcwRgtSOF3s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXhl983pBNIcnWzRHpC25K0urOK6GmsHTKKhNQ/Rl1aEIwwEWTc0ISBvHBdZWNvpQ3oza5tCpspYs6u41WjRRGR2dxeQn1SormNsIOtcVF5uCO8gJc4xTfiSTGOvISRp/vhBQW6bjTIdirNIscwwN8kc0DfyaSvVNnjQLcqKXe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=eQW6vmU7; arc=none smtp.client-ip=62.149.156.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="eQW6vmU7"
Received: from localhost ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id HRnExVnAcN2P6HRnExyeTN; Thu, 15 Oct 2026 22:11:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792095072; bh=HojjwIF6mPv2+Mx1dmhXz+yurqqBob/ezcwRgtSOF3s=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=eQW6vmU7dvF8CF9X1mGCNeUuf2SoUD9JjczeX97n+Z0ILVk/AyxBiTuVPBpRRXgRG
	 RfQV0B9iHf0Af0l5ls3cC22nQVkqf6xT7uuxBAKIhkm4DoldgE0ihsFl2kwhYmeKCr
	 3ODJytgWfOmXm0klejkOzQnzJrT2r+pc79ClKhnDu9vTKAr1rFDgqHAQBs05HRrI1/
	 sdvtwpx0WUWOF45/NAtP7eg7ZUChs14//8sldIVGSGhbOdbmzo2Llv7QbmtAgJ62h8
	 Sp+JXV5CgTVhKyc+JZPSoEty98LoT0e990hntUY4VJ4vzLnfUvOaHLcvXIBWuOaiGE
	 brv3OVVJChOhQ==
Date: Thu, 15 Oct 2026 22:11:10 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-kernel@vger.kernel.org, "open list:B43 WIRELESS DRIVER"
 <linux-wireless@vger.kernel.org>, "John W. Linville"
 <linville@tuxdriver.com>, "open list:B43 WIRELESS DRIVER"
 <b43-dev@lists.infradead.org>
Subject: Re: [PATCH wireless] wifi: b43: back off the N-PHY TX power per
 rate
Message-ID: <20261015221110.000078b3@mythread.it>
In-Reply-To: <20261015175928.3558057-1-rosenp@gmail.com>
References: <20261015175928.3558057-1-rosenp@gmail.com>
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfHhZJYd9femzhxibRcD3AOuOak6Owxp+zp/0xkbtqhzp/M+GSksE4KDsypAlycTFiuP9M4sIAd16eUlihXrmVzDkwfNIqEevZptTiwsHozUFkj4cBDLs
 p6eKsZ65o+QdyKZ8RIWD1gIpgBpTBW2Li5Qx9pH1nI0I04YHIXt7Jart7TpnAhxedRaxdAy8R6yW0dZMAsZUJHl0p/Nixq6GQxrGYN4wWF2nBJdN7LyyrG3N
 bKWw/SRT+y1sCC0hXpHnQUrPtpbdqB0Fd32ohnEeh3Z8bKsjx8Z7hB0ioyzmnzTGhSrGVT/sNBYwAnid61ZUDAdLHwoFRs+UECnqadp2EvZnUpWhBJD4pltU
 ejyGCyob

Il giorno Thu, 15 Oct 2026 10:59:28 -0700
Rosen Penev <rosenp@gmail.com> ha scritto:

> On N-PHY rev 3+ the hardware TX power control aims at the highest
> per-rate target, and an adjusted power table backs each rate group off
> from it. b43 fills that table from nphy->tx_power_offset[], but never
> sets the offsets, so they stay zero and every rate is sent at the
> power allowed for CCK.
> 
> The SPROM power offsets exist to avoid this: on boards with external
> PAs, OFDM and MCS rates have to be sent a few dB lower than CCK to
> keep the PA linear. Sent at full power, 16-QAM and 64-QAM frames are
> too distorted to decode. On an ASUS RT-N16 (BCM4718, N-PHY rev 5,
> radio 2056, ofdm2gpo 0x66666666) the router could only send at 6-18
> Mbit/s and MCS 0-2, even at -50 dBm, and 24 Mbit/s and up or MCS 3 and
> up delivered nothing.
> 
> Set the offsets from the per-rate targets b43 already computes from
> the SPROM, as brcmsmac does, before the table is built.
> 
> With this, the RT-N16 sends at 54 Mbit/s, and at MCS 7 with HT
> enabled, and TCP from the router to a client goes from 9 to 17-18
> Mbit/s.
> 
> Fixes: 8615eb2870f1 ("b43: N-PHY: support setting custom TX power")
> Assisted-by: LLM
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c
> b/drivers/net/wireless/broadcom/b43/phy_n.c index
> 22359bd9db47..c9b2b7496983 100644 ---
> a/drivers/net/wireless/broadcom/b43/phy_n.c +++
> b/drivers/net/wireless/broadcom/b43/phy_n.c @@ -5834,6 +5834,7 @@
> static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct
> b43_wldev *dev, struct ieee80211_channel *channel =
> dev->wl->hw->conf.chandef.chan; struct b43_ppr *ppr =
> &nphy->tx_pwr_max_ppr; u8 max; /* qdBm */
> +	int i;
>  
>  	if (nphy->tx_pwr_last_recalc_freq == channel->center_freq &&
>  	    nphy->tx_pwr_last_recalc_limit == phy->desired_txpower)
> @@ -5868,6 +5869,16 @@ static enum b43_txpwr_result
> b43_nphy_op_recalc_txpower(struct b43_wldev *dev, /* Make sure we
> didn't go too low */ b43_ppr_apply_min(dev, ppr, INT_TO_Q52(8));
>  
> +	/*
> +	 * The hardware power control aims at the highest per-rate
> target.
> +	 * The adjusted power table backs other rates off from it,
> so that
> +	 * e.g. 64-QAM isn't sent at the power allowed for CCK.
> +	 */
> +	max = b43_ppr_get_max(dev, ppr);
> +	memset(nphy->tx_power_offset, 0,
> sizeof(nphy->tx_power_offset));
> +	for (i = 0; i < B43_PPR_RATES_NUM; i++)
> +		nphy->tx_power_offset[i] = max - ppr->__all_rates[i];
> +
>  	/* Apply */
>  	b43_mac_suspend(dev);
>  	b43_nphy_tx_power_ctl_setup(dev);

I'm not the maintainer, and i also have the same exact patch in my repo 
https://github.com/aleferri/b43-6362-wip/tree/main/patches/mainline, so 
i'm all for it, but isn't the ppr currently populated with 2Ghz sprom
params for all bands?

Alessio
