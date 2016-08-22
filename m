Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49891 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751437AbcHVNii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 09:38:38 -0400
Message-ID: <1471873065.1363.0.camel@sipsolutions.net> (sfid-20160822_154019_966387_A2CCE23D)
Subject: Re: [PATCH 1/3 v2] mac80211: RX BA support for sta
 max_rx_aggregation_subframes
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Date: Mon, 22 Aug 2016 15:37:45 +0200
In-Reply-To: <20160821112425.11302-1-maxim.altshul@ti.com> (sfid-20160821_131709_224184_1A1775D8)
References: <20160821112425.11302-1-maxim.altshul@ti.com>
         (sfid-20160821_131709_224184_1A1775D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	/* examine state machine */
> +	mutex_lock(&sta->ampdu_mlme.mtx);
> +
>  	/* make sure the size doesn't exceed the maximum supported
> by the hw */
> -	if (buf_size > local->hw.max_rx_aggregation_subframes)
> -		buf_size = local->hw.max_rx_aggregation_subframes;
> +	if (buf_size > sta->sta.max_rx_aggregation_subframes)
> +		buf_size = sta->sta.max_rx_aggregation_subframes;
>  	params.buf_size = buf_size;
> 
Since the driver is updating this value without any locking, is there
any point in changing the locking?

> +	ht_dbg(sta->sdata, "AddBA Req buf_size=%d\n", buf_size);

I think the station address should be in there.

johannes
