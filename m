Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792779595;
	b=aTKrHAxsSQj/SS1PTeVP+k8rNpaDfzyZu0Lht8xjvt52Hwsr9TDfOi9XuNWwx6HFOUAH
	 HkYFsZuRO9RPySGjiWzwASxSABibhqIu65JGXhz9NPKzccDe9NEneevONsbBrmJTzABTH
	 CbC5nhhmZcwy5ZBo7Hi/og7uhXnYzOF4d5gVW+Sv6SJhuVW3FZBPtutL3Wb2tjxyhUNxY
	 o127v9LIjXbpn+vPwjYCudqrCITjTgH01CBMAbXvibFzsytDH2uXZa15QQQ9aFQ7M8Ua1
	 592Oum2Ijs6jBRV8huTLB9OExrFCGqFr9ZBUX6TFzBMepQ7/39eIBUMFAETxvLPIB/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792779595;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Ib/ri5CDuAjwUK4goxK/03XfhwG7mHhhdijFj1BEbio=;
	b=A5ZW/PoZvWUeuDa5KNzuRgf2Y/OkTdgKBj8gFc338lJMJ5/EX1+PQyIpWGUSe7iygLze
	 SviLzDTB2oEye4L9FS2eel+yao1/399WvtCa1CNu7W+oTSS3qXeckaY5FKezkoztu/HGl
	 Xt89W6M8n1OI4XLQ+QIgZVFwMf7n5v6LPv3t3GbC1CvwlhSi0drAJggj1zgy3F2bCxPym
	 EwOuaBiDsu1Q+38fyNmpH0z/trkMOiujhZUvxF0/X6QQSDQOZzkQ8ev23/VwFnedJYm7f
	 HpweZZoQ8+mSVTIWtvV8+QH7EldYETFKM/RZROgSmnlPxp8cbHuIiF6bK/U+OVzhfUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PTVng4+k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACE6606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 18:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EACE6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PTVng4+k
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6ac76a02368so1565681a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:19:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792779593; cv=none;
        d=google.com; s=arc-20260327;
        b=ndBff+FA5q/bqw22UYqZPYBqnVRERCqODaV2bnicv8M0Vam9xjKTHMSUfHeaALVaKG
         gtRwbR8wRQVhaug4jkZ56X960MsnSGaeBuKy+rSH+SYOX1eGg+DsBjOrKVSP1xaoKfO2
         yRKLfhGA1Xm3kbHjFP53P2GL1WBNxQ7GmG6LOQ4BLIgpg9h9TLSVcEbEwx+ihDtrD++R
         4zP0F1S4Qx/IioMUoNomeqOIiYkXZhQ1uQ/q6BOfLzCrqj70iSqXcNyAB+xXRyjOfrHS
         k0lefiq045r/rK9xtzvGuhYtT28rpASwsOlVxg8RfTh69ULKf0d3N5dheLOc3OBSzp71
         SF0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ib/ri5CDuAjwUK4goxK/03XfhwG7mHhhdijFj1BEbio=;
        fh=82eK3S4t5f/yNxaCu5vhrG4k1zSyVsB9Z/M16ZdVGA0=;
        b=X7w3PFlk+L03FGlOgia14/EZZ6csVqFJYgvPNU3I3kdSsYylcokQcQiZcvvkxivHAJ
         B2apSAEewLJVYdUE5ZyJhMcmriU9AgvWXugjXKe1euC815kMtmMxboUDKDKwg0B/w5Xs
         L+xwfPl/8eIK6ySxF2OVMh/T49ErU8el0Rq97xNuD9zrfyKPQyFmZOhVBjZVwJwXrVTZ
         3uBlE76U+nwP8GmIInZV2r3hNAPI6Sj5irTDREvibeekoPrQvJM/JSy8XTJtZefa9ljY
         thjZT0AdRybB+infy9saSPkU3/PI/462AWlE59ew0/RLubCsntChimdLV1OcHWg4S815
         H99A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792779593; x=1793384393; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ib/ri5CDuAjwUK4goxK/03XfhwG7mHhhdijFj1BEbio=;
        b=PTVng4+kNSaYoXcW9ZVpky8q6wGS/1f+oQ7ufoyFjtG2Wvv6QzpYc9OETVLucX0YLZ
         aINQMccPii23lGhCvpB7Ga/Z2ZGb4DGGs49zFY4sLcTgR8U7oab7Zr6cnQUQYX4tiRPN
         AiZO4ZfMme3RiM0tzElJm3Bud8fqTw0jGC743PLpawmnAd1St4vz6bmHO9/IZnURbz8j
         ao/O/+j+ZGgdYAMr3rMyOWXc7bM/+o+8ieMjEVgPYfs4nMtscFxszBWe5HVOjizdT1eD
         CEZGOxfccNgWXBw5eZ5jmaaax3HVC3Bak5/u0+lG8hrtCRQpTq8eNHqNJT8mNRXlSR+a
         A+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792779593; x=1793384393;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ib/ri5CDuAjwUK4goxK/03XfhwG7mHhhdijFj1BEbio=;
        b=Kd2/H2rNayyiAHd+fqd079yu+ooDSP3Fx0+fjdMF8o2LjMXntL7KciWsUwVkYEkza1
         t0B827K1SrJIS4CitemfXo9V/qb+M1gocN+gssgeERNKRQ2+4MoLKsDwUjlurX341bn+
         Mf1Jzim9EtDyMC1OIhlj6bPRrV/xbLbe65YoM1l/mIFmWuBafoL0mTiTuH2TmXEGToHK
         SdiIQmJhu8NiEYRC39Cz0FeSx8TpdlJO5R/YY9TYlFVsFkZhHOyhorBgrtdhoZ+kOIAq
         dxiMmvZEdzOpbYpz+xevgmg+3fllusfcdEy5MUioUgwPWj4HE+rXO/C0F1sG54MzsFkP
         B4pg==
