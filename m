Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.158.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952538;
	b=5GkLf6M5yGF15WdYJzCHklnhJcKizeqdlO4brgQw7sBXC1YJXEElsN6ijlJzVtqXCRu7
	 DR3ov2kIqWr8B/pIrpXt4elmGSWef5oll19u/yFE7HeysQMYqLUU/san6RW6Ka4YHbw2Q
	 GPQuAFRGqonu5i7zX5kmtx4OQNHDshqksW9B9BXbG5OXsKlyolLHiKruq43l1xvYbBGJh
	 OMHl47Sf3VatVhYtDV30z6QPHGjpGIs3QfmJ0xtqMWFEMjsaVkRbIjiuISZysFgayuCOW
	 gYf8ULrN2P0grJIb7rsK8B8VX68dtLmNsEZ9aV/h0Prme1+xE8P3zCftpxQDO6clDHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952538;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=lRw4DqkyItAjVq3c2gbtPYug0ZPt4KeRTu5q0QkKxig=;
	b=msrTzkF3zYIfqhT/tuL7pFIdj2gp5dWRt8z3uStLGC1ErrkBvliF5ncZ2e1DX7w6ZA+u
	 fA0LN73Dp2gpgKBMbXQ4zkXjoq0rm4lKJAe/YeQIC2m9mYsqE7xJsBpMWbKc6m5R/Gd33
	 ber06Bj9vxP1UBb9PBrTvRcv3j5KiiMuN7i4keqUUi0rmWFHIxeMKCOB776cys2YepmVg
	 HvAMmnoP/te1m+7M4ahBfY5uoLrN711iG7nhl4kmv2Zb8FleDQ0mEnpD39orrlMindh7C
	 dhC3DCPGJ7yuvW8MwCJixIuvmkFuMCz9RLLvGcOhjyKzXdMikmu9Byn590ejUPzUmCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=jLF40z00;
	arc=none smtp.remote-ip=62.149.158.117
