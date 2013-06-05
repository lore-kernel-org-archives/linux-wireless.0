Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37544 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3FEOsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:48:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <ordex@autistici.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCHv3 3/4] ath6kl: make mgmt_tx accept a NULL channel
References: <1370442893-1687-1-git-send-email-ordex@autistici.org>
	<1370442893-1687-3-git-send-email-ordex@autistici.org>
Date: Wed, 5 Jun 2013 17:48:15 +0300
In-Reply-To: <1370442893-1687-3-git-send-email-ordex@autistici.org> (Antonio
	Quartulli's message of "Wed, 5 Jun 2013 16:34:52 +0200")
Message-ID: <87r4ggy5ow.fsf@kamboji.qca.qualcomm.com> (sfid-20130605_164824_954842_41B45A91)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <ordex@autistici.org> writes:

> From: Antonio Quartulli <antonio@open-mesh.com>
>
> cfg80211 passes a NULL channel to mgmt_tx if the frame has
> to be sent on the one currently in use by the device.
> Make the implementation of mgmt_tx correctly handle this
> case
>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>

[...]

> @@ -3175,10 +3175,17 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>  {
>  	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
>  	struct ath6kl *ar = ath6kl_priv(vif->ndev);
> -	u32 id;
> +	u32 id, freq;
>  	const struct ieee80211_mgmt *mgmt;
>  	bool more_data, queued;
>  
> +	/* default to the current channel, but use the one specified as argument
> +	 * if any
> +	 */
> +	freq = vif->ch_hint;
> +	if (chan)
> +		freq = chan->center_freq;

Can you please add a check here:

if (WARN_ON(chan == 0))
   return -EINVAL;

Just like Arend, I want to be sure that we don't submit value 0 to the
firmware.

-- 
Kalle Valo
