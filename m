Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60441 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010AbZC1LNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 07:13:04 -0400
Date: Sat, 28 Mar 2009 13:12:45 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: add driver ops debugging
Message-ID: <20090328111245.GA13041@jm.kir.nu> (sfid-20090328_121308_037816_6723C6B3)
References: <1238066858.4331.30.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238066858.4331.30.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 12:27:38PM +0100, Johannes Berg wrote:
> This patch adds (optional) debugging for each driver call
> (except tx) that can print out the call, its parameters and
> the return value from the driver.

... and breaks return value from many of the operations.. ;-)

> +++ wireless-testing/net/mac80211/driver-ops.h	2009-03-26 12:23:17.000000000 +0100

> +static inline int drv_config_interface(struct ieee80211_local *local,
> +				       struct ieee80211_vif *vif,
> +				       struct ieee80211_if_conf *conf)
> +{
> +	int ret = 0;
> +	if (local->ops->config_interface)
> +		local->ops->config_interface(&local->hw, vif, conf);
> +	dbg_config_interface(local, vif, conf, ret);
> +	return ret;
> +}

ret not updated from the actual call..

> +static inline int drv_set_rts_threshold(struct ieee80211_local *local,
> +					u32 value)
> +{
> +	int ret = 0;
> +	if (local->ops->set_rts_threshold)
> +		local->ops->set_rts_threshold(&local->hw, value);
> +	dbg_set_rts_threshold(local, value, ret);
> +	return ret;
> +}

same here

> +static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
> +			      const struct ieee80211_tx_queue_params *params)
> +{
> +	int ret = -EOPNOTSUPP;
> +	if (local->ops->conf_tx)
> +		local->ops->conf_tx(&local->hw, queue, params);
> +	dbg_conf_tx(local, queue, params, ret);
> +	return ret;
> +}

same here (this one with the ampdu one below results in interesting set
of issues ;-)

> +static inline u64 drv_get_tsf(struct ieee80211_local *local)
> +{
> +	u64 ret = -1ULL;
> +	if (local->ops->get_tsf)
> +		local->ops->get_tsf(&local->hw);
> +	dbg_get_tsf(local, ret);
> +	return ret;
> +}

same here

> +static inline int drv_tx_last_beacon(struct ieee80211_local *local)
> +{
> +	int ret = 1;
> +	if (local->ops->tx_last_beacon)
> +		local->ops->tx_last_beacon(&local->hw);
> +	dbg_tx_last_beacon(local, ret);
> +	return ret;
> +}

same here

> +static inline int drv_ampdu_action(struct ieee80211_local *local,
> +				   enum ieee80211_ampdu_mlme_action action,
> +				   struct ieee80211_sta *sta, u16 tid,
> +				   u16 *ssn)
> +{
> +	int ret = -EOPNOTSUPP;
> +	if (local->ops->ampdu_action)
> +		local->ops->ampdu_action(&local->hw, action, sta, tid, ssn);
> +	dbg_ampdu_action(local, action, sta, tid, ssn, ret);
> +	return ret;
> +}

same here

-- 
Jouni Malinen                                            PGP id EFC895FA
