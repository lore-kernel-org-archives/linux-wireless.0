Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:14639 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbbC3JzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 05:55:24 -0400
Message-ID: <55191D89.2000300@neratec.com> (sfid-20150330_115526_998352_57E0ED3C)
Date: Mon, 30 Mar 2015 11:55:21 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath: use PRI value given by spec for fixed PRI
References: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com>
In-Reply-To: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2015 05:59 PM, Peter Oh wrote:
> PRI value is used as divider when DFS detector analyzes candidate
> radar pulses.
> If PRI deviation is big from its origin PRI, DFS detector could miss
> valid radar reports since HW often misses detecting radar pulses and
> causes long interval value of pulses.
> 
> For instance from practical results, if runtime PRI is calculated as
> 1431 for fixed PRI value of 1428 and delta timestamp logs 15719,
> the modular remainder will be 1409 and the delta between the remainder
> and runtime PRI is 22 that is bigger than PRI tolerance which is 16.
> As a result this radar report will be ignored even though it's valid.
> 
> By using spec defined PRI for fixed PRI, we can correct this error.
> 
Hm, not sure if this is a generic solution or 10k specific.

As stated in the source code
/*
 * tolerated deviation of radar time stamp in usecs on both sides
 * TODO: this might need to be HW-dependent
 */
#define PRI_TOLERANCE	16

the pri tolerance is assumed to be potentially dependent on used HW. The comment
in fact was noted when the detector was written to become generally usable by any
HW out there, before it became Atheros specific.

>From my measurements, the ath9k is far within the given pri tolerance, i.e. if you
continuously feed ETSI pattern 0 over a signal generator, it reports PRIs very
accurately at 1428us (or multiples thereof). Even under heavy load the jitter of
those reported values is within +/- 3us. With that, the ath9k (9580 more
specifically) is already more accurate than the given tolerance - increasing it
further would harm its operability.

The pri tolerance does not only help fine-tuning detection performance, but also
heavily defines whether DFS channels are usable or not (afair, it is the most
significant parameter to reduce false positives). That's why I believe we need to
be very cautious when changing it to fix / improve minor issues.

Therefore, if your measurements with 10k reveal that it needs a higher tolerance,
it should be made HW dependent and defined individually for 9k and 10k.

> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/dfs_pri_detector.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/dfs_pri_detector.c b/drivers/net/wireless/ath/dfs_pri_detector.c
> index 1b5ad19..fef459a 100644
> --- a/drivers/net/wireless/ath/dfs_pri_detector.c
> +++ b/drivers/net/wireless/ath/dfs_pri_detector.c
> @@ -25,6 +25,8 @@ struct ath_dfs_pool_stats global_dfs_pool_stats = {};
>  
>  #define DFS_POOL_STAT_INC(c) (global_dfs_pool_stats.c++)
>  #define DFS_POOL_STAT_DEC(c) (global_dfs_pool_stats.c--)
> +#define GET_PRI_TO_USE(MIN, MAX, RUNTIME) \
> +	(MIN + 16 == MAX - 16 ? MIN + 16 : RUNTIME)
>  
/* in case of single PRI patterns, take nominal PRI */
#define GET_PRI_TO_USE(MIN, MAX, RUNTIME) \
	((MAX - MIN) == 2 * PRI_TOLERANCE) ? MIN + PRI_TOLERANCE : RUNTIME)


If timestamp jitter is an issue for 10k, you might also want to consider adjusting
the assumed PRI with every pulse you add to a series. Initially I had it
implemented that way that the PRI was re-calculated continuously to minimize the
variance between nominal and measured pattern. But for the 9k and its accurate
timestamping that turned out to be a lot of calculation for almost no gain and was
dropped.


Cheers,
Zefir

