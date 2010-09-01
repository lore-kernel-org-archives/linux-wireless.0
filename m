Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0IAMwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 08:52:42 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100831150021.GA10963@redhat.com>
References: <20100831150021.GA10963@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 14:52:33 +0200
Message-ID: <1283345553.4124.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Some comments on the patch:

>  static int iwl_send_scan_abort(struct iwl_priv *priv)
>  {
> -	int ret = 0;
> +	int ret;
>  	struct iwl_rx_packet *pkt;
>  	struct iwl_host_cmd cmd = {
>  		.id = REPLY_SCAN_ABORT_CMD,
>  		.flags = CMD_WANT_SKB,
>  	};

Since you're going through, and probably know where what lock is needed,
could you annotate the places with, e.g.

	lockdep_assert_held(&priv->mutex)?

If you're not sure, that's fine, but if you know already that'd probably
make things easier in the future.

> +static inline void iwl_complete_scan(struct iwl_priv *priv, bool aborted)

These "inline" annotations seem wrong, either the function is used once,
then gcc will inline it, or it is used multiple times, then we shouldn't
inline it.

> +static void iwl_do_scan_abort(struct iwl_priv *priv)

> +	lockdep_assert_held(&priv->mutex);

:-)

> +/**
> + * iwl_scan_cancel_sleep - Cancel any currently executing HW scan,
> + *			   wait for hardware/firmware! completion
> + */
> +int iwl_scan_cancel_sleep(struct iwl_priv *priv)
> +{
> +	int ret;
> +	unsigned long timeout = jiffies + IWL_SCAN_ABORT_SLEEP;
> +
> +	IWL_DEBUG_SCAN(priv, "Scan cancel wait\n");
> +
> +	cancel_delayed_work(&priv->scan_timeout);
> +	iwl_do_scan_abort(priv);
> +
> +	while (time_before_eq(jiffies, timeout)) {
> +		if (!test_bit(STATUS_SCAN_HW, &priv->status))
> +			break;
> +		msleep(20);
> +	}

This, and

> +void iwl_wait_for_scan_end(struct iwl_priv *priv)
> +{
> +	unsigned long timeout = jiffies + IWL_SCAN_WAIT_END;
> +
> +	while (time_before_eq(jiffies, timeout)) {
> +		if (!test_bit(STATUS_SCANNING, &priv->status))
> +			break;
> +		msleep(20);
> +	}

this seems like it could use a completion?

johannes

