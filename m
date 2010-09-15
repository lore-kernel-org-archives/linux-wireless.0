Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:49236 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0IOBGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 21:06:41 -0400
Received: by pxi10 with SMTP id 10so2587131pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 18:06:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009150958.14525.br1@einfach.org>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com>
 <AANLkTi==HEkmY4TR=r+4Ymk_55fBORmRgF+SFGQzK750@mail.gmail.com>
 <AANLkTim=hRJxQW+UomOQygmLjrePym=Cn-o7RzKqWc+D@mail.gmail.com> <201009150958.14525.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 11:06:21 +1000
Message-ID: <AANLkTinZmv-o-tbR=2kso8jqZPTMdG=eKFCbM9DJ41d2@mail.gmail.com>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 10:58 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Wed September 15 2010 08:07:36 Jonathan Guerin wrote:
>> I'm capturing using a third-party station. I've had to use a Madwifi
>> station, as ath5k throws a lot of spurious timestamps up, which make
>> calculating this very, very difficult.
>
> ah, that's interesting and something we should check, too...
>
>> Actually, I've found that they were exactly one slot time negative
>> (give or take 1us). That said, I was doing these calculations using
>> the 802.11a OFDM spec timings. I looked at the driver and realised
>> that SIFS is actually being initialised to 14us, whereas it should be
>> set to 16us. This will also affect DIFS. Once I take these into
>> consideration, they come up as approximately 4-5us out. Now that I
>> think about it, it could make sense.
>
> hmm, we have a function ath5k_hw_get_default_sifs() which returns 16 for
> 802.11a, but it's not used for setting the IFS...
>
> also i think current ath5k_hw_reset_tx_queue() is buggy and sets the AIFS
> wrongly. it uses ah->ah_aifs + tq->tqi_aifs which is 2 + AR5K_TXQ_USEDEFAULT
> which results in 2 + (-1). that does not make sense to me and i will post a
> patch fixing up some of that confusion (but not the SIFS issue) today.

I'm getting these values from: initval.c
/* Initial mode-specific settings for AR5212 (Written before ar5212_ini) */
static const struct ath5k_ini_mode ar5212_ini_mode_start[] = {
<...>
	{ AR5K_DCU_GBL_IFS_SIFS,
	/*	a/XR	   aTurbo	  b	   g (DYN)     gTurbo     */
	   { 0x00000230, 0x000001e0, 0x000000b0, 0x00000160, 0x000001e0 } },
	{ AR5K_DCU_GBL_IFS_SLOT,
	   { 0x00000168, 0x000001e0, 0x000001b8, 0x0000018c, 0x000001e0 } },
<...>

The IFS_SLOT time is correct:
0x168/0x28 (clock multiplier) = 9us

SIFS is coming up short:
ox230/0x28 = 14us

I assume that the card calculates the DIFS from these two values, as
described in Section 9.2.10 DCF timing relations in the spec?

By the way, I may be completely wrong about some of these things, I'm
just going off the understanding I have regarding the register values.

>
> bruno
>

Thanks for looking into this!

Jonathan
