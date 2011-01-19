Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:30278 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753106Ab1ASA6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 19:58:36 -0500
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-055688712
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 09:58:34 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: fix locking in tx_complete_poll_work
Date: Wed, 19 Jan 2011 09:58:51 +0900
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <1295356003-1425-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1295356003-1425-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201101190958.51192.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 18 2011 22:06:43 Bob Copeland wrote:
> ath5k_reset must be called with sc->lock.  Since the tx queue
> watchdog runs in a workqueue and accesses sc, it's appropriate
> to just take the lock over the whole function.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index 019a74d..09ae4ef 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2294,6 +2294,8 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
>  	int i;
>  	bool needreset = false;
> 
> +	mutex_lock(&sc->lock);
> +
>  	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++) {
>  		if (sc->txqs[i].setup) {
>  			txq = &sc->txqs[i];
> @@ -2321,6 +2323,8 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
>  		ath5k_reset(sc, NULL, true);
>  	}
> 
> +	mutex_unlock(&sc->lock);
> +
>  	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
>  		msecs_to_jiffies(ATH5K_TX_COMPLETE_POLL_INT));
>  }

Acked-by: Bruno Randolf <br1@einfach.org>
