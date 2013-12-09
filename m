Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:40303 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3LIHXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 02:23:08 -0500
Received: by mail-ve0-f181.google.com with SMTP id oy12so3200578veb.26
        for <linux-wireless@vger.kernel.org>; Sun, 08 Dec 2013 23:23:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386300482-3352-1-git-send-email-yeohchunyeow@gmail.com>
References: <1386300482-3352-1-git-send-email-yeohchunyeow@gmail.com>
Date: Mon, 9 Dec 2013 07:23:07 +0000
Message-ID: <CAFSJ42bGVnSZfMdHdOJCSVRaAkMB52poJVrAPy1wUx-+2AaYhg@mail.gmail.com> (sfid-20131209_082344_628908_D3B4CE58)
Subject: Re: [PATCH] wcn36xx: enable the beaconing in mesh mode
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good to me.

On Fri, Dec 6, 2013 at 3:28 AM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Enable the beaconing in wnc36xx by tweaking the tim offset and
> force the use of AP-style beaconing. Otherwise, beaconing is not
> working. The tim offset is set to 256. Otherwise, this will
> overwrite mesh beacon submitted by mac80211.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index f8c3a10..19f43de 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -1134,14 +1134,14 @@ int wcn36xx_smd_config_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif,
>                 /* STA */
>                 bss->oper_mode = 1;
>                 bss->wcn36xx_hal_persona = WCN36XX_HAL_STA_MODE;
> -       } else if (vif->type == NL80211_IFTYPE_AP) {
> +       } else if (vif->type == NL80211_IFTYPE_AP ||
> +                  vif->type == NL80211_IFTYPE_MESH_POINT) {
>                 bss->bss_type = WCN36XX_HAL_INFRA_AP_MODE;
>
>                 /* AP */
>                 bss->oper_mode = 0;
>                 bss->wcn36xx_hal_persona = WCN36XX_HAL_STA_SAP_MODE;
> -       } else if (vif->type == NL80211_IFTYPE_ADHOC ||
> -                  vif->type == NL80211_IFTYPE_MESH_POINT) {
> +       } else if (vif->type == NL80211_IFTYPE_ADHOC) {
>                 bss->bss_type = WCN36XX_HAL_IBSS_MODE;
>
>                 /* STA */
> @@ -1291,7 +1291,11 @@ int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
>         memcpy(msg_body.bssid, vif->addr, ETH_ALEN);
>
>         /* TODO need to find out why this is needed? */
> -       msg_body.tim_ie_offset = tim_off+4;
> +       if (vif->type == NL80211_IFTYPE_MESH_POINT)
> +               /* mesh beacon don't need this, so push further down */
> +               msg_body.tim_ie_offset = 256;
> +       else
> +               msg_body.tim_ie_offset = tim_off+4;
>         msg_body.p2p_ie_offset = p2p_off;
>         PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
Eugene
