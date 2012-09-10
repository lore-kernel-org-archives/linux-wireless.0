Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab2IJLQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 07:16:57 -0400
Message-ID: <1347275852.4272.12.camel@jlt4.sipsolutions.net> (sfid-20120910_131700_368048_F240F3EC)
Subject: Re: [PATCH v3 2/7] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 10 Sep 2012 13:17:32 +0200
In-Reply-To: <1344426823-1795-3-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-3-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-08 at 14:53 +0300, Victor Goldenshtein wrote:
> Add command to trigger radar detection in the driver/FW.
> Once radar detection is started it should continuously
> monitor for radars as long as the channel active.
> If radar is detected usermode notified with 'radar
> detected' event.

> +	if (!local->ops->start_radar_detection)
> +		return -EOPNOTSUPP;
> +
> +	ret = drv_start_radar_detection(local, sdata, chan);
> +	return ret;

Remove the ret variable please.

> +++ b/net/mac80211/iface.c
> @@ -731,6 +731,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		/* free all potentially still buffered bcast frames */
>  		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps_bc_buf);
>  		skb_queue_purge(&sdata->u.ap.ps_bc_buf);
> +
> +		/* reset DFS channel availability check */
> +		if (local->oper_channel && sdata->wdev.preset_chan) {
> +			local->oper_channel->cac_type = 0;
> +			/* in case AP hasn't started yet */
> +			sdata->wdev.preset_chan->cac_type = 0;
> +		}

Why is mac80211 modifying cfg80211 fields? cfg80211 also uses this, no?
This seems strange to me.

> +DEFINE_EVENT(local_sdata_evt, drv_start_radar_detection,
> +	TP_PROTO(struct ieee80211_local *local,
> +		 struct ieee80211_sub_if_data *sdata),
> +	TP_ARGS(local, sdata)
> +);

Umm, parameters?

johannes

