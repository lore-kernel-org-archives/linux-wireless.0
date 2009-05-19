Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:62070 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZESWnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 18:43:15 -0400
Received: by wf-out-1314.google.com with SMTP id 26so26293wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 15:43:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0905191533v30683b9cueb929f44f2f8725@mail.gmail.com>
References: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
	<b6c5339f0905191533v30683b9cueb929f44f2f8725@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 19 May 2009 15:42:56 -0700
Message-ID: <43e72e890905191542k7e65200en8b6f9453ead1a21a@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: fix custom regulatory call position
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 3:33 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, May 19, 2009 at 5:49 PM, Luis R. Rodriguez > ---
> a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -1412,8 +1412,6 @@ static int ath_init(u16 devid, struct ath_softc *sc)
>>        for (i = 0; i < sc->keymax; i++)
>>                ath9k_hw_keyreset(ah, (u16) i);
>>
>> -       error = ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
>> -                             ath9k_reg_notifier);
>>        if (error)
>>                goto bad;
>
> Is the "if (error)" check still valid?

Sure, although we'll never hit it, we should just make ath_regd_init() void.

  Luis
