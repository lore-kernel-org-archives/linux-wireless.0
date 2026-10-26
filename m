Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018618;
	b=gCDagzfRLIimTOgekzrwWaRFsnyFVy268YDwJ2sVUU/TiIkg86nwi3Z9qJkh1Qv51EGe
	 lkCs8fyYv0+MYW5nR3RiHfZKGCUu2x6080Alt2IA/4L03BI0EwHp9rhm7b99yBAwUd8kX
	 lUx3BzHYYNqyBIb+d2wLt4EsWl+Dugq1ODy24npLKgVTJ12Bszi8uHcYpRFLyb60n0d4I
	 g9LOHFI5HYI6kwZEs3eSJjPUTCX9HwCR6MX4t+ALrJm3MzmunQCuRdpw5qmplq4Up0Ry0
	 U83nxbH89t/tpLErcZZJU3yyUoeLT2Gw3d+32JRK6btJnZinoUONTwst32oefzg+e8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018618;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=x98ue6edYcJSRLvXIUfs73a6xLz9MbtvdfK+VXF01fw=;
	b=P8tf+NSt2pX4jXruWclmcRqGjhcEG3RETfzCnz0mibwqx3GvcPnviENRDVaXOdnjN6au
	 5PgZ1JgbDDOoVlQ45jzDmlOOZD46LPe+8E7VKwU3arEq6nDD8Ki275e4HAMtjwNUdJsF4
	 iAqHC6+KCJtiFOo+0VV40hSXFKltJjogqCPsSYmWNlHexAe+l8SH4uJy3qW8Y6NSfgRsf
	 iULVYNlath/3W0dw9tH5dFzMMIPM43iSUg3QwRfRJsxJyTGcQkRk7++BSswRw3w9VVSaP
	 4Npd7RObn+2AGzpTg1HR3YIjhm+V3qzkmZlEMD+SDFs2mjamlyEDcuXx+WlpUa/R8Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NazLLNnL;
	arc=none smtp.remote-ip=95.215.58.119
Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63819606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 12:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63819606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NazLLNnL
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nzH/f4GJg9wr8FRWhRIYnnTP3YVJewQQsdvAvpslUiM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793018614; v=1; x=1793623414;
 b=NazLLNnLwbBMGC2WbW/8HmE4Wn+9br1Pdx2NkiYKwQg418koQP4WHpRgWXgflUXbJLLZTg4l
 6mjNYsx6mdupmGj7lq3p1/L6uMtOg6Q32T6yi3EBUIKHcBmKE9pnZMJKzvwX3mKDw2TqF9j5UGl
 Kd528nDgqAoD51zxcN6FdhNQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ecc5c76a2f6b2875;
	Mon, 26 Oct 2026 12:43:34 +0000
X-Mizu-Trace-ID: ecc5c76a2f6b2875
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 26 Oct 2026 12:43:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <c8bc5affa75d7519b424ea98c07c1d6b65942347@linux.dev>
TLS-Required: No
Subject: Re: [PATCH wireless] wifi: mac80211: abort chanswitch when leaving
 an IBSS
To: "Mehmet Fide" <mehmet.fide@gmail.com>, "Johannes Berg"
 <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com
In-Reply-To: <20261025193615.1123718-1-mehmet.fide@gmail.com>
References: <20261025193615.1123718-1-mehmet.fide@gmail.com>

Hi Mehmet,

Thanks for picking this up. One comment below.

October 25, 2026 at 8:36 PM, "Mehmet Fide" <mehmet.fide@gmail.com> wrote:

> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index d74b66426349..b9ab4ceb0332 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -669,6 +669,10 @@ static void ieee80211_ibss_disconnect(struct ieee8=
0211_sub_if_data *sdata)
>       ifibss->state =3D IEEE80211_IBSS_MLME_SEARCH;
>
>       netif_carrier_off(sdata->dev);
> +
> +     sdata->vif.bss_conf.csa_active =3D false;
> +     ieee80211_vif_unblock_queues_csa(sdata);
> +

As far as I can see, the driver never finds out that the switch was
dropped here. ath9k_htc only clears priv->csa_vif once the countdown
completes with csa_active still set, or when the interface goes away.

So if I read it right, after leaving mid countdown and joining again, the
next switch with a countdown now gets past mac80211 and runs into this in
ath9k_htc_channel_switch_beacon():

        if (WARN_ON(priv->csa_vif))
                return;

Before this patch mac80211 stopped it earlier, so this couldn't happen in
IBSS. AP mode seems to have the same problem already after
ieee80211_stop_ap(), so I think it is better fixed in ath9k_htc, maybe by
dropping csa_vif when beaconing stops.

Since you have worked on ath9k already, would you be willing to send a
fix for that too?

Best regards,
Luka Gejak
