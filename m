Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793179283;
	b=QLAOBioeVNaqIamSOO+HXl0qF0M27jMDc7aqqX60jbQ1AFzk6dWqmyXXdwYP6omhflC0
	 rTXy7WY1AGHyf6zu0Mm9DorCyimI//k8eGKxd6UHkZ9KqE6a7/vlR76ipcFa5URZyvxUi
	 Bbn67kcUUIBTZeeT/n+rb7bvOYWaG3SGLL3OJgCWkvqyPJbk/Sen5FMVUZprpqMu1C1Zj
	 gRJbZbdNAz5bgZzhKa1/9yUbSOjV713sYrGgjW1UFKKlczMCTLlVpIVYKNL6d639eZ1ZN
	 Ic+wauHWWg+blHu/9bPByiPd3BqqJBHTWXbbOEzBxDAK/USItRoNjXta3SNoGWTElyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793179283;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:Received:Received:From:In-Reply-To:
	 MIME-Version:References:Date:X-Gmail-Original-Message-ID:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=pWHDga10kmW0MDLVIkUsOtMHzTyMjmDGEDdz+Zojs0I=;
	b=tCo9MkZvWsS/wLOOJGqJ4cmMey7O6xWdIc+4nx+ciJIxNdRdWXcewYvbQ2dmBanW0/PV
	 BSO39LbpyP+QmVDuPOljr4eD1dAAh982Eus38QawrEMpHRfIOrEHaBWyO+h8+fWaZFakr
	 dxaA+Qn5RBNke9PksYNmJKVpyQIw34tmVScA+RoDH9/42n90kpxZD6o57ilXjPnfBM2NE
	 sKGO8Q/7gLsQ3CM6pXpV3D+UcpmE70PSUA1n5KOVTRNhypZnxnxPmHstdv1E7XVT6Uajk
	 iNixpfcmElwnzu5TXLEg5PVgJ/lz3ijJJG7UmNbA+moELVxe3JkrAITPkKqRdwNGVLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxEvsllx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B32606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 09:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxEvsllx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D581F031E5
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 09:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793179283;
	bh=pWHDga10kmW0MDLVIkUsOtMHzTyMjmDGEDdz+Zojs0I=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=gxEvsllxhpcnF3kbhzLtmLzCn82LqKIT1LuX/PaT+Xo7aIB7Rjy8Dv3ELHG/xSQU3
	 HQ/S4VH23pajim3H64XGlq8oO5FQpwG31H4kifzpCWOVryqeS6Q4HofbCOhDbf2u1U
	 CNphw1+5RFMs60ENl07TfsuMb+CAz1KvGcg/cVrApat5gURqy9do5FBFjKofU36IuJ
	 DryZa8N1vHgWaZpIFRXiHdV/rqZGpa2ybDeHf+XFscGFzPtyhGIZV2FzLSP0/mWISh
	 Ml3oUu0k7jq59UINbUASNTxqNiYVtfJu2eCqklHJJsAJWciZYfzpVbCe6sHftgKGVt
	 xZEkVA3BuniKQ==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3ab4891fc73so6538091fa.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 02:21:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBygBAsvYjvOMuLMwJcsuryLIgJOBAH6D2PzZDzzrPNEvTc5ONHWrYq1baoxc8fvaBO2tQTMLqKjZFA9Swax8g==@vger.kernel.org
X-Gm-Message-State: AFq9FYLCwyn+y/BeuHWQZH+HTEgZaeAX9PQfsh6QVjyThUK0RaSU8www
	wjRpwfueCrTLVEICagdN7B0Yb99Cu4/9uerH2V3saDIkWJaXqm/Mm60L40cEKO0//i0fX6Dax3X
	WrqBt9jqNxYsQPQDaHdMPB5x47evePQLpAEvWLWn5Og==
X-Received: by 2002:a05:651c:31c4:b0:3ac:42be:7e50 with SMTP id
 38308e7fff4ca-3ac9cf5b3b5mr3472451fa.14.1793179282092; Wed, 28 Oct 2026
 02:21:22 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Oct 2026 04:21:20 -0500
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Oct 2026 04:21:20 -0500
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20261028034057.114021-1-rosenp@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028034057.114021-1-rosenp@gmail.com>
Date: Wed, 28 Oct 2026 04:21:20 -0500
X-Gmail-Original-Message-ID: <CAMRc=MeG89HjLc42yK0-f6mWx8E96n6xA4wZ9CKyBa3Kgnn2ZQ@mail.gmail.com>
X-Gm-Features: AclHuK89EM60jjCdfR0SjAa3kzZ0tIN6wpR4VeQqwEqNXM9tUVvgV4iLumJ-xvw
Message-ID: <CAMRc=MeG89HjLc42yK0-f6mWx8E96n6xA4wZ9CKyBa3Kgnn2ZQ@mail.gmail.com>
Subject: Re: [PATCH ath-next v2] wifi: ath9k: don't re-request the LED GPIO in ath9k_stop()
To: Rosen Penev <rosenp@gmail.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>, 
	Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	=?UTF-8?Q?Giedrius_Statkevi=C4=8Dius?= <giedrius.statkevicius@gmail.com>, 
	Kalle Valo <kvalo@qca.qualcomm.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:GPIO SUBSYSTEM:Keyword:(devm_)?gpio_(request|free|direction|get|set)" <linux-gpio@vger.kernel.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Oct 2026 04:40:57 +0100, Rosen Penev <rosenp@gmail.com> said:
> ath9k_deinit_device() frees the LED pin in ath_deinit_leds() before it
> unregisters the hw. ath9k_stop() then switches the LED pin back to an
> input with ath9k_hw_gpio_request_in(). For a SoC GPIO outside of the
> WMAC, ath9k_hw_gpio_request() takes a new descriptor through
> gpiod_get_index() at that point, and nothing releases it again. The
> next probe fails with "request GPIO12 failed:-16" and every LED update
> hits the WARN_ON() in ath9k_hw_set_gpio(). That request also runs
> under sc->sc_pcu_lock, while gpiod_get_index() and
> gpiod_set_consumer_name() may sleep.
>
> The input direction was only added for symmetry with ath9k_start(); the
> suspend/resume fix that brought it back only needed the output side.
> On WMAC pins it also undoes the "LED off" level written just before it.
> Drop it, so the pin simply stays an output driven to the off level.
>
> ath9k_stop() still writes the LED pin, so free the pin after
> ieee80211_unregister_hw() instead of in ath_deinit_leds(); otherwise
> that write hits the WARN_ON() in ath9k_hw_set_gpio() on SoC GPIOs. This
> also frees the pin when the LED class device could not be registered,
> which leaked it before.
>
> Seen on a TP-Link Archer C7 v2 (QCA9558, LED on SoC GPIO 12) when
> reloading ath9k.
>
> Fixes: e34f2ff40e03 ("ath9k: bring back direction setting in ath9k_{start_stop}")
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
