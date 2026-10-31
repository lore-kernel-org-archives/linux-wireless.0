Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793443921;
	b=2iUU6r7pC0KnA+JKSKNn08A4ulPMbf1VMsXVQExyFHo4pnyQf6icoXOyNixku20o77Rv
	 qXs7KYYycGk8qlhaKPBFwCYF631s7RFqurzp0ULiupK3IAw1dwiu4tJOBe2o5NKkXXuHT
	 x1CKC1hXd9G/ciJLGIOoy1KtLH/1PLYfwmFomVkhG6aC6qjtXwwntIw539eoiZpt/Alvd
	 TUR3l7MQSUD6vLaDUGJB/efgrEAWS8WAzj4tJxQiP761s1Wep1aIjwF+/5Nh2RCSxlpYV
	 zXXgNQH+O0I4NrQW4IOOtFGuj2gYUOjLwk9sqqjDatsbwOItvbW1WyIMXUU8OLAsCrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793443921;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=d8tkKSZGn/znxC/QQi42R/cKj7t2wqgEIPUX6xpDjQo=;
	b=KDobCU2cJi/mz0p63mocn6zcwQsR4VyNkw0jhwAyGZtYuAmTQ2mswjK1SVMGSTSYiBBi
	 WuMZpGP0U4EE44I4AlTqbmgp2qL23WQvxYe05NnkkDhCckrnZK0FIG1vJEY+OpLZ9T52z
	 MI5aM2tMlWeeE4SSTALewlscOTirh2nRMEYB4AR1Eb3NoW20yOKy0JgK8Jtj0bfywO/Zy
	 E/HYUBV2DlSnz5T+wVZoP/9uHMR6l+uZs+1s5d9ENZbLayxFL/NR9Thls4XxE+MGno+sZ
	 X3y6QZ9h0OjmIEIpd8iQMYoYPDT5fHohkldaVbPUW9Km18P63UJm/bWdkmlyoFaKS7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b="jD/mGiwx";
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE13606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 10:51:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EE13606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=jD/mGiwx
Received: (wp-smtpd smtp.wp.pl 47410 invoked from network); 31 Oct 2026 11:51:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793443917; bh=d8tkKSZGn/znxC/QQi42R/cKj7t2wqgEIPUX6xpDjQo=;
          h=From:To:Cc:Subject;
          b=jD/mGiwxOI8DqJeFEqgvNh2tCdFsbZnKnNpPd+IKNX9PqfPrcmTckwhOeMkroRxvU
           G98qntdUNcJH5qcYPAivRNf8IZss6IKemzhzdMUQfbNpBt4K92STV4ayWSCvrT0p6J
           dr/CRi35zPA6wgWrxSNh09G5d8Ez/io2/fDhFnSSrpLDqIvKCUCHlGrGcksU7qe0q5
           y+cdbC0Nd6oR1QsGmu4+XuXyj4OxWU4vhSbfjB+CRvP7QDf3uzXd8cDhhb8b+PvnTN
           hOdXX3/YhL53iyO38v9e5x2f5453sx0Lv59D2vxo0AHefHMa/3xI/4T6+bi7ZNIGjM
           swvga8wkZEohQ==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 31 Oct 2026 11:51:57 +0100
Date: Sat, 31 Oct 2026 11:51:57 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 1/8] wifi: rt2x00: start the link tuner
 when an interface is added
Message-ID: <20261031105157.GA31143@wp.pl>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
 <20261029134752.1299130-2-hjf3108@gmail.com>
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
In-Reply-To: <20261029134752.1299130-2-hjf3108@gmail.com>
X-WP-MailID: e045aedaf131a3dcfa607252324fa5da
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [0WIB]                               

On Thu, Oct 29, 2026 at 09:47:42PM +0800, Ho Jie Feng wrote:
> rt2x00lib_start() enables the radio before mac80211 adds the first
> interface, so rt2x00link_start_tuner(), called from
> rt2x00lib_enable_radio(), finds no station or AP interface and returns.
> 
> Start the link tuner again when an interface is added.
> 
> Fixes: d96324703ffa ("rt2x00: merge agc and vco works with link tuner")
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> index 3bc0c1c906c91..d9e323ccc6d62 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> @@ -264,6 +264,12 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
>  	 */
>  	rt2x00dev->packet_filter = 0;
>  
> +	/*
> +	 * Start the link tuner again if the radio is enabled before the
> +	 * first interface is added.
> +	 */
> +	rt2x00link_start_tuner(rt2x00dev);
Maybe add (rt2x00dev->intf_ap_count + rt2x00dev->intf_sta_count == 1)
check, to prevent reset of the tuner if already running?
And add corresponding counter part when removing interface.

Regards
Stanislaw

> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(rt2x00mac_add_interface);
> -- 
> 2.53.0
> 
