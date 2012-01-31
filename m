Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2AaFms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 00:42:48 -0500
Message-ID: <4F277F29.2080205@sipsolutions.net> (sfid-20120131_064250_619113_D6122069)
Date: Mon, 30 Jan 2012 21:42:01 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Subject: Re: [RFC 2/9] mac80211: add radar detection command/event
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-3-git-send-email-victorg@ti.com>
In-Reply-To: <1327581484-22047-3-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:37 AM, Victor Goldenshtein wrote:
> +	int (*hw_dfs_start_radar_detection)(struct ieee80211_hw *hw,
> +					    struct ieee80211_vif *vif);

This name is getting ridiculously long -- no need for the hw_ prefix either.

> +void ieee80211_radar_detected_notify(struct ieee80211_vif *vif,
> +				     u16 freq, gfp_t gfp);

Btw, why not a channel pointer? Most APIs use that.

> +static int ieee80211_dfs_start_radar_detection(struct wiphy *wiphy,
> +					       struct net_device *dev)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = sdata->local;
> +	int ret = -ENOENT;

??? No need for a default value.

> +	if (!local->ops->hw_dfs_start_radar_detection)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&local->mtx);
> +	ret = drv_dfs_en_radar_detection(local, sdata);
> +	mutex_unlock(&local->mtx);

Why even lock here? That's not protecting anything.

> +static inline int drv_dfs_en_radar_detection(struct ieee80211_local *local,
> +					 struct ieee80211_sub_if_data *sdata)
> +{
> +	int ret;
> +
> +	might_sleep();
> +
> +	trace_drv_dfs_en_radar_detection(local, sdata);
> +	ret = local->ops->hw_dfs_start_radar_detection(&local->hw,&sdata->vif);

trace_drv_ret_int()

johannes
