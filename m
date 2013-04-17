Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62539 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965236Ab3DQPrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:47:13 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so1736666wgh.6
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 08:47:12 -0700 (PDT)
Date: Wed, 17 Apr 2013 17:43:05 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2 3/5] mac80211: improve the rate control API
Message-ID: <20130417154305.GB4319@magnum.frso.rivierawaves.com> (sfid-20130417_174717_618405_B0BC9347)
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org>
 <1366112326-92981-3-git-send-email-nbd@openwrt.org>
 <20130417152339.GA4319@magnum.frso.rivierawaves.com>
 <516EC22B.6080403@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <516EC22B.6080403@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 17, 2013 at 05:39:23PM +0200, Felix Fietkau wrote:
> On 2013-04-17 5:23 PM, Karl Beldan wrote:
> > On Tue, Apr 16, 2013 at 01:38:44PM +0200, Felix Fietkau wrote:
> >> @@ -692,16 +692,38 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
> >>  	 */
> >>  	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
> >>  
> >> -	if (unlikely(info->control.rates[0].idx < 0))
> >> -		return TX_DROP;
> >> +	if (tx->sta)
> >> +		ratetbl = rcu_dereference(tx->sta->sta.rates);
> >> +
> >> +	if (unlikely(info->control.rates[0].idx < 0)) {
> >> +		if (ratetbl) {
> >> +			struct ieee80211_tx_rate rate = {
> >> +				.idx = ratetbl->rate[0].idx,
> >> +				.flags = ratetbl->rate[0].flags,
> >> +				.count = ratetbl->rate[0].count
> >> +			};
> >> +
> >> +			if (ratetbl->rate[0].idx < 0)
> >> +				return TX_DROP;
> >> +
> >> +			tx->rate = rate;
> > tx->rate = ratetbl->rate[0];
> No, the data structure in ratetbl->rate is not compatible.
> 
Oops, yes.
 
Karl
