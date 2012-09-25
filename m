Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41996 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2IYTds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 15:33:48 -0400
Received: by oagh16 with SMTP id h16so652141oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2012 12:33:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348511419-11881-1-git-send-email-linville@tuxdriver.com>
References: <1348511419-11881-1-git-send-email-linville@tuxdriver.com>
Date: Tue, 25 Sep 2012 22:33:47 +0300
Message-ID: <CAFtRNNzCFHe43iCn7G9h-4tjGhWCPpG3ProXnM-zdiDt8h4M2g@mail.gmail.com> (sfid-20120925_213411_025448_2BB68F7D)
Subject: Re: [PATCH] ath5k: add missing breaks in ath5k_hw_set_spur_mitigation_filter
From: Nick Kossifidis <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	David Binderman <dcb314@hotmail.com>, me@bobcopeland.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/24 John W. Linville <linville@tuxdriver.com>:
> From: "John W. Linville" <linville@tuxdriver.com>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=47681
>
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 8b71a2d..d605217 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1975,11 +1975,13 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
>                         spur_delta_phase = (spur_offset << 18) / 25;
>                         spur_freq_sigma_delta = (spur_delta_phase >> 10);
>                         symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 2;
> +                       break;
>                 case AR5K_BWMODE_5MHZ:
>                         /* Both sample_freq and chip_freq are 10MHz (?) */
>                         spur_delta_phase = (spur_offset << 19) / 25;
>                         spur_freq_sigma_delta = (spur_delta_phase >> 10);
>                         symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 4;
> +                       break;
>                 default:
>                         if (channel->band == IEEE80211_BAND_5GHZ) {
>                                 /* Both sample_freq and chip_freq are 40MHz */
> --
> 1.7.11.4
>

The idea is that we don't know if these settings for half/quarter rate
channels even work (that's why I've put the question marks there), I
just put them there so that others can see them / test them and report
back (mostly people working on 802.11p with ath5k). Without the breaks
it always uses the default witch is what we have from HAL sources.

Anyway I guess enabling them will result more testing and if something
breaks we 'll hear from the 802.11p people soon, so


Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
