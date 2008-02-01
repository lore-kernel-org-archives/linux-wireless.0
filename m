Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:41801 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYBALnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 06:43:37 -0500
Received: by wa-out-1112.google.com with SMTP id v27so630975wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 03:43:36 -0800 (PST)
Message-ID: <1ba2fa240802010343q519a1dap9d4af5ef5e0110f2@mail.gmail.com> (sfid-20080201_114341_352497_1A979335)
Date: Fri, 1 Feb 2008 13:43:36 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Reinette Chatre" <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/2] iwlwifi: set rate_idx correctly from plcp
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <1201844801-7326-2-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1201844801-7326-1-git-send-email-reinette.chatre@intel.com>
	 <1201844801-7326-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 7:46 AM, Reinette Chatre <reinette.chatre@intel.com> wrote:
> From: Mohamed Abbas <mohamed.abbas@intel.com>
>
> rate_idx is derived from plcp information
>
> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index 79545d6..29797db 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -3546,7 +3546,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
>                         (rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
>                         IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ,
>                 .antenna = 0,
> -               .rate_idx = iwl4965_hw_get_rate(
> +               .rate_idx = iwl4965_rate_index_from_plcp(
>                                 le32_to_cpu(rx_start->rate_n_flags)),
>                 .flag = 0,
>         };
> --
> 1.5.3.4
>

NACK
This should be
rate_idx = iwl4965_rate_index_from_plcp(wl4965_hw_get_rate(rx_start->rate_n_flags));

iwl4965_hw_get_rate - this one extract plcp from rate_n_flags - also
takes care of endinaity
Tomas


>
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
