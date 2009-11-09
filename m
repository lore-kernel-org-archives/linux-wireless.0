Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62942 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZKIDFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 22:05:37 -0500
Received: by ewy3 with SMTP id 3so2746807ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 19:05:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257735542-29658-1-git-send-email-me@bobcopeland.com>
References: <1257735542-29658-1-git-send-email-me@bobcopeland.com>
Date: Mon, 9 Nov 2009 05:05:42 +0200
Message-ID: <40f31dec0911081905o6425795fxb5a6a1ba25bdc7f5@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath5k: don't reset mcast filter when configuring the
	mode
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/9 Bob Copeland <me@bobcopeland.com>:
> We should not zero out the multicast hash when configuring
> the operating mode, since a zero value means all multicast
> frames will get dropped.  Also, ath5k_mode_setup() gets
> called after any reset, so the hash already set up in
> configure_filter() is lost.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 07c1e52..cb3dc89 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1146,7 +1146,6 @@ ath5k_mode_setup(struct ath5k_softc *sc)
>        /* configure operational mode */
>        ath5k_hw_set_opmode(ah);
>
> -       ath5k_hw_set_mcast_filter(ah, 0, 0);
>        ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
>  }
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
