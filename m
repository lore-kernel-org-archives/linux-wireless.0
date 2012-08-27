Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58176 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2H0FRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 01:17:30 -0400
Received: by obbuo13 with SMTP id uo13so7467937obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2012 22:17:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346014505-7554-1-git-send-email-ordex@autistici.org>
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
Date: Mon, 27 Aug 2012 10:47:29 +0530
Message-ID: <CAD2nsn16-uZ0CbBXrHjUS2Rwn53OYNrLvjujmPAwGDCEbdYJxg@mail.gmail.com> (sfid-20120827_071734_571193_31F171E7)
Subject: Re: [PATCHv2 1/2] ath9k_htc: remove driver specific checks for
 interfaces combinations
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Aug 27, 2012 at 2:25 AM, Antonio Quartulli <ordex@autistici.org> wrote:
> Thanks to the new interface combinations code we can safely remove all the
> driver specific checks for unsupported modes.

i had just sent this some time back
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/96443.

please review if something had to be changed.

>
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>
> ---
>
> this patch if v2 of "ath9k_htc: allow coexistence of IBSS with other modes". Now
> it is more generic.
>
>
>
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 20 --------------------
>  1 file changed, 20 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index c32f6e3..51c69f2 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -1040,26 +1040,6 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
>
>         mutex_lock(&priv->mutex);
>
> -       if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
> -               mutex_unlock(&priv->mutex);
> -               return -ENOBUFS;
> -       }
> -
> -       if (priv->num_ibss_vif ||
> -           (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
> -               ath_err(common, "IBSS coexistence with other modes is not allowed\n");
> -               mutex_unlock(&priv->mutex);
> -               return -ENOBUFS;
> -       }
> -
> -       if (((vif->type == NL80211_IFTYPE_AP) ||
> -            (vif->type == NL80211_IFTYPE_ADHOC)) &&
> -           ((priv->num_ap_vif + priv->num_ibss_vif) >= ATH9K_HTC_MAX_BCN_VIF)) {
> -               ath_err(common, "Max. number of beaconing interfaces reached\n");
> -               mutex_unlock(&priv->mutex);
> -               return -ENOBUFS;
> -       }
> -
>         ath9k_htc_ps_wakeup(priv);
>         memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
>         memcpy(&hvif.myaddr, vif->addr, ETH_ALEN);
> --
> 1.7.12
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
