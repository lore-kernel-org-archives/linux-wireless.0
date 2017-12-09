Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38435 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdLIAph (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 19:45:37 -0500
Received: by mail-pg0-f66.google.com with SMTP id f12so7916266pgo.5
        for <linux-wireless@vger.kernel.org>; Fri, 08 Dec 2017 16:45:37 -0800 (PST)
Date: Fri, 8 Dec 2017 16:45:34 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        nicolas.dechesne@linaro.org, k.eugene.e@gmail.com
Subject: Re: [PATCH] wcn36xx: Fix dynamic power saving
Message-ID: <20171209004534.GB3441@builder> (sfid-20171209_014543_865293_C25AF5C2)
References: <1512750846-13591-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512750846-13591-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri 08 Dec 08:34 PST 2017, Loic Poulain wrote:

> Since driver does not report hardware dynamic power saving cap,
> this is up to the mac80211 to manage power saving timeout and
> state machine, using the ieee80211 config callback to report
> PS changes. This patch enables/disables PS mode according to
> the new configuration.
> 
> Remove old behaviour enabling PS mode in a static way, this make
> the device unusable when power save is enabled since device is
> forced to PS regardless RX/TX traffic.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>

With below nit.

> ---
>  drivers/net/wireless/ath/wcn36xx/main.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index f0b4d43..436b8ea 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -384,6 +384,18 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
>  		}
>  	}
>  
> +	if (changed & IEEE80211_CONF_CHANGE_PS) {
> +		list_for_each_entry(tmp, &wcn->vif_list, list) {
> +			vif = wcn36xx_priv_to_vif(tmp);
> +			if (hw->conf.flags & IEEE80211_CONF_PS) {
> +				if (vif->bss_conf.ps) /* ps allowed ? */
> +					wcn36xx_pmc_enter_bmps_state(wcn, vif);
> +			} else {
> +				wcn36xx_pmc_exit_bmps_state(wcn, vif);

During startup I get the error print from wcn36xx_pmc_exit_bmps_state()
that we're not in BMPS state. There's no harm in this, but the error
might concern people.

How about we in addition to this, change the wcn36xx_err() to a
wcn36xx_dbg(PMC...) ?

Regards,
Bjorn
