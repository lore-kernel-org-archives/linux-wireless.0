Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12390 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab0GND2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 23:28:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jul 2010 20:28:33 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19517.12171.792656.215696@gargle.gargle.HOWL>
Date: Wed, 14 Jul 2010 09:01:23 +0530
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k_htc: implement mac80211 flush op
In-Reply-To: <1279070845-29442-3-git-send-email-lrodriguez@atheros.com>
References: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
	<1279070845-29442-3-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> This implements the mac80211 flush callback to let mac80211
> flush the hardware queues when it deems appropriate.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index e38ca66..fc234a7 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -1803,6 +1803,29 @@ static void ath9k_htc_set_coverage_class(struct ieee80211_hw *hw,
>  	mutex_unlock(&priv->mutex);
>  }
>  
> +static void ath9k_htc_flush(struct ieee80211_hw *hw, bool drop)
> +{
> +	struct ath9k_htc_priv *priv = hw->priv;
> +	u8 cmd_rsp;
> +	int ret;
> +
> +	mutex_lock(&priv->mutex);
> +
> +	if (priv->op_flags & OP_INVALID)
> +		goto err;
> +
> +	ath9k_htc_ps_wakeup(priv);
> +
> +	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
> +	if (drop)
> +		skb_queue_purge(&priv->tx_queue);
> +
> +	ath9k_htc_ps_restore(priv);
> +
> +err:
> +	mutex_unlock(&priv->mutex);
> +}
> +

I don't think this would work.

Queuing of packets is done in the HIF (USB) layer.
Flushing would require dropping (or not) the buffered packets in the
USB layer. Also, we don't actually require this, since IDLE state
is handled in radio_disable(), where everything is flushed properly ...

Sujith
