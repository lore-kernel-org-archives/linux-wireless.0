Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:59581 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYAIASM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 19:18:12 -0500
Received: by wa-out-1112.google.com with SMTP id v27so43262wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2008 16:18:11 -0800 (PST)
Message-ID: <1ba2fa240801081618u1ba01720rbd89a4c4b8d80a8c@mail.gmail.com> (sfid-20080109_001818_446102_E7A066A6)
Date: Wed, 9 Jan 2008 02:18:11 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH v2] mac80211: Add radio led trigger
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801071945.24793.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200801061410.12862.IvDoorn@gmail.com>
	 <200801071945.24793.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 7, 2008 8:45 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Some devices have a seperate LED which indicates if the radio is
> enabled or not. This adds a LED trigger to mac80211 where drivers
> can hook into when they are interested in radio status changes.
>
> v2: Check hw.conf.radio_enabled when calling start().
>
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>
> ---
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 1d3d4f3..42499f6 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1173,6 +1173,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw);
>  extern char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
>  extern char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
>  extern char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw);
> +extern char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw);
>  #endif
>  /**
>   * ieee80211_get_tx_led_name - get name of TX LED
> @@ -1212,6 +1213,16 @@ static inline char *ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
>  #endif
>  }
>
> @@ -651,6 +652,7 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
>         if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
>                 local->hw.conf.radio_enabled = !(data->txpower.disabled);
>                 need_reconfig = 1;
> +               ieee80211_led_radio(local, local->hw.conf.radio_enabled);

Not sure but isn't it cleaner to push it to ieee80211_hw_config().
This will cover also ieee80211_open and maybe in the future also
cfg80211
Will it be so bad to call led_radio even the led is already lit?

Thanks
Tomas
