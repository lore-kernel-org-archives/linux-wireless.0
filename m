Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:44839 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbeDLLqt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 07:46:49 -0400
Received: by mail-ot0-f181.google.com with SMTP id p33-v6so5605566otp.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 04:46:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180412111311.28809-1-daniel@zonque.org>
References: <20180412111311.28809-1-daniel@zonque.org>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Thu, 12 Apr 2018 13:46:07 +0200
Message-ID: <CAMZdPi98WH59nxV08wHcyAoDB06T3ptNT=E9C8S6RK_Yg1pKnQ@mail.gmail.com> (sfid-20180412_134652_854264_0E554EA2)
Subject: Re: [PATCH] wcn36xx: pass correct BSS index when deleting BSS keys
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> @@ -564,10 +565,13 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>                 break;
>         case DISABLE_KEY:
>                 if (!(IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags)) {
> +                       if (vif_priv->bss_index != WCN36XX_HAL_BSS_INVALID_IDX)
> +                               wcn36xx_smd_remove_bsskey(wcn,
> +                                       vif_priv->encrypt_type,
> +                                       vif_priv->bss_index,
> +                                       key_conf->keyidx);
> +
>                         vif_priv->encrypt_type = WCN36XX_HAL_ED_NONE;
> -                       wcn36xx_smd_remove_bsskey(wcn,
> -                               vif_priv->encrypt_type,
> -                               key_conf->keyidx);

Note that moving vif_priv->encrypt_type = WCN36XX_HAL_ED_NONE after
key removal also fixes an issue I observed in AP mode:
wcn36xx: ERROR hal_remove_bsskey response failed err=6

Indeed, trying to remove a key with non-matching encrypt type fails,
keeping the right encrypt_type for removal fixes the issue.

Patch looks good.

Regards,
Loic
