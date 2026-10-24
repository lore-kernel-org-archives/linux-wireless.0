Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792881010;
	b=cUBVjshnBgYyyFPFs+4yPl639jWaL/uWzuLMOebeD/41EgZGMQkpOE0xwo9t2BAbtn3E
	 2dNO2wp9PN2zWM7fCFxT6bHgxEqDDl2Qaoj4xzz0/CC9lreu4LMcZlptHA86aDPGrtDXo
	 F9CmAHEB0jk2y7XWMuV9Cf28hYtXd4pv+Rp/cjl9zoLhcaPSWjq2W/B8PjvZQiKAek8kk
	 TJtKzhIeFd43o+ImvHcEjZ1ZzXeKJllhgtOEpFGnaCCcZx3N9ad+lijUmBGs2uKQebdpQ
	 lJ8uV9D9kyzV9rD89Acz4SzUUBnatkJUw5xA0OlcSSiPb+pMO9rEZ9zoO0SsE7SWbrQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792881010;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PZME0oUNNAqEZpUwzUI5t6YgowzhWBCKgVCF/Etflr0=;
	b=y5zYj1Y8paieZlSVxbDJr6Nx2E9PtpjIteJDnaceGYEs9gz2Nmq6bGZPfctc7WUsIEtR
	 zxgxi3Pib584HJYbj+3jX2mGE26/6HGFV1HSIoG1GzuD02jXaw+yyBFqNyuMiAWKAmkdZ
	 cgnaOZrHsQDPdDxjY+uVPQPXkOBk0YGQCFSQjR6xlCSi6jCPjTGDwuK53bO1nso4cjXyR
	 yHzJcc5b0m/eG8lwDR+XqO/lS1ztPE8tFrriBaiF+M7Vj/3wZNDgTiGKRtNVfvYHmaSfi
	 IeJmSVxKpZbjT0hwgfePrw205OHhnvdRprQMYNjS5LK89SEnvo3Ugxw+lx/ikdq3W3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BRcBTBgQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC740606A31D
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 22:30:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC740606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BRcBTBgQ
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e98798cbddso7243565ad.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 15:30:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792881009; cv=none;
        d=google.com; s=arc-20260327;
        b=IR+LROttCXW8pOQ3Zl9AltFSSpstvUJgh9BuFPVHdKfBZKY3BH9QkmLcaOG+httYO0
         DsWSArOt8I5ggVXRiQ2DtsIIURZKx9m2DRr7BHchwiR+WW9Id2STLyKfRx+R9MqUzSzr
         NZK92MfLiWP8q0BFWgrjqCfe7EO2bgujGktvXdbX4Jcz4IeVPeGib/12rwgpGdqZgX90
         6tTBkEzEH97MldctCwlWSWoWIOp/+nYQje/bDvhDojEsbK0pEkyiqkPPUnGhYLXPKjaC
         xriuFmZTm0NzyIPtGVfUwbq38B1R71+OesX3MZMxySMklLNigm8ejZOt7tK3By+QOTNu
         ejuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PZME0oUNNAqEZpUwzUI5t6YgowzhWBCKgVCF/Etflr0=;
        fh=Hy974oMOz1VoAI4RSjeHNVf1L1C88kbJDAzBTJ3pF1U=;
        b=kyXkSiMHi710kB+9CvyvbqESQUl4slSwUeCr5ylMkbYqwd1UizKqDRTVTNFh5r/bQF
         uG1vLDFmPlAee200eqie3fX4+1o/cN9JnIXAyf8HSucrngAcI6JLjSuP9omzv05NBD/X
         QD3QdUOoaiQfTaw8AEiQVc+u65N3qgAPKqEwLt3C46HFPAvqVJM0sgGVoOHvPVIUYM3q
         UDdtb/sQ29SjPaeOIuR2QEQRHf6fzFEiUHbjt1LYousgHuzzzuJN13fx6/xomS3jHNA0
         Z3WfUgLMT085WO74+9vFAJOLbocw6572yL4Gn5iY5hfBI7sNxJ4t9UXZbAoOJX5S2M6I
         Nc1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792881009; x=1793485809; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PZME0oUNNAqEZpUwzUI5t6YgowzhWBCKgVCF/Etflr0=;
        b=BRcBTBgQjqQlE5DJVrTcGp2lnSxKkbsxey0hAI7cPKiZsq5ND1622CTxHGxhW1X7j5
         xtK8iMDTZ8uFJdRGdcjvAURlw/lDq+cKQwyobNTtvlpJm/yD4MojV6VaJTTrWTIupb2c
         nM0Ckecqh0CZ5Bb8b0ii6aLnfnE6MnwynIw0WLXw+7ZiBF9lAj6vQu34VLZn1OATrs7l
         N1LWYXKKM+w0gv4457nqEUdEIxN02uq3WMvuAihRbymMjugw9wgXaRyjFLEvlEPD7smh
         /DW2zBtBnOzgnZdV3WWttNde6vE7phzLOj2fX0qVQOSOdkt330v9e2tm0r8jJjWkTzMl
         LmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792881009; x=1793485809;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PZME0oUNNAqEZpUwzUI5t6YgowzhWBCKgVCF/Etflr0=;
        b=2OiTrRtvMYzzeTiRwIASBWELECwy1IoxldJdTQhD8lciDdqom1CB9YeSAAEX7uc+Yd
         nD26GOBfCHfzKf+yiDDMosQodfdNqwPvJGLdWuquC+mnGJfgEGkTqGXdIMel6QU9eUrY
         iIUHXfHLXJlpoayjmSC9+xhjq/Y/XVmshtuvFGceDEmfo1qVkLCm5IfebsbhxnFBNFv7
         AL4H3/crf595z3KsxjA8F7ZoehJ18d2rQ67ZkDq76GFZPPp/kkLrphC/bi20HhXfvJTv
         azrCYG6mntsC4TuUzFdGxKCUqfw3vBNN+kNyHW2FdQbygVuUjSiTlKei1+qHd7ogHzX4
         JUaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSQ8l7fCktUJ+w7Bfq/hgxbEB+PpYo2P0dRL1ei66szQlW89zAUvhtIozwiB60fFInXhimyZUR0GL+edwX/A==@vger.kernel.org
