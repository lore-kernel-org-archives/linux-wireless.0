Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50370 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0G1TKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 15:10:38 -0400
Received: by wwj40 with SMTP id 40so2791140wwj.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 12:10:36 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ar9170: add get_survey callback in order to get channel noise
Date: Wed, 28 Jul 2010 21:10:31 +0200
Cc: linux-wireless@vger.kernel.org
References: <1280342924-22811-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1280342924-22811-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201007282110.31458.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 July 2010 20:48:44 John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ar9170/main.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index 5e2c514..e089d9f 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -1905,6 +1905,22 @@ static int ar9170_get_stats(struct ieee80211_hw *hw,
>  	return 0;
>  }
>  
> +static int ar9170_get_survey(struct ieee80211_hw *hw, int idx,
> +				struct survey_info *survey)
> +{
> +	struct ar9170 *ar = hw->priv;
> +	struct ieee80211_conf *conf = &hw->conf;
> +
> +	if (idx != 0)
> +		return -ENOENT;
> +
> +	survey->channel = conf->channel;
> +	survey->filled = SURVEY_INFO_NOISE_DBM;
> +	survey->noise = ar->noise[0];
> +
> +	return 0;
> +}
> +
>  static int ar9170_conf_tx(struct ieee80211_hw *hw, u16 queue,
>  			  const struct ieee80211_tx_queue_params *param)
>  {
> @@ -1957,6 +1973,7 @@ static const struct ieee80211_ops ar9170_ops = {
>  	.get_tsf		= ar9170_op_get_tsf,
>  	.set_key		= ar9170_set_key,
>  	.get_stats		= ar9170_get_stats,
> +	.get_survey		= ar9170_get_survey,
>  	.ampdu_action		= ar9170_ampdu_action,
>  };

One problem: the noisefloor stays at the same level and
is not updated. You would have to call ar9170_set_channel,
but I don't recommend that because that may lockup
the device :(.

Regards,
	Chr
