Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33115 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbbC0Itk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 04:49:40 -0400
Received: by ignm3 with SMTP id m3so28232528ign.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2015 01:49:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427444516-974-2-git-send-email-michal.kazior@tieto.com>
References: <1427444516-974-1-git-send-email-michal.kazior@tieto.com>
	<1427444516-974-2-git-send-email-michal.kazior@tieto.com>
Date: Fri, 27 Mar 2015 09:49:40 +0100
Message-ID: <CACKGw+H2f_pjHnA+ZE0eSOWVZVLzafkOW9YcmmYPpTh9nEiZmA@mail.gmail.com> (sfid-20150327_094946_370388_566147C6)
Subject: Re: [PATCH 2/2] ath10k: fix static wep with more than 1 key in client mode
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 March 2015 at 09:21, Michal Kazior <michal.kazior@tieto.com> wrote:
> The default keyidx callback may be called after
> more than 1 key is installed. This led to only 1
> WEP key being reinstalled only. This caused Rxed
> traffic encrypted with other WEP keys to be
> dropped in client mode.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Tested-by: Bartosz Markowski <bartosz.markowski@tieto.com>

> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 45 +++++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 9d873900257d..3baea2b671dd 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -259,41 +259,44 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
>         return first_errno;
>  }
>
> -static int ath10k_mac_vif_sta_fix_wep_key(struct ath10k_vif *arvif)
> +static int ath10k_mac_vif_sta_fix_wep_key(struct ath10k_vif *arvif, int keyidx)
>  {
>         struct ath10k *ar = arvif->ar;
>         enum nl80211_iftype iftype = arvif->vif->type;
>         struct ieee80211_key_conf *key;
> -       u32 flags = 0;
> -       int num = 0;
> -       int i;
> +       u32 flags;
>         int ret;
> +       int i;
>
>         lockdep_assert_held(&ar->conf_mutex);
>
>         if (iftype != NL80211_IFTYPE_STATION)
>                 return 0;
>
> +       if (keyidx < 0)
> +               return 0;
> +
>         for (i = 0; i < ARRAY_SIZE(arvif->wep_keys); i++) {
> -               if (arvif->wep_keys[i]) {
> -                       key = arvif->wep_keys[i];
> -                       ++num;
> +               if (!arvif->wep_keys[i])
> +                       continue;
> +
> +               key = arvif->wep_keys[i];
> +
> +               flags = 0;
> +               flags |= WMI_KEY_PAIRWISE;
> +
> +               if (key->keyidx == keyidx)
> +                       flags |= WMI_KEY_TX_USAGE;
> +
> +               ret = ath10k_install_key(arvif, key, SET_KEY, arvif->bssid,
> +                                        flags);
> +               if (ret) {
> +                       ath10k_warn(ar, "failed to install key %i on vdev %i: %d\n",
> +                                   key->keyidx, arvif->vdev_id, ret);
> +                       return ret;
>                 }
>         }
>
> -       if (num != 1)
> -               return 0;
> -
> -       flags |= WMI_KEY_PAIRWISE;
> -       flags |= WMI_KEY_TX_USAGE;
> -
> -       ret = ath10k_install_key(arvif, key, SET_KEY, arvif->bssid, flags);
> -       if (ret) {
> -               ath10k_warn(ar, "failed to install key %i on vdev %i: %d\n",
> -                           key->keyidx, arvif->vdev_id, ret);
> -               return ret;
> -       }
> -
>         return 0;
>  }
>
> @@ -4227,7 +4230,7 @@ static void ath10k_set_default_unicast_key(struct ieee80211_hw *hw,
>
>         arvif->def_wep_key_idx = keyidx;
>
> -       ret = ath10k_mac_vif_sta_fix_wep_key(arvif);
> +       ret = ath10k_mac_vif_sta_fix_wep_key(arvif, keyidx);
>         if (ret) {
>                 ath10k_warn(ar, "failed to fix sta wep key on vdev %i: %d\n",
>                             arvif->vdev_id, ret);
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Bartosz
