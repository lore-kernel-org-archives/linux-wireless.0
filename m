Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866809;
	b=IrLq38T/7N7M0OivZb/Mr6TxhHJENTWFKDt+LYZI2D6iarPHkWnAYjlHtFzOSfjnEDqU
	 c6sz63WgGf5AGGXaoF3PLY1jVvcyLqA9NW+Hpj7Zzuz3KhYXWiBsCeSfeJzXgv0RwIxY7
	 xrJRh4COLgQR1eQVK8G7WkAnBEeD1N9HwfVpJUF3d/szdxhLsn9Aj/UbSCrMy9Gpu5aSc
	 FJOEKQuRqpuKYZR/T/XrJaUpov1JWOMJMyRvMza6nffPaTXEDuzaF4c4AtYlyVWK1NnE2
	 ErzXyMneLG7rkEg9CUqx9mcMSDnW5DxIrFbRaGlaZGhl3cMzh8sBwfJwtheaYMb7Ijw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866809;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=l2JVBcPTCiTfYHlZ3fQ99n2ZH8W2gtmOLFdO5al9ZjM=;
	b=TolFzesUJrEB+BpZjpnrCtGxcnOBSe1t6D/pm9KLdL+BAezpk6MuUlxaKRUiS5xlNJax
	 haNGt2i8WZwQSQiYhXRbUOTpw9gMTcaH6on/QPAjhOvBsSwVM3HPykdLHfOfIXbnZ7faC
	 ZdF1sOsUqJwxmy2sJZyV2NX2LJ+J1j8PHtf6z+v/YwwT72Z7NiI4IhaFamvsvIw2/Y6Dw
	 NfNldWW1w6ktPf/xqHy+GiRegjz40LDyoSuHPlEreDvWBq4o4fJTYxymQyB+dju+NZr16
	 2WawMNhp4XMNMaVn/oaSK8md/7hFosFK0sNAnSAT4CLZqM8Kd80TPwOySuWZ+9S8rYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b="QVf/bxyU";
	arc=none smtp.remote-ip=212.77.101.9
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D9D606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 08:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48D9D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=QVf/bxyU
Received: (wp-smtpd smtp.wp.pl 19237 invoked from network); 5 Nov 2026 09:20:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793866805; bh=l2JVBcPTCiTfYHlZ3fQ99n2ZH8W2gtmOLFdO5al9ZjM=;
          h=From:To:Cc:Subject;
          b=QVf/bxyUopt+QSLQ5F7VvTWKeK0XYvyiR9x2YiFms/xQZc5nZIkIgpvdqwUkUlkYI
           +FfpIVpntK7Tff2wiR+M7wUMan1mCMo2LO292VDy7ccvoGLJOR9jheOv5EMXb/lffI
           gb2C5MF2igBVerw0cSOVZQPELmmnuN1pei+52IVr4y51OOFeVCEA39FiPGEExzT1FU
           tY33CKJPkFPJ8iDELlZLBuoCx4OYzgJrxtFtgcLva84CzrfFm1vs671J2XT6tFB6B+
           pfcVQuTFJ4vrIAWsg80SUHBLCIX4wNG7GyaFu6lLddqsNztN7DT573GhfL5kawkxuL
           EtTA5BhL+5SKw==
Received: from localhost (77-236-11-168.static.play.pl [77.236.11.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 5 Nov 2026 09:20:05 +0100
Date: Thu, 5 Nov 2026 09:20:05 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 7/7] wifi: rt2x00usb: use a threaded
 NAPI with GRO for RX
Message-ID: <20261105082005.GG64923@wp.pl>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
 <20261031165117.2868671-8-hjf3108@gmail.com>
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
In-Reply-To: <20261031165117.2868671-8-hjf3108@gmail.com>
X-WP-MailID: 607961d4125142382bdef943e6499de2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [8TOE]                               

On Sun, Nov 01, 2026 at 12:51:14AM +0800, Ho Jie Feng wrote:
> GRO makes sense now that RX aggregation is enabled, since multiple
> frames arrive at once.
> 
> This code is referenced from commit 5323d3e50c20
> ("wifi: mt76: mt76u: use a threaded NAPI for the RX path")
> 
> Test results:
>    before after
> TX 30.5   30.5
> RX 80.9   161.7

What is the explanation for this gain?

I tested on my devices and do not see RX performance gain.
I would expect some benefits, but I don't see any and wonder why.
Maybe on your setup CPU get saturated on single thread ?
Or maybe I'm not testing traffic that benefits from this?

> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  7 ++-
>  .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  6 ++-
>  .../net/wireless/ralink/rt2x00/rt2x00usb.c    | 49 ++++++++++++++++---
>  3 files changed, 52 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> index 4c83168e9c169..25262b96c6941 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> @@ -955,9 +955,14 @@ struct rt2x00_dev {
>  	/**
>  	 * Scheduled work for TX/RX done handling (USB devices)
>  	 */
> -	struct work_struct rxdone_work;
>  	struct work_struct txdone_work;
>  
> +	/*
> +	 * NAPI context for RX done handling (USB devices).
> +	 */
> +	struct net_device *napi_dev;
> +	struct napi_struct napi;
> +
>  	/*
>  	 * Powersaving work
>  	 */
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 8f02b62cecdf6..6226bcbf24e5b 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -847,7 +847,11 @@ static void rt2x00lib_rxdone_skb(struct queue_entry *entry)
>  	rx_status->bw = rxdesc.bw;
>  	rx_status->antenna = rt2x00dev->link.ant.active.rx;
>  
> -	ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
> +	if (rt2x00dev->napi_dev)
> +		ieee80211_rx_napi(rt2x00dev->hw, NULL, entry->skb,
> +				  &rt2x00dev->napi);

The docs for ieee80211_rx_napi() states:

"Must not run concurrently with
ieee80211_tx_status_skb() or ieee80211_tx_status_ni()."

So we would need to either introduce lock similar like mt76 or
assure ieee80211_ts_status() and ieee80211_rx_napi() are done
in the same thread.

Regards
Stanislaw


