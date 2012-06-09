Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44854 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2FIIxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:53:12 -0400
Message-ID: <1339231988.4539.35.camel@jlt3.sipsolutions.net> (sfid-20120609_105316_079595_F4DDAD4E)
Subject: Re: [PATCH 1/2] mac80211: Keep tx rate averages for mesh peers for
 better metric calculation.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Abele <jason@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	nbd <nbd@openwrt.org>
Date: Sat, 09 Jun 2012 10:53:08 +0200
In-Reply-To: <1339187469-12778-2-git-send-email-jason@cozybit.com> (sfid-20120608_223122_266703_A7927016)
References: <1339187469-12778-1-git-send-email-jason@cozybit.com>
	 <1339187469-12778-2-git-send-email-jason@cozybit.com>
	 (sfid-20120608_223122_266703_A7927016)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 13:31 -0700, Jason Abele wrote:
> From: Javier Cardona <javier@cozybit.com>
> 
> The mesh metric is computed every time it was requested by the path
> selection framework.  At that time only the last_tx_rate was taken into
> account when computing the metric.  This last frame may not reflect the
> average data rate that was possible ver that peer link (it could be a
> management frame, a rate control probe, or other outlier).
> 
> This patch maintains an average tx rate for each peer link which is used
> in metric calculation.

I don't think this makes a lot of sense, the TX rate is supposed to be
the "best rate" that the rate control algorithm decided on, so using
EWMA to weigh the bitrate seems a bit counter-productive.


> +++ b/net/mac80211/sta_info.h
> @@ -330,6 +330,7 @@ struct sta_info {
>  	unsigned long tx_retry_failed, tx_retry_count;
>  	/* moving percentage of failed MSDUs */
>  	unsigned int fail_avg;
> +	struct ewma avg_rate;

and in any case this is missing kernel-doc

johannes

