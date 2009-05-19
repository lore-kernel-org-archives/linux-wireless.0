Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:50481 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZESWdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 18:33:18 -0400
Received: by gxk10 with SMTP id 10so170239gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 15:33:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
References: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
Date: Tue, 19 May 2009 18:33:19 -0400
Message-ID: <b6c5339f0905191533v30683b9cueb929f44f2f8725@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: fix custom regulatory call position
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 5:49 PM, Luis R. Rodriguez > ---
a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1412,8 +1412,6 @@ static int ath_init(u16 devid, struct ath_softc *sc)
>        for (i = 0; i < sc->keymax; i++)
>                ath9k_hw_keyreset(ah, (u16) i);
>
> -       error = ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
> -                             ath9k_reg_notifier);
>        if (error)
>                goto bad;

Is the "if (error)" check still valid?

-- 
Bob Copeland %% www.bobcopeland.com