X-Gm-Message-State: AFq9FYK4x08qcXnMQ5jEEiCwBkXa0m3j6wEzFyPE5GjW5s/kTiveVOAy
	oQkj96Qh/vLsgj/WVUYOgNLu8VOO1x2hR8Zr5oDxc6Qtiqgx/DeRsy+xnln8oRl5w1D2Hiti9N6
	kviW0oIiEbX4W6+dK3G05vMAY+x7+QCw=
X-Gm-Gg: AYBFou0WsNqy0SS2VvlO1lkdw3RouRckN1KyPlklQbkjZWvRPc38uCNYIMx/TgZup42
	a8DYbeG7NNngxZbudtYVNiKUo/Mhc89bTapf03KGeRPyNKWCO1B+C2VHf82oE8dDYiTxGlFZrEC
	tv9SA5tvW0fXISIDjYgc4dcPcVdKioLG087GbFL1YgC1dIqsHvZx0J5JT5JrTdxjlqJpEvT1PBU
	MzOagQI+Uacq/MF53I5auWMFWjMfHPbZTBOQm6Hh1AQJ1RaniiDnTeP90i1rogUigVAupVWItQI
	TnKEyBBfdaKTrbw3qSXZbooXOWB0ir/6/O3KASXLCXmn8qXycD99Xor8sEAZVK87mweAvaeJpco
	GV59R3KsBpc/+M6D4WELaJHb15lQh1GclHcpPaA==
X-Received: by 2002:a05:6a20:548c:b0:3e2:9dee:42cd with SMTP id
 adf61e73a8af0-3e7bfa95bc8mr2307021637.36.1792881009249; Sat, 24 Oct 2026
 15:30:09 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAHaeJsQLvC-KBEpy5qu8iYxSB51mbHohrPvN4PJushF_Tk3foA@mail.gmail.com>
 <20261023180554.7266-1-lucid_duck@justthetip.ca> <CAHaeJsSfoTxJhWVCrELCiLZr1zD42LGJUvrmf7oSzRQpwh6-jw@mail.gmail.com>
 <20261024173414.10559-1-lucid_duck@justthetip.ca>
In-Reply-To: <20261024173414.10559-1-lucid_duck@justthetip.ca>
From: Chris <hoopyfrood42@gmail.com>
Date: Sat, 24 Oct 2026 18:29:57 -0400
X-Gm-Features: AclHuK9o9StbGbjqRGEyKvKK_k8FgZq3xzv3Qw33wdsis2WlZchhyzyHV6yo0Hw
Message-ID: <CAHaeJsTHykkk8Cm+FUZW2RmzzmT47aJNxRR1kpymhDvknnhKuQ@mail.gmail.com>
Subject: Re: [RFC PATCH wireless] wifi: mt76: mt7925: get the survey airtime
 from the firmware
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Deren Wu <deren.wu@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Javier Tia <floss@jetm.me>, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 24, 2026 at 1:34=E2=80=AFPM Devin Wittmayer
<lucid_duck@justthetip.ca> wrote:
>
> Chris wrote:
> > One thing on offset 20: in monitor mode it doesn't look like all of
> > rx.
>
> You're right, it isn't all of rx. Your numbers made me curious, so I
> tried it here with an A9000 as a 20 MHz monitor next to an Alfa. It
> seems to come down to how strong the signal is. Share of the time:
>
>                                          offset 20   decoded frames
>   one strong neighbour (-22 dBm)            2.3%          2.0%
>   only weak neighbours (-73 dBm or less)    0.0%          3.6%
>   my upload, monitor on a side channel     54.6%          7.5%
>
> Strong signals land in 20 even when the monitor can't decode them,
> including spill from the next channel, and weak ones are left out.
> That would fit what you saw on 5 GHz and on channels 2 to 4.
>
> As a station the A9000's own downlink does show up in 20, so I'd keep
> it as the receive time.
>
> Thanks for the long run against the Wi-Spy, and for the Tested-by.
>
> Devin


Devin Wittmayer wrote:
> As a station the A9000's own downlink does show up in 20, so I'd keep
> it as the receive time.

Makes sense, thanks for running that down. Strong signals counting and
weak ones not explains both of the oddities I saw. For my use, a monitor
hopping channels, busy time is the figure that matters, and that one
held up on every channel.

Happy to test a v2 on the A9000 if one comes.

Chris
