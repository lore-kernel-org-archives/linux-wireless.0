Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55273 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118Ab3CDTCj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 14:02:39 -0500
Message-ID: <5134EFC8.20207@openwrt.org> (sfid-20130304_200242_921517_47D90044)
Date: Mon, 04 Mar 2013 20:02:32 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH v3 5/7] mac80211: add lowest rate into minstrel's randmon
 rate sampling table
References: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1362422905-78079-6-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1362422905-78079-6-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-04 7:48 PM, Thomas Huehn wrote:
> While minstrel bootstraps and fills the success probabilities of each
> rate the lowest rate has typically a very high success probability
> (often 100% in our tests).
> Its statistics are never updated but considered to setup the mrr chain.
> In our tests we see that especially the 3rd mrr stage (which is that
> rate providing highest success probability) is filled with the lowest rate
> because its initial high sucess probability is never updated. By design
> the 4th mrr stage is filled with the lowest rate so often 3rd and 4th
> mrr stage are equal.
> 
> This patch follows minstrels general approach of assuming as little
> as possible about rate dependencies. Consequently we include the
> lowest rate into the random sampling table to get balanced up-to-date
> statistics of all rates and therefore balanced decisions.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
>  net/mac80211/rc80211_minstrel.c    | 20 +++++++-------------
>  net/mac80211/rc80211_minstrel.h    |  4 +++-
>  net/mac80211/rc80211_minstrel_ht.c |  1 -
>  3 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
> index aa59f29..aa1e81a 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -370,26 +369,21 @@ static void
>  init_sample_table(struct minstrel_sta_info *mi)
>  {
>  	unsigned int i, col, new_idx;
> -	unsigned int n_srates = mi->n_rates - 1;
>  	u8 rnd[8];
>  
>  	mi->sample_column = 0;
>  	mi->sample_row = 0;
> -	memset(mi->sample_table, 0, SAMPLE_COLUMNS * mi->n_rates);
> +	memset(mi->sample_table, 0xff, SAMPLE_COLUMNS * mi->n_rates);
>  
>  	for (col = 0; col < SAMPLE_COLUMNS; col++) {
> -		for (i = 0; i < n_srates; i++) {
> +		for (i = 0; i < mi->n_rates; i++) {
>  			get_random_bytes(rnd, sizeof(rnd));
> -			new_idx = (i + rnd[i & 7]) % n_srates;
> +			new_idx = (i + rnd[i]) % mi->n_rates;
Don't remove the '& 7' part, otherwise the rnd array will overflow.
There's no need for it to be as big as the number of rates though.
Also, there's a typo in the subject line: 'randmon'.

- Felix
