Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:29960 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934292AbYBBUkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 15:40:40 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1717030wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 12:40:37 -0800 (PST)
Message-ID: <1ba2fa240802021240h56f5f9f7ueb7e0fa3e8524231@mail.gmail.com> (sfid-20080202_204103_701088_EE3801BA)
Date: Sat, 2 Feb 2008 22:40:37 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Roel Kluin" <12o3l@tiscali.nl>
Subject: Re: [PATCH] [wireless/iwlwifi/iwl-4965.c] add parentheses
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	lkml <linux-kernel@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <47A4C920.4090202@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47A4C920.4090202@tiscali.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 2, 2008 9:48 PM, Roel Kluin <12o3l@tiscali.nl> wrote:
> '!' has a higher priority than '&': bitanding has no effect.
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index 569347f..2439868 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -4589,7 +4589,7 @@ static u8 iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
>
>         if (sta_ht_inf) {
>                 if ((!sta_ht_inf->ht_supported) ||
> -                  (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
> +                  (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
>                         return 0;
>         }
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

ACK
