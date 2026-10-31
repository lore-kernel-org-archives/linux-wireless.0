Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793444085;
	b=KaVRK9i6dC+QsmUHGnDg4xjXXC5J1dgNdlaLJCguydpAxPDkBxVxKdB1olTpJL1B8qOZ
	 RMl2I2X9B5hJstDHDLORVoUq1o6qjRLgD4A4Rt0adMoTM5YXIJu1OWgA0Ou5L8Y4QaVLT
	 Ul+SL8HcVfou/ikJdxpnhQsW8F9fJJ70eDceudwGY/x4I8bamAwaA+Cez6oYHABLgPwm/
	 KR10xkhpA28yeX+Helq0AYaLpPeOYw+0vmXwilXxbGZQI5ObF8iCehn7G5hfwsZgDkrAH
	 qnaWjdB45Q9WYr/v4el2HbezWqshYsm/GIAJ/tT4kKz2WmnJUeLIpXwiR1YBcEEy7Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793444085;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=/V86iMFP1vJ/V4kzs5t71VbJUoSDcgmsIQzUVHvfOMI=;
	b=wiFT5TiSwks5W5pm/YhGRSqHM/o7VdLxPWgxFfRue7hveJ9ykiNmTGWFkNf5lbcmCJa2
	 KVUwveIiVciUanl3yx38fjQdoGsiA8hHpSZNf1EkYF0WPaXIFdMy3Rqkn/FTeqtAQtUfi
	 JEQrPFlGdT0DfI+SpkV5vVC8FDaNwnkEEXhpXLl8TKdc5a+IBWZaHBz01k+WQ5mxpz8EI
	 HwKv1TMn49nrlBXzXfiz1ubMB6ij7KoiZt3znN9stRROVC5YLBBrO1wZDeGUfiK0qx76J
	 KUiPTsQxrTM2K9vtlo40fcJAN8SS5XNnwWKSonkfhJXUsyiTNTYT08H1jwGkX64+LNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=e11ULkk3;
	arc=none smtp.remote-ip=212.77.101.9
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4B7606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 10:54:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC4B7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=e11ULkk3
Received: (wp-smtpd smtp.wp.pl 23110 invoked from network); 31 Oct 2026 11:54:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793444082; bh=/V86iMFP1vJ/V4kzs5t71VbJUoSDcgmsIQzUVHvfOMI=;
          h=From:To:Cc:Subject;
          b=e11ULkk3pWCGiV2PCC29hhbDKI9Qc05LIOHgp7qUv+tfIPZ/zZGzNNeArBlzFIBF9
           GB2CxTp7Z6W4xjhEIAppPOIGb8u7bYPBzeyUtqZpNw96Y4As021vrJ00e4/iPpG0Aj
           UvCy0Cnr4QRHz2aBhlKoUIPv8AonE86xe/XY3cO6EyQH6+VbDwaOh2UjYNVUee2Dzk
           pOlj1tNR36qwhJwPm3l1Mw5zenUhs9H8Z+cNth+Zsgd6dqee3u91uvSYDQPoeVgPJp
           hSVSDqgm4bqgD5MJhw1K8lH2kliXyx25vXMOP6LwrlwuLxo6pH6a+fLhvUQNSKkwhP
           Ilt2xnhDURJlg==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 31 Oct 2026 11:54:42 +0100
Date: Sat, 31 Oct 2026 11:54:41 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 4/8] wifi: rt2800: report the MCS16 to MCS8
 fallback of RT3593 in TX status
Message-ID: <20261031105441.GC31143@wp.pl>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
 <20261029134752.1299130-5-hjf3108@gmail.com>
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
In-Reply-To: <20261029134752.1299130-5-hjf3108@gmail.com>
X-WP-MailID: 65d240ddf3a61c8536ea342b3dea758a
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [4YIB]                               

On Thu, Oct 29, 2026 at 09:47:45PM +0800, Ho Jie Feng wrote:
> The RT3593 retry chain is now MCS 16 to MCS 8, skipping 7 MCS
> rates in between. Reflect that in the retry calculation code.
> 
> Test results:
>    before after
> TX 27.0   29.4
> RX 70.0   70.0

I think this patch should be merged with patch 3, and also 
similar handling should be done for RT3883 since it has
the same fallback pattern.

Regards
Stanislaw
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |  8 ++++++++
>  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 13 +++++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 9d88ee698b854..de234bcc7a065 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -1116,6 +1116,14 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
>  		 */
>  		__set_bit(TXDONE_SUCCESS, &txdesc.flags);
>  		txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
> +
> +		/*
> +		 * On RT3593 MCS16 falls back to MCS8, so a frame that was
> +		 * sent below MCS16 after a three stream rate skipped MCS9
> +		 * to MCS15.
> +		 */
> +		if (rt2x00_rt(rt2x00dev, RT3593) && mcs >= 16 && real_mcs < 16)
> +			txdesc.retry -= 7;
>  	} else {
>  		/*
>  		 * Transmission failed. The number of retries is
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 4d94b7062f440..823785088a308 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -329,10 +329,10 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
>  	 * lowest rate was used.
>  	 */
>  	for (i = 0; i < retry_rates && i < IEEE80211_TX_MAX_RATES; i++) {
> -		tx_info->status.rates[i].idx = rate_idx - i;
> +		tx_info->status.rates[i].idx = rate_idx;
>  		tx_info->status.rates[i].flags = rate_flags;
>  
> -		if (rate_idx - i == 0) {
> +		if (rate_idx == 0) {
>  			/*
>  			 * The lowest rate (index 0) was used until the
>  			 * number of max retries was reached.
> @@ -340,8 +340,17 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
>  			tx_info->status.rates[i].count = retry_rates - i;
>  			i++;
>  			break;
> +		} else if (rate_idx == 16) {
> +			/*
> +			 * TX_FBK_CFG_3S_0 makes MCS16 fall back to MCS8 on
> +			 * RT3593, the decrement below shifts it back to 8.
> +			 */
> +			if (rt2x00_rt(rt2x00dev, RT3593) &&
> +			    (rate_flags & IEEE80211_TX_RC_MCS))
> +				rate_idx = 9;
>  		}
>  		tx_info->status.rates[i].count = 1;
> +		rate_idx--;
>  	}
>  	if (i < (IEEE80211_TX_MAX_RATES - 1))
>  		tx_info->status.rates[i].idx = -1; /* terminate */
> -- 
> 2.53.0
> 
