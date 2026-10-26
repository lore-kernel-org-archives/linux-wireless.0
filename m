Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793013241;
	b=yV3OGiR1QUXjXR5gNVu8PnQ9CT3Q7WK3FoCVILF/xm6q//RQW0J5b3rXqpX3jJ6PJ5BW
	 zfRMRO/NJClfGVTBMwTXDlG4f43AExviTj3BAgUqlLk8YcWh8PYYR5v1fra7AaxyUUuEC
	 d8IY9wc0yyKY9s4FTgHKoVlRH4+lYmPFIl38S+yROjtc1U070JL2ww3YYO3PR4ix0EwSj
	 XT/CrlNfmLm19l3f3y2mZJfK1Lc6riYNZ0hpXWYhUCAscHPldeOsXD51dO5XCuGA5n4ZG
	 iHhUChZMkTJFcq4LSSPohm6f8c9XDvGVkwjT11ypnQUFrrYLIxOFTUXLv5F3PHiBE6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793013241;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=e7RGHYdV9rXqUTcpDpwn7Hl1uc0wr4bXkNL+esQxyHw=;
	b=SUIuFDo56J/8zorglfy/bmgRc2Ge2ECXerVSxfKP+5coFH+DyjGecAruXOgOqfjqesTG
	 2oC4bfW2/q2Jk3HxAE1YbKWThSgvF8QQRURovNce904cnpCDKIgN6BcWQ61KhQ9wjKAhg
	 HgnffMIYpJeS+EU8u4cA8UudX3HrYKboWkB7pqrftNXkbaAUFFVJNXVnyNgR4hfxRjPIg
	 NDZokUiyD+w41ZWKQ3Y5u02la0fCzb6BU5QXfwjAqW/q9aFT1kvZ/MOqo16b4RP5jo3AE
	 WcKq9ww7qiXCXPPKs25KQfylugm9yR2h2Vh1ew6JOJoFFApfaVtQoVCqP/UYAlFM3Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ACC606B970;
	Mon, 26 Oct 2026 11:13:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7ACC606B970
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, Linus Walleij <linusw@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>, Giedrius =?utf-8?Q?Statkevi=C4=8Di?=
 =?utf-8?Q?us?=
 <giedrius.statkevicius@gmail.com>, Kalle Valo <kvalo@qca.qualcomm.com>,
 open list <linux-kernel@vger.kernel.org>, "open list:GPIO
 SUBSYSTEM:Keyword:(devm_)?gpio_(request|free|direction|get|set)"
 <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: release the LED GPIO after
 ath9k_stop()
In-Reply-To: <CAKxU2N9m58fCS1L7SQd_yzxcJV0NNyYHcj=jt_BVkrcc5rSOGA@mail.gmail.com>
References: <20261022022343.1409432-1-rosenp@gmail.com>
 <87o6ckqvsr.fsf@toke.dk>
 <CAKxU2N9m58fCS1L7SQd_yzxcJV0NNyYHcj=jt_BVkrcc5rSOGA@mail.gmail.com>
Date: Mon, 26 Oct 2026 12:13:56 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87bj8gpvd7.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> On Fri, Oct 23, 2026 at 8:30=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@toke.dk> wrote:
>>
>> Rosen Penev <rosenp@gmail.com> writes:
>>
>> > ath9k_deinit_device() frees the LED pin in ath_deinit_leds() before it
>> > unregisters the hw. ath9k_stop() then switches the LED pin back to an
>> > input with ath9k_hw_gpio_request_in(). For a SoC GPIO outside of the
>> > WMAC, ath9k_hw_gpio_request() takes a new descriptor through
>> > gpiod_get_index() at that point, and nothing releases it again. The
>> > next probe fails with "request GPIO12 failed:-16" and every LED update
>> > hits the WARN_ON() in ath9k_hw_set_gpio(). That request also runs
>> > under sc->sc_pcu_lock, while gpiod_get_index() and
>> > gpiod_set_consumer_name() may sleep.
>> >
>> > Free the LED pin after ieee80211_unregister_hw() instead. This also
>> > frees the pin when the LED class device could not be registered,
>> > which leaked it before.
>>
>> Hmm, instead of reworking the deinit code, how about we just drop the
>> ath9k_hw_gpio_request_in() call from ath9k_stop()? It's an LED pin, why
>> would it ever need to be reset? The commit that introduced that call
>> says it was "for consistency", which seems entirely bogus in this case?
> Why would it be requested and then not? I imagine on rebind it would
> error out in such a case.

No, I don't think so?

The current code does ath9k_hw_gpio_request_out() on init, and
ath9k_hw_gpio_free() on deinit. That's nicely paired, and only breaks
because ath9k_stop() for some inexplicable reason does another
ath9k_hw_gpio_request_in(). Which there's no reason to do; the pin is
never used as an input, and doing so would not make any sense anyway
when there's an LED attached to it...

In fact, the code moving you're doing in your patch ends up doing
exactly the same thing as just removing that call. Right now the
sequence is:

ath9k_hw_gpio_free() /* frees the 'out' pin and sets ah->gpiods[gpio] =3D N=
ULL */
ath9k_hw_gpio_request_in() /* succeeds and re-allocates ah->gpiods[gpio] */

but with your change it becomes:

ath9k_hw_gpio_request_in() /* exits as no-op because ah->gpiods[gpio] is no=
n-NULL */
ath9k_hw_gpio_free() /* frees the 'out' pin and sets ah->gpiods[gpio] =3D N=
ULL */

so we'll end up with exactly the same thing happening as if we just got
rid of ath9k_hw_gpio_request_in(), but the LED init/deinit code will be
decoupled in a weird way.

-Toke
