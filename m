Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:51472 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0LSDPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 22:15:48 -0500
Received: by pxi20 with SMTP id 20so504518pxi.10
        for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 19:15:47 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19725.30879.711426.630171@gargle.gargle.HOWL>
Date: Sun, 19 Dec 2010 08:44:39 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	m.sujith@gmail.com
Subject: [PATCH 2/2] ath9k_htc: Fix unnecessary warnings on card removal
In-Reply-To: <1292664547-5474-1-git-send-email-rmanoharan@atheros.com>
References: <1292664547-5474-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index fdf9d5f..d90838a 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -339,7 +339,6 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
>  #define OP_ASSOCIATED		   BIT(7)
>  #define OP_ENABLE_BEACON	   BIT(8)
>  #define OP_LED_DEINIT		   BIT(9)
> -#define OP_UNPLUGGED		   BIT(10)
>  #define OP_BT_PRIORITY_DETECTED	   BIT(11)
>  #define OP_BT_SCAN		   BIT(12)

You are leaving a hole here.

> @@ -1231,6 +1236,12 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
>  	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
>  	ath9k_led_stop_brightness(priv);
>  
> +	if (ah->ah_flags & AH_UNPLUGGED) {
> +		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
> +		mutex_unlock(&priv->mutex);
> +		return;
> +	}
> +

This doesn't take of purging the TX queues in both the driver layer and HIF.
Also, in case of BT combo devices, the workqueue instances aren't canceled.

Instead of adding such checks throughout the driver and increasing code size,
we can just fix the warning to handle the unplugged case. It doesn't matter
if a few extra hardware calls are made, the device is no longer present anyway. :)

Sujith
