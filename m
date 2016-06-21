Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55910 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbcFUJS3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 05:18:29 -0400
Message-ID: <1466500699.3170.7.camel@sipsolutions.net> (sfid-20160621_111834_676881_34C74B29)
Subject: Re: [PATCH 3/3] mac80211: mesh: Add support for HW RC implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>, kvalo@codeaurora.org
Cc: eliad@wizery.com, yanivma@ti.com, guym@ti.com, arik@wizery.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	davem@davemloft.net
Date: Tue, 21 Jun 2016 11:18:19 +0200
In-Reply-To: <1466427622-5953-4-git-send-email-maxim.altshul@ti.com>
References: <1466427622-5953-1-git-send-email-maxim.altshul@ti.com>
 <1466427622-5953-2-git-send-email-maxim.altshul@ti.com>
 <1466427622-5953-3-git-send-email-maxim.altshul@ti.com>
	 <1466427622-5953-4-git-send-email-maxim.altshul@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -	if (sta->mesh->fail_avg >= 100)
> -		return MAX_METRIC;
> +	/* try to get rate based on HW RC algorithm */
> +	rate = drv_get_expected_throughput(local, &sta->sta);

This doesn't look correct, since you should use the rate control op if
available, to get data from rate control algorithms.

You should call sta_set_sinfo(), but that's far too much, so more
likely you should factor out the last few lines of that into a new
function and call that new function in both places.

johannes
