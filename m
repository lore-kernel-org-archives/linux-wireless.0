Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793864489;
	b=tp6umpo3t/Qm/xlh1XmYljiYKChBnrYU7yNvbgJ+TZ6vNayxs3ckd399HkQKBexWFjbq
	 Q4SowNexlBgR1ps+zieVzCjzbUahs6yPNy1snb4TTLtSiEmmX5w8GkR8ZM/XCOE3PCjXM
	 l/ZQrcEC8rzan0sv8NRgh+mb5WGr5/vTmUAzxhAlCrlDvjypFtwKGWO9XfSJqzGWE8EDJ
	 nPeSAdyZb8gBYAO0FO/DXM1BIHSaZodMgIsEnTEILIxgsXB9MhBM2w1g90U8nkPA8g7s/
	 fAKK4mWNBaJ/7Y698+E4V/7kgwYHzkcX/YrMrg7jCGxgAE7e+QafbB0XXpcETg5aOAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793864489;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=btEeF2y4eomZ6xL6AOjDC/Nw7mOpuUZylJZu2L7L5K8=;
	b=hdMXhP0QNE9x1SFHx3h3a64V1y+wLERn9a4fCzjCEmOQ1JWgf1WLzcxc07rtlb2+hPx7
	 xXmWVY4RAERUUDH7QZ11AbLyfqBsV/TVWWIx1g+9xqZvJmUzpW1HsRLuiDag5fgMDdqH2
	 afHrnUcZdDm+PDDsRO+MqfwsQdNkhl+ZgKdAymu1lTSAIy4L4SDfzPhVFIAopI/s1VMsf
	 n0aQVkA6KtnXGWfykTqlUniDkWUZPvhT1WsZu8nn3oqW9GDuplIw2xEbAi8WXZGDXcehL
	 CVtEgqCIJKL4QkzRkRWzMG/f4ohajSojD6GALNkqsYyGm6oUA5StPiW9eUFTUxEK4bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=ERAXuMWX;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD2F606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:41:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AD2F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=ERAXuMWX
Received: (wp-smtpd smtp.wp.pl 2047 invoked from network); 5 Nov 2026 08:41:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793864478; bh=btEeF2y4eomZ6xL6AOjDC/Nw7mOpuUZylJZu2L7L5K8=;
          h=From:To:Cc:Subject;
          b=ERAXuMWX0c9PyGrZIPXFbQzUjLpbRrnKfgQ0cndq+gaudjwrMk6FHPrBmZ+uwFuKO
           2D97Bg20L9KA92z8t8v0gpPL7WgN19xy+QYd7sfsVwHmmuA18mFfllRSqLS1EHkLFQ
           ZgtZIrARM9Fq0cITtpZLsQpOFIPVoo37y5qYoxDmwgwqmBwZnc1FbNrINlBfEAM6K7
           JacHodT2WbHivbbD8oSQcmyK8s0BeR6+dSVk32kcFh2x1Z9EU5v6hlpPQhYCeBgJyD
           YHL4p9tj1E7LJlxyHOZTe6x+IOAWs+tDaYPaqzVOgz8/8yfKb8/T32/Z+7b3kvWz3h
           01pogl5L3m3ZA==
Received: from localhost (77-236-11-168.static.play.pl [77.236.11.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 5 Nov 2026 08:41:18 +0100
Date: Thu, 5 Nov 2026 08:41:17 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 1/7] wifi: rt2x00: start the link tuner
 when an interface is added
Message-ID: <20261105074117.GA64923@wp.pl>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
 <20261031165117.2868671-2-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031165117.2868671-2-hjf3108@gmail.com>
X-WP-MailID: e91b5766c371303b359a778914f4b52c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [gUM0]                               

On Sun, Nov 01, 2026 at 12:51:08AM +0800, Ho Jie Feng wrote:
> rt2x00lib_start() enables the radio before mac80211 adds the first
> interface, so rt2x00link_start_tuner(), called from
> rt2x00lib_enable_radio(), finds no station or AP interface and returns.
> 
> Start the link tuner again when the first interface is added, and stop
> it when the last interface is removed.
> 
> Fixes: d96324703ffa ("rt2x00: merge agc and vco works with link tuner")
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> index 3bc0c1c906c91..86547ce81cd2e 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> @@ -264,6 +264,13 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
>  	 */
>  	rt2x00dev->packet_filter = 0;
>  
> +	/*
> +	 * Start the link tuner again if the radio is enabled before the
> +	 * first interface is added.
> +	 */
> +	if (rt2x00dev->intf_ap_count + rt2x00dev->intf_sta_count == 1)
> +		rt2x00link_start_tuner(rt2x00dev);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(rt2x00mac_add_interface);
> @@ -289,6 +296,12 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
>  	else
>  		rt2x00dev->intf_sta_count--;
>  
> +	/*
> +	 * Stop the link tuner when the last interface is removed.
> +	 */
> +	if (!rt2x00dev->intf_ap_count && !rt2x00dev->intf_sta_count)
> +		rt2x00link_stop_tuner(rt2x00dev);
> +
>  	/*
>  	 * Release beacon entry so it is available for
>  	 * new interfaces again.
> -- 
> 2.53.0
> 
