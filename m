Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40262 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbcGFMfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 08:35:31 -0400
Message-ID: <1467808525.5460.4.camel@sipsolutions.net> (sfid-20160706_143553_650521_4B8CC2FE)
Subject: Re: [PATCH v2] mac80211: mesh: Add support for HW RC implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 06 Jul 2016 14:35:25 +0200
In-Reply-To: <20160630153055.26497-1-maxim.altshul@ti.com>
References: <20160630153055.26497-1-maxim.altshul@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-06-30 at 18:30 +0300, Maxim Altshul wrote:
> Mesh HWMP module will be able to rely on the HW
> RC algorithm if it exists, for path metric calculations.
> 
> This allows the metric calculation mechanism to calculate
> a correct metric, based on PER and last TX rate both via
> HW RC algorithm if it exists or via parameters collected
> by the SW.
> 
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
> ---
> Changed the function to return u32, I agree that this
> is much clearer.
> As for the rate, two things:
> 1. I had to divide the returned value by 100, since
> drv_get_expected_throughput returns values in units of Kbps.
> On the contrary, the function cfg80211_calculate_bitrate
> returns in units of 100Kbps, so a correction is needed.
> 2. Why return the value into rate?
> As I understand, rate here is actually bitrate,
> and so, we have two possible outcomes:
> - A SW/HW RC algo does exist, and an estimated throughput is
> returned. err is set to 0 (as it is already included in the RC algo)
> and the airtime is calculated using the estimated throughput.
> - A SW/HW RC algo does not exist, and thus the regular calculation
> takes place, in which an estimated throughput is calculated
> using the bitrate and the err parameter.
> From this calculation the airtime is calculated.
> 
>  net/mac80211/mesh_hwmp.c | 25 +++++++++++++++++--------
>  net/mac80211/sta_info.c  | 23 +++++++++++++++++++----
>  net/mac80211/sta_info.h  |  2 ++
>  3 files changed, 38 insertions(+), 12 deletions(-)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index c6be0b4..ad67f46 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -322,19 +322,28 @@ static u32 airtime_link_metric_get(struct
> ieee80211_local *local,
>  	int device_constant = 1 << ARITH_SHIFT;
>  	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
>  	int s_unit = 1 << ARITH_SHIFT;
> -	int rate, err;
> +	int rate = 0, err = 0;

The rate init is wrong - you overwrite it immediately.

The err init is questionable - I think it might be better to write

if (rate) {
   err = 0;
} else {
   ...
}

below?

>  	u32 tx_time, estimated_retx;
>  	u64 result;
>  
> -	if (sta->mesh->fail_avg >= 100)
> -		return MAX_METRIC;
> +	/* Try to get rate based on HW/SW RC algorithm.
> +	 * Rate is returned in units of Kbps, correct this
> +	 * to comply with airtime calculation units
> +	 */
> +	rate = sta_get_expected_throughput(sta) / 100;
> +
> +	/* if we did not get a rate */
> +	if (!rate) {

Maybe you want DIV_ROUND_UP to account for getting a very lot estimated
rate (< 100Kbps) returned, which isn't "no rate"?

Ohterwise looks fine.

johannes

