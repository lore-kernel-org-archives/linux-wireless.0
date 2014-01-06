Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaAFPE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:04:27 -0500
Message-ID: <1389020664.5891.18.camel@jlt4.sipsolutions.net> (sfid-20140106_160439_209967_245CB594)
Subject: Re: [PATCH] mac80211: Return untuned timestamp in case of invalid
 bitrates
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya Tata <Chaitanya.Tata@imgtec.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"chaitanya.mgit@gmail.com" <chaitanya.mgit@gmail.com>
Date: Mon, 06 Jan 2014 16:04:24 +0100
In-Reply-To: <82A67CC48AF04D43A69EB66645975134107C6285@hbmail01.hb.imgtec.org>
References: <82A67CC48AF04D43A69EB66645975134107C6285@hbmail01.hb.imgtec.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-26 at 13:42 +0000, Chaitanya Tata wrote:
> In case the driver sends MCS9 and doesn't advertise CBW
> (or) advertises 20MHz bandwidth, return the timestamp As is, 
> instead of returning 0 as timestamp.
> 
> Signed-off-by: Chaitanya T K <Chaitanya.mgit@gmail.com>
> ---
> net/mac80211/util.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c index 06265d7..bc92b25 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -2265,7 +2265,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
>  	if (WARN_ONCE(!rate,
>  		      "Invalid bitrate: flags=0x%x, idx=%d, vht_nss=%d\n",
>  		      status->flag, status->rate_idx, status->vht_nss))
> -		return 0;
> +		return ts;

I think this is wrong - we've already warned, we know we have no usable
timestamp, and this should never happen anyway.

johannes

