Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865259;
	b=tKmECL3ih4vGqdIYfMHanPJTh8OQJt9KyLA8EkWMUtNG3WGk2koQBgaiLzboupIyQSA1
	 Z8GviDC4ELlyhzKnYOXX/W3O4OJLztybyJCgDsD2gob4RxSMJ+ZrEDyeYvm0KbolxTZ6M
	 PTgTcoqBDfQuNznjMcm8RiaJzesgsrV15D/oAJBXPnKm0j0L9Le1wQ4zjrEEbJsDkrQ8/
	 0YMFH+avXDJZt4Hn2YfZe0KB4GrgLMTDrCuSkuGi4y9vuHKhueBmIjNFmrXyre/faJOFr
	 SVBcNbymYm8uTaO0Sh9aNu6ugz+KYiol9AUB0fbK1d2rwTgF3QCKXiCUcZkDXRnD2JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865259;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=+rU20r7Dr13iRSBw8Jn6KltxQDYBVImv5e7de11TRhk=;
	b=pu0aYixR9+7QfHmw1K4JuAmWZ6AaiProJ7Br7KSW/QjyKTCDM3I5GplQdkQPfX5kuN4x
	 lDjYFbWWARnsfdeWW36bJX71Hd1QYN+kcMzQGQEfhQrZSx4e71ioSslZVPChOGXXluKSE
	 8mNITdZG+fQMuMCFNWeRRc2lMDBc+mu8oJewyh9FuhTgT73BCBsZgG257OsN1gSIGTG4F
	 TQiTpPSQF0Jcr+sPVfoj/FLNYHkeInK/uNi654F7uN2EbeaWP1Uzs7J0m7Ll5MGGaXe6L
	 pUhLsSZol8RW4WkhBnupKCkkQ0XT5jsp7kKtqOfQJwwM5p8/5Gcm5uqhgeWXtPXvytg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=KJrYile7;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5343606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5343606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=KJrYile7
Received: (wp-smtpd smtp.wp.pl 29956 invoked from network); 5 Nov 2026 08:54:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793865256; bh=+rU20r7Dr13iRSBw8Jn6KltxQDYBVImv5e7de11TRhk=;
          h=From:To:Cc:Subject;
          b=KJrYile7ftSxvzHgg0EpXRW6ttYBPsuwm/NiG5oLWPaiTte1usFmUGiqJmIO4mQ1G
           dU0Wg6jxUq/ADK/LySrMXxkfa1rRYJi8Ua/UpGh9aPCTVVBBb69ppI4ttC3Ir6d/Zo
           7RgDgyFOhXQs6o+b85bn1fQBzoMvvc/AZpL/OdRQZAiV6DtmfWI+Jub88kdzM/K8PY
           kFOoEVleSgZnRkMvju/MS/q4Z/wrQRxth5cp+2h9AhAgXDY4qOooLRb2igfV+3M2jh
           Ou4rbqjofqHLylS6UW5xiYpWSFUzDe9DbCOPR2qTnVUVKnratugvHkbxwdc74uDKgO
           jqZ+RlWR+OSmw==
Received: from localhost (77-236-11-168.static.play.pl [77.236.11.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 5 Nov 2026 08:54:16 +0100
Date: Thu, 5 Nov 2026 08:54:15 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 3/7] wifi: rt2800: make MCS 16 fall back
 to MCS 8 on devices with 3 TX chains
Message-ID: <20261105075415.GC64923@wp.pl>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
 <20261031165117.2868671-4-hjf3108@gmail.com>
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
In-Reply-To: <20261031165117.2868671-4-hjf3108@gmail.com>
X-WP-MailID: 152d5a30443aa7cf71d125b5e8be1581
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [AQMk]                               

On Sun, Nov 01, 2026 at 12:51:10AM +0800, Ho Jie Feng wrote:
> MCS 15 has worse reliability than MCS 16, since 16 and above
> are 3 stream rates, and 15 is the top of the 2 stream rates.
> Falling back from MCS 16 to MCS 15 does not make sense, so
> make the fallback to MCS 8 on all devices with 3 TX chains,
> like the Ralink driver does.
> 
> The retry chain is now MCS 16 to MCS 8, skipping 7 MCS rates
> in between. Reflect that in the retry calculation code. This
> also fixes the retry count on RT3883, which already used this
> fallback.
> 
> Test results:
>    before after
> TX 28.2   29.1
> RX 70.4   70.2
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 10 +++++++++-
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  5 +++++
>  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 14 ++++++++++++--
>  3 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index e7b6edf485099..5e1ee016624c6 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -1116,6 +1116,14 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
>  		 */
>  		__set_bit(TXDONE_SUCCESS, &txdesc.flags);
>  		txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
> +
> +		/*
> +		 * On devices with 3 TX chains MCS16 falls back to MCS8, so a
> +		 * frame that was sent below MCS16 after a three stream rate
> +		 * skipped MCS9 to MCS15.
> +		 */
> +		if (rt2x00_is_3t(rt2x00dev) && mcs >= 16 && real_mcs < 16)
> +			txdesc.retry -= 7;
I would prefer to change condition to: real_mcs <= 8 
It would be visible that we can not overflow txdesc.retry by subtraction.

Otherwise the patch looks good to me.

Regards
Stanislaw
>  	} else {
>  		/*
>  		 * Transmission failed. The number of retries is
> @@ -6303,7 +6311,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>  	reg = rt2x00_rt(rt2x00dev, RT5592) ? 0x00000082 : 0x00000002;
>  	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, reg);
>  
> -	if (rt2x00_rt(rt2x00dev, RT3883)) {
> +	if (rt2x00_is_3t(rt2x00dev)) {
>  		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_0, 0x12111008);
>  		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_1, 0x16151413);
>  	}
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> index a80508db32d9c..f82dda0266f9b 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> @@ -1193,6 +1193,11 @@ static inline bool rt2x00_is_soc(struct rt2x00_dev *rt2x00dev)
>  	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
>  }
>  
> +static inline bool rt2x00_is_3t(struct rt2x00_dev *rt2x00dev)
> +{
> +	return rt2x00dev->default_ant.tx_chain_num == 3;
> +}
> +
>  /* Helpers for capability flags */
>  
>  static inline bool
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 4d94b7062f440..db33c1215de97 100644
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
> @@ -340,8 +340,18 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
>  			tx_info->status.rates[i].count = retry_rates - i;
>  			i++;
>  			break;
> +		} else if (rate_idx == 16) {
> +			/*
> +			 * TX_FBK_CFG_3S_0 makes MCS16 fall back to MCS8 on
> +			 * devices with 3 TX chains, the decrement below shifts
> +			 * it back to 8.
> +			 */
> +			if (rt2x00_is_3t(rt2x00dev) &&
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
