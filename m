Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:33850 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0LQTwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:52:12 -0500
Received: by iwn42 with SMTP id 42so512581iwn.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 11:52:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292598876-8242-1-git-send-email-mshajakhan@atheros.com>
References: <1292598876-8242-1-git-send-email-mshajakhan@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 17 Dec 2010 11:51:50 -0800
Message-ID: <AANLkTiky2ODWt-ocSy_+=9k9_E=7ekvLMLbQtir-cd-r@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Properly initialize channel table for 2GHz
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 7:14 AM, Mohammed Shafi Shajakhan
<mshajakhan@atheros.com> wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>
> ath9k channel table for 2Ghz does not seems to initialize the 'band'
> parameter.Though it does not seems to cause any visible issue it looks
> odd when we initialize the 'band' parameter for 5Ghz channel table while
> not so for 2Ghz.
>
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/init.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 1238795..b0e5e71 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -48,6 +48,7 @@ MODULE_PARM_DESC(pmqos, "User specified PM-QOS value");
>  /* We use the hw_value as an index into our private channel structure */
>
>  #define CHAN2G(_freq, _idx)  { \
> +       .band = IEEE80211_BAND_2GHZ, \
>        .center_freq = (_freq), \
>        .hw_value = (_idx), \
>        .max_power = 20, \

That's fine but its not needed at all as the band is already
kzalloc()'d so it gets zeroed out and the IEEE80211_BAND_2GHZ enum is
0, so its not required to be explicit and set it. But if it gives you
the warm fuzzies sure.

  Luis
