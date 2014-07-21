Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46873 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428AbaGUO0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 10:26:42 -0400
Message-ID: <1405952795.32255.26.camel@jlt4.sipsolutions.net> (sfid-20140721_162645_830418_153AE588)
Subject: Re: [PATCH v2] mac80211: add support for Rx reordering offloading
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Jul 2014 16:26:35 +0200
In-Reply-To: <1405505535-13126-1-git-send-email-michal.kazior@tieto.com> (sfid-20140716_122055_514454_0F5D3891)
References: <1405505535-13126-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140716_122055_514454_0F5D3891)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-16 at 12:12 +0200, Michal Kazior wrote:

> +struct ieee80211_rx_agg {
> +	u8 addr[ETH_ALEN];
> +	u16 tid;
> +};
> +
>  enum sdata_queue_type {
>  	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
>  	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
>  	IEEE80211_SDATA_QUEUE_AGG_STOP		= 2,
> +	IEEE80211_SDATA_QUEUE_RX_AGG_START	= 3,
> +	IEEE80211_SDATA_QUEUE_RX_AGG_STOP	= 4,
>  };

I'm not a big fan of allocating skbs for these auxiliary messages, but I
guess I'll merge this and then fix it up later.

Applied.

johannes

