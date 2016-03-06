Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:32771 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbcCFGyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 01:54:10 -0500
Received: by mail-lb0-f179.google.com with SMTP id k15so100477572lbg.0
        for <linux-wireless@vger.kernel.org>; Sat, 05 Mar 2016 22:54:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456521282-69932-1-git-send-email-nbd@openwrt.org>
References: <1456521282-69932-1-git-send-email-nbd@openwrt.org>
Date: Sun, 6 Mar 2016 08:54:08 +0200
Message-ID: <CANUX_P1dj1x9WPWuBvDs8eyFCDL5iJUJM+5+_=KR4kDLaxHXgA@mail.gmail.com> (sfid-20160306_075415_431168_A0DEBF89)
Subject: Re: [PATCH] mac80211: remove wdev/vif conversion functions
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 26, 2016 at 11:14 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Nothing uses them

Correction: nothing *upstream* uses them *yet*. We have code that will use them.
wdev_to_ieee80211_vif was added by:

commit ad7e718c9b4f717823fd920a0103f7b0fb06183f
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Nov 13 13:37:47 2013 +0100

    nl80211: vendor command support


Which by design was meant to provide a pipe that may not be upstream
(at least not immediately).

>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/net/mac80211.h | 26 --------------------------
>  net/mac80211/util.c    | 28 ----------------------------
>  2 files changed, 54 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 0c09da3..e11d751 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1439,32 +1439,6 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
>  }
>
>  /**
> - * wdev_to_ieee80211_vif - return a vif struct from a wdev
> - * @wdev: the wdev to get the vif for
> - *
> - * This can be used by mac80211 drivers with direct cfg80211 APIs
> - * (like the vendor commands) that get a wdev.
> - *
> - * Note that this function may return %NULL if the given wdev isn't
> - * associated with a vif that the driver knows about (e.g. monitor
> - * or AP_VLAN interfaces.)
> - */
> -struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
> -
> -/**
> - * ieee80211_vif_to_wdev - return a wdev struct from a vif
> - * @vif: the vif to get the wdev for
> - *
> - * This can be used by mac80211 drivers with direct cfg80211 APIs
> - * (like the vendor commands) that needs to get the wdev for a vif.
> - *
> - * Note that this function may return %NULL if the given wdev isn't
> - * associated with a vif that the driver knows about (e.g. monitor
> - * or AP_VLAN interfaces.)
> - */
> -struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif);
> -
> -/**
>   * enum ieee80211_key_flags - key flags
>   *
>   * These flags are used for communication about keys between the driver
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 89f7179..4482625 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -694,34 +694,6 @@ void ieee80211_iterate_stations_atomic(struct ieee80211_hw *hw,
>  }
>  EXPORT_SYMBOL_GPL(ieee80211_iterate_stations_atomic);
>
> -struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev)
> -{
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
> -
> -       if (!ieee80211_sdata_running(sdata) ||
> -           !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
> -               return NULL;
> -       return &sdata->vif;
> -}
> -EXPORT_SYMBOL_GPL(wdev_to_ieee80211_vif);
> -
> -struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif)
> -{
> -       struct ieee80211_sub_if_data *sdata;
> -
> -       if (!vif)
> -               return NULL;
> -
> -       sdata = vif_to_sdata(vif);
> -
> -       if (!ieee80211_sdata_running(sdata) ||
> -           !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
> -               return NULL;
> -
> -       return &sdata->wdev;
> -}
> -EXPORT_SYMBOL_GPL(ieee80211_vif_to_wdev);
> -
>  /*
>   * Nothing should have been stuffed into the workqueue during
>   * the suspend->resume cycle. Since we can't check each caller
> --
> 2.2.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
