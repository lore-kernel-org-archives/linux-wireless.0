Received: from mail-pz2-f36.google.com (mail-pz2-f36.google.com [74.125.228.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477E74D5966
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 17:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791222412; cv=none; b=F108c0WpahdSSL5xvWxeB8kYLaXnrBEGhIpjxMDV0AdmfO51Sq9pnTpc3g4xeXOm5NfWrGYfm2PChwHLE9x/8SyWrImzFF4ErqVRTbjM0natEffpaTbnvnset/osT/6PjUF4ZrWX/9EyoU1fw5pPBRy24nlFz1Y1/OEI07LBUJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791222412; c=relaxed/simple;
	bh=5cj+0pZvvYEP8223id1jPXjYzN5HTrhGP38RDvoBEX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edPsy7g8qKfm0TpVRRnOectHoSFEeM4rVbwTNPBWPCmY1WhkDAEbNP7CQIxwU/dqD1R6iN4ypmafot2lUBcXeGK8aZQJpam4v+jhBFlahesOmUqbSyP5ND9XQ1f6umqCMON15fxDONJIX0HqkeQg9mkRcHRns7WQiDBTAX23M7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DruPxoNq; arc=none smtp.client-ip=74.125.228.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DruPxoNq"
Received: by mail-pz2-f36.google.com with SMTP id d2e1a72fcca58-88a9f57bd42so1017666b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 10:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791222410; x=1791827210; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V5ykIF8N5/re7TcPUO71wZKt5W6G9KvCjhpDqyGS/p0=;
        b=DruPxoNqse8ghhho8NRwuZCReWRaLNO6TVCIuEO9se9Z2gsUeJD5ZLlE11dOTZeAmO
         xdj1scAGouJWq2zAkjVpxHga4mqj3tzknlEXtJwpx1JzvB1Vmyg8Ae3LRSgs/p2R661H
         dAusfQS3U2J4v5vtoaaIkoOWw2nL1spVFo5dI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791222410; x=1791827210;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V5ykIF8N5/re7TcPUO71wZKt5W6G9KvCjhpDqyGS/p0=;
        b=yEcbOd+CMCCi62lWlndOZE0lA4eMHNRTmoxNyT2MI5qUgoQRbiACM6Ltg/m1zWAqfx
         bNTMUl8EMXaYY/+u0Hz+Hv3Tzd4U3QaIwlY49vmTwuRAgWsYoqcI5q4taIHpc+FsFBfQ
         QeI/o7CEYEVj76gBEUgicXR2/AO1BePpETY2Kq/yT1YGaPNkNfHolXRudO1LcMiyPoB8
         v5G7U3hXByt6YqblNdgkSUUfE3pkvC1WmSD6reb73AdsGFw6f6i2+wKLD6tPomfmwi8I
         xrf+Fep+6UGDasanf6c5KR7OCqqy11HO+FguVz12+fGpzQBafz5fVQ6m84/yEEfNyV3L
         9qdQ==
X-Gm-Message-State: AFuF++nvPjtdJqJI65kzbimMaOulxtCG+mwyzxi7T6xW2ZFCJ9ICu4QK
	3r9cfDFjf8Kkuxqx0SSIOQ1dyr6MgB9HdCjV01MI1RCNtzlQNKRbAyvLYxxTeGqGww==
X-Gm-Gg: AYBFou3koydEh0aDUj0pEqJvVcC1NIkjBb+K4R3SJbNUklcV0ji+aodcYebQtC/G/S1
	psBk42IcldrItRgpa8wbD/Pg1EK2D9P1vOAz9sgIZp22pcKhYG+RGyKuBqzQ1KcDL22BXBKqk37
	8uNFiuE1i0NLSczhG5GCHNaqHt+idF1VfcJNf80noawOY/gTb+5OJSiuzU6pWK9PcVB/g9wh3Q6
	IcjNii7TbORtTu6v1gsdkxDtCRuSl8wUEdJz0MQzI9ZqTMZrWpkYxs0eYMgIGWgqZaFVezfW2Eh
	Zc5Dqlpxnudn4KwKZacKS6h5RpK5XS9I8OADanvpRqqaEH5rO9U5mm8CxpwQmc/fopMQiGj175S
	W+i4u0Fg7Y9yIb6ghCcbFUScY1N4XMjJfiDrL9fa9XPGVc7zCwhXylZ0GSWdoiN7maSDmdZWTl4
	ut9b7KzWc9bEMd0BhzC4q95l9SJh6haWlVdOQEVt+SsX93xGyh7p7n9j8/mVvheAp0AYgSSJmXG
	y3UV2cG8wlraqwYk2a4xpdZjMStxxuuy5+h
X-Received: by 2002:a05:6a00:3403:b0:881:1fb6:a81 with SMTP id d2e1a72fcca58-88af2689f85mr10997444b3a.3.1791222410606;
        Mon, 05 Oct 2026 10:46:50 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:3452:be62:94e:a46d])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-88b0c3a4862sm3842600b3a.32.2026.10.05.10.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 10:46:49 -0700 (PDT)
Date: Mon, 5 Oct 2026 10:46:48 -0700
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
	Francesco Dolcini <francesco@dolcini.it>
Subject: Re: [PATCH wireless-next v2 09/18] wifi: cfg80211: document wiphy
 mutex for radar/CAC events
Message-ID: <asPiiI6-JpMd3vKr@google.com>
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
 <20261005120526.fe5960ae72ab.I57002ac3e57d2ac4613eb0cb0e6d17bedccf0cbd@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005120526.fe5960ae72ab.I57002ac3e57d2ac4613eb0cb0e6d17bedccf0cbd@changeid>

On Mon, Oct 05, 2026 at 12:03:36PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The DFS state of channels and the CAC state of the wdev is
> protected by the wiphy mutex, so the radar and CAC events
> must be reported by drivers with the wiphy mutex held. In
> mac80211 we do this, but some drivers don't yet:
>  - mwifiex/nxpwifi have an event handling worker,

FWIW, one of the two contexts that call cfg80211_cac_event() in mwifiex
does *not* (by inspection) seem to hold this. Is this something you'd
prefer individual driver users/maintainers resolve?

>  - qtnfmac also does it from event processing, and
>  - mt7915 and mt7996 don't acquire a mutex for background
>    radar events.
> 
> Document the requirement.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/cfg80211.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9cb536fc8cb8..eb376a54a07f 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -9794,6 +9794,7 @@ void cfg80211_cqm_beacon_loss_notify(struct net_device *dev, gfp_t gfp);
>   * @gfp: context flags
>   *
>   * This function is called when a radar is detected on the current chanenl.
> + * Must be called with the wiphy mutex held.
>   */
>  void __cfg80211_radar_event(struct wiphy *wiphy,
>  			    struct cfg80211_chan_def *chandef,
> @@ -9839,7 +9840,7 @@ void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
>   *
>   * This function is called when a Channel availability check (CAC) is finished
>   * or aborted. This must be called to notify the completion of a CAC process,
> - * also by full-MAC drivers.
> + * also by full-MAC drivers. Must be called with the wiphy mutex held.
>   */
>  void cfg80211_cac_event(struct net_device *netdev,
>  			const struct cfg80211_chan_def *chandef,

Should we add an assert to this API?

	lockdep_assert_wiphy(wiphy);

> -- 
> 2.55.0
> 
> 
