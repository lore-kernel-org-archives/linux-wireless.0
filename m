Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865273;
	b=P1CCIdRcmnjzSBoN7UAjP0zD5oFpCCI+xiNG/iXYJOkpT3Uv4gYLKRbqnIr+bQ5v+Yym
	 i2/ERlzs6Lm4N6AdtzX1iSPMU9pubrjxSQyvzdrmRzhkny7yqfgRx9eXFPE9CxZi6t9CI
	 qLCIgojQK2Z2Q/3ciTaY1ZJlbhv85ePXWwier+bXuq6JvQqmOkLJgV01CWZQ2QyB5H7tq
	 tgAUIqi3mICZvVvUA8PmByZOqb8xkXZugdGYmvn2uljQKQCOOUmPYqSsFkecIqHlN0Lap
	 +kiZP48aEZMvMUzjOlqprPHmmu5hL/OdHy+5fRE2vUC/A0ytOat913nEkFhwbQsTlGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865273;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=SqQug2NhMotb+HO6CFPwXKXquImlh73xrR04x+Pdvjk=;
	b=kl/tCJfsz4JIA3oR7BS+p5rgCRjlecFwE+mdgTILnoG4OSfil+IFfJmM9r4DKYpwodLz
	 Fw0kTmeAfISMJ1g3fQ+durf3eQ+YF6LuhGAKe901ASvIpXIHvrYnrsvsOtYdulKk9PGrh
	 nz3nYPr6xBxH4p2uuATJfH+/t6+vVT45WE2Uc58SvsYZF4kvmFjdghQCQTVtNInG+quoU
	 ZrEnHITRXPjCFEq6Jd5uo2xLQNGywTSBoetFZMDTWHyaD0Gb+ygxURpKq8zpEpfpndqTu
	 25cpahSjIaGCaThDZsoRItnszrwyR2/uGSYEg4NwD+vEln2YdlxWfKhrpaZdq4Q20QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=DUcXUEGd;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D7F606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:54:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06D7F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=DUcXUEGd
Received: (wp-smtpd smtp.wp.pl 37987 invoked from network); 5 Nov 2026 08:54:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793865269; bh=SqQug2NhMotb+HO6CFPwXKXquImlh73xrR04x+Pdvjk=;
          h=From:To:Cc:Subject;
          b=DUcXUEGddNeoBkHmAlc7eN8d2RCAjFPVGCsRZHmdsWx9xZ7mszjoINqmdSNmcXpaQ
           wCDdXNEwQx3plc3xBc0ppiEP9aLWlQpO8LEIPAl27lNiKnm4kHMSHUCYpt0cD9a6Yo
           hTDJUTr99YAlKOrPJxfAQJSY1MaSZPTfURL20e7TjgK8JRIzsuTYycijSlBS7FQ2Ql
           IUejCoQdrTGqRzq2whYzBHzzL1oGenf7hGbms9JCnQ/V7sLQQ32/B1XfiLWdibDaP2
           X+nIqK/08iNmyGc3JHTrWaJ6U3r+Wy5J67NxGyc60mteVEy/Jar6eCAJ/ejoI3pktk
           4wW3Q4/+0/zSw==
Received: from localhost (77-236-11-168.static.play.pl [77.236.11.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 5 Nov 2026 08:54:29 +0100
Date: Thu, 5 Nov 2026 08:54:29 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 4/7] wifi: rt2800: don't report an
 A-MPDU length to minstrel_ht
Message-ID: <20261105075429.GD64923@wp.pl>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
 <20261031165117.2868671-5-hjf3108@gmail.com>
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
In-Reply-To: <20261031165117.2868671-5-hjf3108@gmail.com>
X-WP-MailID: 2e09c25532bd810ec9fdade3f307d142
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [seOk]                               

On Sun, Nov 01, 2026 at 12:51:11AM +0800, Ho Jie Feng wrote:
> Set IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN, which was added for drivers
> that can't report the proper AMPDU length and record this workaround
> below the TODO comment.
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 1 +
>  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 5e1ee016624c6..1301bc24d9413 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -11860,6 +11860,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
> +	ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
>  
>  	/*
>  	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index db33c1215de97..350e6bf24f7aa 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -374,6 +374,8 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
>  	 * by the hw we could provide the real ampdu_len to mac80211
>  	 * which would allow the rc algorithm to better decide on
>  	 * which rates are suitable.
> +	 *
> +	 * Currently, we work around this by setting TX_STATUS_NO_AMPDU_LEN.
>  	 */
>  	if (test_bit(TXDONE_AMPDU, &txdesc->flags) ||
>  	    tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
> -- 
> 2.53.0
> 
