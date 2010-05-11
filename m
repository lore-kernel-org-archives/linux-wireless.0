Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab0EKIwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:52:36 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	holgerschurig@gmail.com
In-Reply-To: <20100511083900.28289.43864.stgit@tt-desk>
References: <20100511083121.28289.96180.stgit@tt-desk>
	 <20100511083900.28289.43864.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 10:52:29 +0200
Message-ID: <1273567949.3669.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-11 at 17:39 +0900, Bruno Randolf wrote:


> +static inline int drv_set_antenna(struct ieee80211_local *local,
> +				  u8 tx_ant, u8 rx_ant)
> +{
> +	int ret = -EOPNOTSUPP;
> +	might_sleep();
> +	if (local->ops->set_antenna)
> +		ret = local->ops->set_antenna(&local->hw, tx_ant, rx_ant);
> +	return ret;
> +}
> +
> +static inline int drv_get_antenna(struct ieee80211_local *local,
> +				  u8 *tx_ant, u8 *rx_ant)
> +{
> +	int ret = -EOPNOTSUPP;
> +	might_sleep();
> +	if (local->ops->get_antenna)
> +		ret = local->ops->get_antenna(&local->hw, tx_ant, rx_ant);
> +	return ret;
> +}

Oh .. and add tracing please.

johannes

