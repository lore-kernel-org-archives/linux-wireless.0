Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57287 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1BHVWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 16:22:40 -0500
Received: by iwn9 with SMTP id 9so6182936iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 13:22:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297093108-28541-1-git-send-email-mshajakhan@atheros.com>
References: <1297093108-28541-1-git-send-email-mshajakhan@atheros.com>
Date: Tue, 8 Feb 2011 22:22:39 +0100
Message-ID: <AANLkTimXCXW8mT8tPbSuCDpwyyD=NSRyBvFcC2Y+Nq7N@mail.gmail.com>
Subject: Re: [PATCH 1/1] ath9k: Update comments for not parsing DTIM period
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 7, 2011 at 4:38 PM, Mohammed Shafi Shajakhan
<mshajakhan@atheros.com> wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>
> Add few comments for not parsing DTIM period from mac80211
>
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/beacon.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> index 87ba44c..fcb36ab 100644
> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -721,8 +721,9 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
>                cur_conf->beacon_interval = 100;
>
>        /*
> -        * Some times we dont parse dtim period from mac80211, in that case
> -        * use a default value
> +        * We don't parse dtim period from mac80211 during the driver
> +        * initialization as it breaks association with hidden-ssid
> +        * AP and it causes latency in roaming
>         */
>        if (cur_conf->dtim_period == 0)
>                cur_conf->dtim_period = 1;

I realize I'm not the perfect representative for the intended audience
but I don't understand that comment at all. The previous one made
sense to me, but the new one seems to refer to some logic somewhere
else. In ath_beacon_config() I expect AP/IBSS logic but the comment
seems to be about some special case for a STA vif associating with a
hidden access point, no? I don't understand that special case either
but that is more easily attributable to ignorance. :)

Best regards,

Björn
