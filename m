Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:37778 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab3CBLCA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 06:02:00 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 7/7] mac80211: improve minstrels rate sorting by means of throughput & probability
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <20130301184105.GC16369@localhost>
Date: Sat, 2 Mar 2013 12:01:59 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com, nbd@openwrt.org
Message-Id: <924BD93D-F69A-4D15-8E81-9720FC1B0E2B@net.t-labs.tu-berlin.de> (sfid-20130302_120204_918855_BE4355AD)
References: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1362159456-39448-8-git-send-email-thomas@net.t-labs.tu-berlin.de> <20130301184105.GC16369@localhost>
To: Bob Copeland <me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,


On 01.03.2013, at 19:41, Bob Copeland <me@bobcopeland.com> wrote:

> On Fri, Mar 01, 2013 at 06:37:36PM +0100, Thomas Huehn wrote:
>> +		//printk(KERN_ERR "before sort: max_tp_rate[0]= %i, [1]= %i, [2]= %i, [3]= %i,", mi->max_tp_rate[0], mi->max_tp_rate[1], mi->max_tp_rate[2], mi->max_tp_rate[3]);
> 
> Some leftover debugging there, and elsewhere.
> 

I should have removed the debugging, thx for finding, I will fix this in v2.

> I take it the changes to minstrel_update_stats fix the problem where
> a rate might get used more than once?  A while ago I wrote the following
> patch for that, but never found the time to test it.  It would be great
> to know it's fixed.

This patch brings minstrel-ht's way of electing the max probability rate to minstrel.
It relaxes the max probability criteria in such a way, that in cases where max probability of rates its above 95%, they are treated as if they have equally high success probability and now just the throughput matters as decision criteria. Lets make a concrete example of a minstrel statistic table snap shot:

Rate | Success		| Throughput
	 |  Prob. [%]	|     [MBit/s]
-----------------------------------------
  6	|	98.5		|	6.0
  9	|	99.9		|	8.7
  12	|	95.3		|	11.2
  18	|	99.8		|	17.3
  24	|	95.3		|	21.6
  36  |	90.0		|	29.4
  48  |	90.2		|	37.6
  54  |	84.3		|	39.3

In case we determine the maximal probability rate just by finding highest success prob. it would give us rate 9. With this patch and the "above 95% success everything is just equally successful" we would choose rate 24 as max. probability rate, as it provides the highest throughout among the rates with success prob. > 95%.
If I understand you right, your idea is to avoid equal rates for max_throughput and max_probability. The patch above would use equal rates for max_thr & max_prob. if the channel conditions allow this, so if they are pretty good. In other cases the max. probability rate can be totally different from max_thr. rate. So I do not 
understand the reasoning behind enforcing different rates for max_tp and max_prob. Minstrel will just apply its rule of max_prob_rate regardless if this rate also provides best or second best or other throughput values. Would you mind to this this patch with your hwsim ?

Greetings Thomas


> From: Bob Copeland <me@bobcopeland.com>
> Date: Fri, 18 May 2012 22:57:49 -0400
> Subject: [PATCH] minstrel: avoid reusing max tp/max prob rates if they are the same
> 
> Some testing I did a while ago with mac80211_hwsim showed that
> the MRR chain would frequently have the same rate included more
> than once because it would be both the "max throughput" rate and
> the "max success probability" rate.
> 
> If we truly cannot deliver packets with that rate due to changes
> in radio conditions, we can waste a lot of airtime with unsuccessful
> retransmissions.  So, compute both of the max throughput rates up
> front, and then pick the max prob. rate from the leftovers.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> net/mac80211/rc80211_minstrel.c |   21 +++++++++++----------
> 1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
> index 79633ae..36255f1 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -73,7 +73,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
> static void
> minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
> {
> -	u32 max_tp = 0, index_max_tp = 0, index_max_tp2 = 0;
> +	u32 max_tp = 0, index_max_tp = 0, max_tp2 = 0, index_max_tp2 = 0;
> 	u32 max_prob = 0, index_max_prob = 0;
> 	u32 usecs;
> 	u32 p;
> @@ -123,25 +123,26 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
> 	for (i = 0; i < mi->n_rates; i++) {
> 		struct minstrel_rate *mr = &mi->r[i];
> 		if (max_tp < mr->cur_tp) {
> +			max_tp2 = max_tp;
> +			index_max_tp2 = index_max_tp;
> 			index_max_tp = i;
> 			max_tp = mr->cur_tp;
> -		}
> -		if (max_prob < mr->probability) {
> -			index_max_prob = i;
> -			max_prob = mr->probability;
> +		} else if (max_tp2 < mr->cur_tp) {
> +			index_max_tp2 = i;
> +			max_tp2 = mr->cur_tp;
> 		}
> 	}
> 
> -	max_tp = 0;
> +	max_prob = 0;
> 	for (i = 0; i < mi->n_rates; i++) {
> 		struct minstrel_rate *mr = &mi->r[i];
> 
> -		if (i == index_max_tp)
> +		if (i == index_max_tp || i == index_max_tp2)
> 			continue;
> 
> -		if (max_tp < mr->cur_tp) {
> -			index_max_tp2 = i;
> -			max_tp = mr->cur_tp;
> +		if (max_prob < mr->probability) {
> +			index_max_prob = i;
> +			max_prob = mr->probability;
> 		}
> 	}
> 	mi->max_tp_rate = index_max_tp;
> -- 
> 1.7.2.5
> 
> -- 
> Bob Copeland %% www.bobcopeland.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

