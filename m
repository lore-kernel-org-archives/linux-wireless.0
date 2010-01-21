Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53095 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0AUL36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 06:29:58 -0500
Received: by ewy19 with SMTP id 19so2272981ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 03:29:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264049464-12292-2-git-send-email-me@bobcopeland.com>
References: <1264049464-12292-1-git-send-email-me@bobcopeland.com>
	 <1264049464-12292-2-git-send-email-me@bobcopeland.com>
Date: Thu, 21 Jan 2010 13:29:56 +0200
Message-ID: <40f31dec1001210329i699dac4k2b1488f06638ccc4@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath5k: dont use external sleep clock in AP mode
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/21 Bob Copeland <me@bobcopeland.com>:
> When using the external sleep clock in AP mode, the
> TSF increments too quickly, causing beacon interval
> to be much lower than it is supposed to be, resulting
> in lots of beacon-not-ready interrupts.
>
> This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14802.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/reset.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index 6690923..a35a7db 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -1374,8 +1374,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>         * Set clocks to 32KHz operation and use an
>         * external 32KHz crystal when sleeping if one
>         * exists */
> -       if (ah->ah_version == AR5K_AR5212)
> -                       ath5k_hw_set_sleep_clock(ah, true);
> +       if (ah->ah_version == AR5K_AR5212 &&
> +           ah->ah_op_mode != NL80211_IFTYPE_AP)
> +               ath5k_hw_set_sleep_clock(ah, true);
>
>        /*
>         * Disable beacons and reset the register

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
