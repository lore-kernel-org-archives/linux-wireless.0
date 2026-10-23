Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792769418;
	b=p2uWMdW/wkkLKXY1UbeAR3paE0srhHAoCd1XMUVvY++t0QTJWdjEXKRqxhd/P2lDZtZ9
	 CfYP5DvFf8BBD/33Ss+xO/628a4r95Itd7HW0Ll20rP6FxoVbAZM3cEn0GC+svxS9Afs+
	 pXy3GOzt/KNMZv6SCtdxXbtx4iaNdLS5049ezkFe9Y6YcXO06DU8t3/qCziqStb+4kNd/
	 DbFG1/rX2xjtKYhzX1vz5NTWKwtNlHQrUL2WKmSYe4OjFPBullZBrsdBqg4gLvNOSEnDg
	 WqPZ91OYfJOeaI45mwMUbWrkgz/FQS53tafHKRvwSpEnut8FN2SJ3vkat8aHnqnInGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792769418;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type;
	bh=xC4ftIFPXqAqxZNHjBYDqGaIIOmnwg5XnZUsW3Lvh3E=;
	b=d1rYFEx6X2fsVhKw6kL6RwRjIzx56LOvHAxGx7pY8CIweMYBR3PJSiu4e6KqbGl6VLfa
	 mVDqHUbpSg+kQ5akPCypV1CmNWweYaudogLOPfLFJG+2jXWzbBFqkB/EzcZ5/EX9VO4aS
	 zTrPRTqu9MvZ986IuZGRbkaxQtVkF7ewIRdU2rrfZOhdN1ISxENfAIP4AJcYzOp2Y2vWm
	 0dk/0akIRGQCWuZo7EcmQA0CglUbiUqgYNpN/88rjmrdFS8xyMMf6IRB/loGda+JjLtHj
	 HcHR5dPe5ksfLlYhmoslrB9Nu/DFC0XPDP9+FVBugQIwQi+os2AzNA0KYO69MYvAkBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AF3606A31F;
	Fri, 23 Oct 2026 15:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59AF3606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski
 <brgl@kernel.org>, Giedrius =?utf-8?Q?Statkevi=C4=8Dius?=
 <giedrius.statkevicius@gmail.com>, Kalle Valo <kvalo@qca.qualcomm.com>,
 open list <linux-kernel@vger.kernel.org>, "open list:GPIO
 SUBSYSTEM:Keyword:(devm_)?gpio_(request|free|direction|get|set)"
 <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: release the LED GPIO after
 ath9k_stop()
In-Reply-To: <20261022022343.1409432-1-rosenp@gmail.com>
References: <20261022022343.1409432-1-rosenp@gmail.com>
Date: Fri, 23 Oct 2026 17:30:12 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o6ckqvsr.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

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
> Free the LED pin after ieee80211_unregister_hw() instead. This also
> frees the pin when the LED class device could not be registered,
> which leaked it before.

Hmm, instead of reworking the deinit code, how about we just drop the
ath9k_hw_gpio_request_in() call from ath9k_stop()? It's an LED pin, why
would it ever need to be reset? The commit that introduced that call
says it was "for consistency", which seems entirely bogus in this case?

-Toke
