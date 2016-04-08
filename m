Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36091 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbcDHBlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 21:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <5686C47E.1040906@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net> <5686C390.5060600@users.sourceforge.net>
 <5686C47E.1040906@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 8 Apr 2016 11:40:45 +1000
Message-ID: <CAGRGNgXR_OoER0rN5Z8n_5VtZimpU7WDNZuc4vkdb2eKDT2frQ@mail.gmail.com> (sfid-20160408_034143_957726_2663F648)
Subject: Re: [PATCH 2/2] net-ath9k_htc: Replace a variable initialisation by
 an assignment in ath9k_htc_set_channel()
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	SF Markus Elfring <elfring@users.sourceforge.net>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Sat, Jan 2, 2016 at 5:25 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 1 Jan 2016 19:09:32 +0100
>
> Replace an explicit initialisation for one local variable at the beginning
> by a conditional assignment.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

This looks sane to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

Julian Calaby

> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index a680a97..30bd59e 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -246,7 +246,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
>         struct ieee80211_conf *conf = &common->hw->conf;
>         bool fastcc;
>         struct ieee80211_channel *channel = hw->conf.chandef.chan;
> -       struct ath9k_hw_cal_data *caldata = NULL;
> +       struct ath9k_hw_cal_data *caldata;
>         enum htc_phymode mode;
>         __be16 htc_mode;
>         u8 cmd_rsp;
> @@ -274,10 +274,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
>                 priv->ah->curchan->channel,
>                 channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf),
>                 fastcc);
> -
> -       if (!fastcc)
> -               caldata = &priv->caldata;
> -
> +       caldata = fastcc ? NULL : &priv->caldata;
>         ret = ath9k_hw_reset(ah, hchan, caldata, fastcc);
>         if (ret) {
>                 ath_err(common,
> --
> 2.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