X-Gm-Message-State: AFq9FYJ6lJmbBvAHxufxooxDfZbzjRm6h6+wCVc6qTfCuZPm7Wg9KU2g
	37vlAfKwlU4wwC/55UnDP4QVyck6pK2uX554K5ezAXFLx/e74C9txtheGa25WKTpKUrSFAI8Uau
	fw7vxMzRGsaGvq1YF9L+auYQVRMM/8uR3wmc2
X-Gm-Gg: AYBFou0NENzYb7H+QkchWl4z7EAwxHrq84HW7t8ggdWjymN/Q8GnoV62zEOD86zVWUF
	/G2TeQccypJAm7POYhvgBgoAJaFEEtWdv7skaztkoteFIxUHWXv74LipIVIkZguz+t99u7r6zJT
	feGtEWlAns23JvSabpK7Gy0fTcWYZheQP+rJzK7EyFxVqccJb/PDDffW2kxAsvk2fg9osnDn1Hd
	hD3gM5yBrK14Vz+3DHS72viZzKzUL53UdP49yT4ZPHdBlnweGth/PmANipsvDgsTNr2MbJTbWbZ
	dO+jPle53KhYspg7fE2QoclKlHAPXVbVyAUc2Tn5HZDJNybPFnMNUAmkijY0q84hDT8HVoMSS+3
	yvCebsZd0SWh9BgDIewPCNKVCzmyx79rxk36G2jctYPZZUOmgUH6B9UNNc0STjPAQrleMi0nfRb
	+agx/+Wjyl39CRdds3yz9n53m4Ms1xU0q6J9pVig+TFoLtB7tXGoXjuw6RrdDEphiJ6z7EHab9P
	eqxIiiecTryN2Rf/Ho3T7hR68o4xy24fT4PDIskhTaQB5orD+gF5FlfQNSuKANjwSj9zx0=
X-Received: by 2002:a05:6402:1ed0:b0:6b1:d439:5c5 with SMTP id
 4fb4d7f45d1cf-6b442a82876mr18979a12.3.1792779593007; Fri, 23 Oct 2026
 11:19:53 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022022343.1409432-1-rosenp@gmail.com> <87o6ckqvsr.fsf@toke.dk>
In-Reply-To: <87o6ckqvsr.fsf@toke.dk>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 23 Oct 2026 11:19:41 -0700
X-Gm-Features: AclHuK9hNtjapAGTuPaNp1z8hxnwNiaSclFMvsF-Bmo9RDpb45Bd-X4aERvn6hw
Message-ID: <CAKxU2N9m58fCS1L7SQd_yzxcJV0NNyYHcj=jt_BVkrcc5rSOGA@mail.gmail.com>
Subject: Re: [PATCH ath-next] wifi: ath9k: release the LED GPIO after ath9k_stop()
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org, Linus Walleij <linusw@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>, 
	=?UTF-8?Q?Giedrius_Statkevi=C4=8Dius?= <giedrius.statkevicius@gmail.com>, 
	Kalle Valo <kvalo@qca.qualcomm.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:GPIO SUBSYSTEM:Keyword:(devm_)?gpio_(request|free|direction|get|set)" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 8:30=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@toke.dk> wrote:
>
> Rosen Penev <rosenp@gmail.com> writes:
>
> > ath9k_deinit_device() frees the LED pin in ath_deinit_leds() before it
> > unregisters the hw. ath9k_stop() then switches the LED pin back to an
> > input with ath9k_hw_gpio_request_in(). For a SoC GPIO outside of the
> > WMAC, ath9k_hw_gpio_request() takes a new descriptor through
> > gpiod_get_index() at that point, and nothing releases it again. The
> > next probe fails with "request GPIO12 failed:-16" and every LED update
> > hits the WARN_ON() in ath9k_hw_set_gpio(). That request also runs
> > under sc->sc_pcu_lock, while gpiod_get_index() and
> > gpiod_set_consumer_name() may sleep.
> >
> > Free the LED pin after ieee80211_unregister_hw() instead. This also
> > frees the pin when the LED class device could not be registered,
> > which leaked it before.
>
> Hmm, instead of reworking the deinit code, how about we just drop the
> ath9k_hw_gpio_request_in() call from ath9k_stop()? It's an LED pin, why
> would it ever need to be reset? The commit that introduced that call
> says it was "for consistency", which seems entirely bogus in this case?
Why would it be requested and then not? I imagine on rebind it would
error out in such a case.
>
> -Toke