Received: from smtpcmd03117.aruba.it (smtpcmd03117.aruba.it [62.149.158.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EF3606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:08:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39EF3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=jLF40z00
Received: from localhost ([87.16.49.252])
	by Aruba SMTP with ESMTPSA
	id PF0IxxCty07TYPF0IxOlG4; Fri, 06 Nov 2026 09:08:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793952535; bh=qY4qgOMwJNb8zSvF+KwSDbCfjHytINrJK2G1w8yYlDc=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=jLF40z00U1oCwfXffwUnIBfJHAlEMpRTzeXkNfZkn0pbNTZ7OBHm0qA//ZugijH9c
	 lBMBGPTGL+1ekcYvfnkJ30eUCiyUwFar6H60IHN5FwJmD1J08RBCmrq/bDCkxeQgJh
	 H9qxyozY1vmWJtCK2L6cCGKq3zIl0+0SipudY8JFB2xwsAAoQcivQq+eOvBZMXq1DK
	 fNFEee+b3lH9vZGpPMo5GMy42VGJ7Qo+5awePFTXplQIf9lnnfNO9yWfwf6Iy4lD9k
	 xuQiCmhbYf12vjFNEp8PfN9n/XpAktmmBcgT6/DLU51DdLsL7FsKpEc4N6lnQ7bqFo
	 kQa2sU610Ii2Q==
Date: Fri, 6 Nov 2026 09:08:46 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Luca Casati <luk00casati@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
 arend.vanspriel@broadcom.com, b43-dev@lists.infradead.org
Subject: Re: [PATCH wireless-next 3/5] b43: N-PHY: fix rev3+ RSSI
 calibration
Message-ID: <20261106090846.00007154@mythread.it>
In-Reply-To: <20261026181543.77763-4-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
	<20261026181543.77763-4-luk00casati@gmail.com>
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfLu8d2/rk62+pg5rMBbcbSvrzNMBCizzqOqelBCDYDi1saZItt1AEUT9lbAIITszMfDBKW6G+Dkb9D4j5YJmTajWMIY0RTEeRpS4Qouxufc5vIYL5VJm
 W+7/l8Z08O5mIDOrd36U8ljJP4i6YbPdZ3jhH3Sw2tTfND4pNElQRVstcwhUOAYlD3kSsF2R/ZQR0PSm81ZyyJ8Oc25WOSJG+eZr6g5dpIuXCxRYc5cgAxau
 T8YYG8FUE8n0NJmB7jQljkzQnxU2Hk4hXTmjaPttv8PWzVLniFHe/0qgaKCgCa3iQZNsjtCfgTBFg2SOQDWQv4zCyNW0KgixnWFABcvLaLWcbaRGHxV4jS+1
 6+wJmJpk

Il giorno Mon, 26 Oct 2026 19:15:41 +0100
Luca Casati <luk00casati@gmail.com> ha scritto:

> Three bugs in b43_nphy_rev3_rssi_cal():
> 
> - On rev7+ the selected VCM was written using the loop counter (8
> after the search loop) instead of vcm_final; the 3-bit field turned
> that into VCM 0 on every rev7+ PHY.
> - The distance used I*I + Q*I instead of I*I + Q*Q (brcmsmac
>   wlc_phy_rssi_cal_nphy_rev3()).
> - Negative W1/W2 offsets were rounded as -(abs(x + 4) / 8) instead of
>   -((abs(x) + 4) / 8).
> 
> Found and fixed with the help of an AI coding assistant (Claude Opus
> 5.5), by comparing mmiotraces of b43 and wl on the same card.
> 
> Signed-off-by: Luca Casati <luk00casati@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c
> b/drivers/net/wireless/broadcom/b43/phy_n.c index
> cabf61870..44769dbb7 100644 ---
> a/drivers/net/wireless/broadcom/b43/phy_n.c +++
> b/drivers/net/wireless/broadcom/b43/phy_n.c @@ -2167,7 +2167,7 @@
> static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev) continue;
>  			for (vcm = 0; vcm < 8; vcm++) {
>  				currd = results[vcm][i] *
> results[vcm][i] +
> -					results[vcm][i + 1] *
> results[vcm][i];
> +					results[vcm][i + 1] *
> results[vcm][i + 1]; if (currd < mind) {
>  					mind = currd;
>  					minvcm = vcm;
> @@ -2179,12 +2179,16 @@ static void b43_nphy_rev3_rssi_cal(struct
> b43_wldev *dev) results_min[i] = minpoll;
>  		}
>  
> -		/* Select the best VCM */
> +		/*
> +		 * Select the best VCM. (This used to write the loop
> counter,
> +		 * 8, which the 3-bit field turned into VCM 0 on
> every rev7+
> +		 * PHY.)
> +		 */
>  		if (dev->phy.rev >= 7)
>  			b43_radio_maskset(dev,
>  					  core ?
> R2057_NB_MASTER_CORE1 : R2057_NB_MASTER_CORE0,
> -					  ~R2057_VCM_MASK, vcm);
> +					  ~R2057_VCM_MASK,
> vcm_final); else
>  			b43_radio_maskset(dev, r |
> B2056_RX_RSSI_MISC, 0xE3, vcm_final << 2);
> @@ -2219,7 +2223,7 @@ static void b43_nphy_rev3_rssi_cal(struct
> b43_wldev *dev) if (j / 2 == core) {
>  					offset[j] = 232 -
> poll_results[j]; if (offset[j] < 0)
> -						offset[j] =
> -(abs(offset[j] + 4) / 8);
> +						offset[j] =
> -((abs(offset[j]) + 4) / 8); else
>  						offset[j] =
> (offset[j] + 4) / 8; b43_nphy_scale_offset_rssi(dev, 0,

Drop comments talking about what used to be.

At this point i suggest you the following indication to claude (taken
from mine):

"When you edit files inside a git repository, never add comments stating
what the code was doing or why you changed it, as git can already do
that without polluting the code. Those comments will usually rot at the
next change. Never add trivial comments, they have no use. If you see
comments like those, delete them. If I ever see you leaving N blocks of
comment back to back in my code, for any amount of N > 1, I'll come
after you."

It stops claude from polluting the code, with the added benefit of
reducing its own confusion when it rereads the code and finds its own
rotten and trivial comments.

Alessio
