Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2DRB5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:57:22 -0400
Message-ID: <1334714203.3725.24.camel@jlt3.sipsolutions.net> (sfid-20120418_035725_968484_423949BB)
Subject: Re: [PATCH] cfg80211: increse bss expire time
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 18:56:43 -0700
In-Reply-To: <1334315320-4913-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1334315320-4913-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see that the patch was merged, but I'll comment anyway.

On Fri, 2012-04-13 at 16:38 +0530, Rajkumar Manoharan wrote:
> The background scan completion takes more time when the station is
> having heavy uplink traffic. The scan state machine decides to fall
> back to home channel on every off-channel visit when there are pending
> frames in tx queue. bgscan completion took ~30sec on dual band US
> regulatory card.
> 
> scan period = (20 active channels * probe timeout) +
>               (12 passive channels * passive probe timeout) +
>               (32 * timeout on home channel) +
>               (32 * flush timeout)


That formula seems a bit useless :-)

> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/wireless/scan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index fdbcfe6..1442bb6 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -18,7 +18,7 @@
>  #include "nl80211.h"
>  #include "wext-compat.h"
>  
> -#define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
> +#define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)

I'm not sure we'll ever manage to cover the entire scanning time unless
we bump this REALLY high. I'd much rather see us measuring the duration
of the scan, say per hardware, and not expire for that long. Of course
the maximum of all measurements, and take new ones every time, or
something like that. Also maybe avoid expiring while a scan is in
process.

johannes

