Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64196 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab2CPSAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 14:00:07 -0400
Received: by yenl12 with SMTP id l12so4447400yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2012 11:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120314223433.410AD9D401E@zog.reactivated.net>
References: <20120314223433.410AD9D401E@zog.reactivated.net>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Fri, 16 Mar 2012 20:59:46 +0300
Message-ID: <CA+E=qVc7Y0kLQ-Xj8V_E67Ut3YkA0JuRT1pZ2F-hEGu6rjjGCg@mail.gmail.com> (sfid-20120316_190016_038686_8AD03C5C)
Subject: Re: [PATCH] libertas: remove dump_survey implementation
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, dcbw@redhat.com, nbd@openwrt.org,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	dilinger@queued.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/3/15 Daniel Drake <dsd@laptop.org>:
> libertas provides a dump_survey implementation based on reading of
> a RSSI value. However, this RSSI value is calculated based on the
> last received beacon from the associated AP - it is not a good
> way of surveying a channel in general, and even causes an error
> if the card is not associated to a network.
>
> As this is not appropriate as a survey, remove it. This fixes an
> issue where something in userspace is repeatedly calling site-survey
> during boot, resulting in many repeated errors as the RSSI value cannot
> be read before associating.
>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

I have pretty similar patch and tested it on Zipit Z2 with libertas_spi.
What's interesting -- wpa_supplicant with -Dwext does not trigger this bug, but
only with -Dnl80211 it does.

Have my:

Tested-by: Vasily Khoruzhick <anarsoul@gmail.com>

> ---
>  drivers/net/wireless/libertas/cfg.c |   34 ----------------------------------
>  1 files changed, 0 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index b456a53..8ea15d3 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -1593,39 +1593,6 @@ static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
>
>
>  /*
> - * "Site survey", here just current channel and noise level
> - */
> -
> -static int lbs_get_survey(struct wiphy *wiphy, struct net_device *dev,
> -       int idx, struct survey_info *survey)
> -{
> -       struct lbs_private *priv = wiphy_priv(wiphy);
> -       s8 signal, noise;
> -       int ret;
> -
> -       if (idx != 0)
> -               ret = -ENOENT;
> -
> -       lbs_deb_enter(LBS_DEB_CFG80211);
> -
> -       survey->channel = ieee80211_get_channel(wiphy,
> -               ieee80211_channel_to_frequency(priv->channel,
> -                                              IEEE80211_BAND_2GHZ));
> -
> -       ret = lbs_get_rssi(priv, &signal, &noise);
> -       if (ret == 0) {
> -               survey->filled = SURVEY_INFO_NOISE_DBM;
> -               survey->noise = noise;
> -       }
> -
> -       lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
> -       return ret;
> -}
> -
> -
> -
> -
> -/*
>  * Change interface
>  */
>
> @@ -2024,7 +1991,6 @@ static struct cfg80211_ops lbs_cfg80211_ops = {
>        .del_key = lbs_cfg_del_key,
>        .set_default_key = lbs_cfg_set_default_key,
>        .get_station = lbs_cfg_get_station,
> -       .dump_survey = lbs_get_survey,
>        .change_virtual_intf = lbs_change_intf,
>        .join_ibss = lbs_join_ibss,
>        .leave_ibss = lbs_leave_ibss,
> --
> 1.7.7.6
>
>
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
