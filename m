Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46883 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3I3TKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 15:10:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] ath10k: split vdev_id calculation from tx function
References: <1380292706-3609-1-git-send-email-michal.kazior@tieto.com>
	<1380292706-3609-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 30 Sep 2013 22:10:30 +0300
In-Reply-To: <1380292706-3609-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 27 Sep 2013 16:38:24 +0200")
Message-ID: <87mwmudt21.fsf@kamboji.qca.qualcomm.com> (sfid-20130930_211040_196847_454623EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Empty commit log.

> ---
>  drivers/net/wireless/ath/ath10k/mac.c |   25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 7415a60..4b7c949 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -1421,6 +1421,19 @@ static u8 ath10k_tx_h_get_tid(struct ieee80211_hdr *hdr)
>  	return ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
>  }
>  
> +static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
> +				  struct ieee80211_tx_info *info)
> +{
> +	if (info->control.vif)
> +		return ath10k_vif_to_arvif(info->control.vif)->vdev_id;
> +
> +	if (ar->monitor_enabled)
> +		return ar->monitor_vdev_id;
> +
> +	ath10k_warn("could not resolve vdev id\n");
> +	return 0;
> +}

Empty line before return would be nice.

-- 
Kalle Valo
