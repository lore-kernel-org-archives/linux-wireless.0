Received: from mail.systemli.org (mail1.systemli.org [93.190.126.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F15051B17F;
	Tue, 13 Oct 2026 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791914702; cv=none; b=YxvhzQc8xUN27FOhYFuPkE9vu6p9gspeILfKK2Tom7ebLVm70RqEVRWI94RdODtQs7Ibpo4Y1qvGEJSpqziYOretdU0/6C1gyOizN2Tzw3+XjY2O8qmih6nqTc0bbrV6T8JymDl0xhS/RL2DuT09YH37skkvaBtpKovzKnfy8PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791914702; c=relaxed/simple;
	bh=iounqlr0ghmzA6o+rB5NrROrpFTPWmYgWQS/iCRWrgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WIH2JpZe+/Az2Lz/Q4ZmFk3IWmDGV8TNcsUgDutrGD+uC/CZYprz7ws9giCh6GRUzTueow/W+uHnEuP1m0/jrB/tomkIpVOTBDR7kdsNU/dWC4d7Fe42ZD7MQbMgsSuYTp038Lf2navjG0U1bnqYQFYRLPbZeqGumIQirZjcr1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=systemli.org; spf=pass smtp.mailfrom=systemli.org; dkim=pass (2048-bit key) header.d=systemli.org header.i=@systemli.org header.b=lO2HLpfW; arc=none smtp.client-ip=93.190.126.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=systemli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=systemli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=systemli.org header.i=@systemli.org header.b="lO2HLpfW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
	s=default; t=1791914182;
	bh=0f8w1KPBYOz2blbtbFQ6Hgoz6pLh4QfF+bptlzDZmiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lO2HLpfWy9nscnFDSZHRiqHmz0BL+D2s+PBmQNEga5smwGHRjbQSPuJrGQK9KutSY
	 I+2mehjg1VUcPjP73AgluH9rb8CbKLTnA1WDWB6mBi6qidHuc2MrD+zFvcf9jlaElw
	 cwGHU+pF4HPMstwpJrU/+Vv4miY2pk0zw68DfMxPyn942Rux5TRisPddbV8KQCjfBc
	 /D+m8fNDUubGxKXUgkGe8ne5+1yRgNz2HPn59dcPQtlfcfWJVbKhy6Vdsf4PYZSIkZ
	 M8LPm1iuvRngxd3QXdiTVJEz1ZbK5kYPpBeaiAhIMv0ceIay+gsNnO43IrcOtKZBk5
	 /3vFaKSM7RQVQ==
Message-ID: <bc41916b-f88e-4700-b399-418cd28b7126@systemli.org>
Date: Tue, 13 Oct 2026 19:56:20 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] wifi: ath9k: restore background spectral scan after reset
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
 linux-kernel@vger.kernel.org
References: <20260915194327.30397-1-vincent@systemli.org>
Content-Language: en-US
From: nick <vincent@systemli.org>
In-Reply-To: <20260915194327.30397-1-vincent@systemli.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Report: 
	*  0.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.0 DKIM_VALID_EF Message has a valid DKIM or DK signature from
	*      envelope-from domain
	*  0.0 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	*  0.0 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]

Hi, I did not get any feedback so far, so a friendly reminder. :)

Bests
Nick

On 9/15/26 9:43 PM, Nick Hainke wrote:
> A reset leaves spectral_mode set to SPECTRAL_BACKGROUND, but resets the
> spectral registers and receive filter. The driver therefore still reports
> a background scan even though the hardware no longer produces FFT samples.
>
> Re-trigger background spectral scanning after reset recovery so the
> software and hardware state match again. Do not re-trigger spectral
> scanning in disabled, manual, channel-scan, radar, or off-channel modes.
>
> Assisted-by: Claude:opus-5
> Signed-off-by: Nick Hainke <vincent@systemli.org>
> ---
>   drivers/net/wireless/ath/ath9k/main.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 740a6fc7b067..00e587fe6ee3 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -231,6 +231,17 @@ static bool ath_prepare_reset(struct ath_softc *sc)
>   	return ret;
>   }
>   
> +static void ath_restore_spectral_scan(struct ath_softc *sc, bool start)
> +{
> +	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +
> +	if (!start || sc->cur_chan->offchannel || sc->hw->conf.radar_enabled ||
> +	    sc->spec_priv.spectral_mode != SPECTRAL_BACKGROUND)
> +		return;
> +
> +	ath9k_cmn_spectral_scan_trigger(common, &sc->spec_priv);
> +}
> +
>   static bool ath_complete_reset(struct ath_softc *sc, bool start)
>   {
>   	struct ath_hw *ah = sc->sc_ah;
> @@ -269,6 +280,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
>   		ath_restart_work(sc);
>   		ath_txq_schedule_all(sc);
>   	}
> +	ath_restore_spectral_scan(sc, start);
>   
>   	sc->gtt_cnt = 0;
>   
