Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47062 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab0EVSn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 May 2010 14:43:58 -0400
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath9k: Make sure null func frame is acked before going into PS for ar9003
References: <1274147876-9228-1-git-send-email-vasanth@atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 22 May 2010 21:43:54 +0300
In-Reply-To: <1274147876-9228-1-git-send-email-vasanth@atheros.com> (Vasanthakumar Thiagarajan's message of "Mon\, 17 May 2010 18\:57\:54 -0700")
Message-ID: <877hmvixp1.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vasanth@atheros.com> writes:

> Add missing code to handle nullfunc frame completion in
> ath_tx_edma_tasklet().

[...]

> +		/*
> +		 * Make sure null func frame is acked before configuring
> +		 * hw into ps mode.
> +		 */
> +		if (bf->bf_isnullfunc && txok) {
> +			if ((sc->ps_flags & PS_ENABLED))
> +				ath9k_enable_ps(sc);
> +			else
> +				sc->ps_flags |= PS_NULLFUNC_COMPLETED;
> +		}

Few months ago a similar test was added to mac80211. Why does ath9k
need this also in the driver?

-- 
Kalle Valo
