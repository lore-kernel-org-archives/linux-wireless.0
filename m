Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46740 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbYJGRN0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:13:26 -0400
Message-ID: <48EB98A6.4050406@openwrt.org> (sfid-20081007_191343_614525_3708FB3A)
Date: Tue, 07 Oct 2008 19:13:10 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 2/4] mac80211: add multi-rate retry support
References: <48E8E48E.5090300@openwrt.org> <48E8E528.7060501@openwrt.org>	 <48E8E588.30001@openwrt.org> <1223329786.3778.38.camel@johannes.berg>
In-Reply-To: <1223329786.3778.38.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2008-10-05 at 18:04 +0200, Felix Fietkau wrote:
>> This patch adjusts the rate control API to allow multi-rate retry
>> if supported by the driver. The ieee80211_hw struct specifies how
>> many alternate rate selections the driver supports.
> 
> Don't those drivers that announce supporting max_altrates = 1 have to
> update the status for alternative rates too? Also, should
> max_altrate_tries == 0 indicate that that is fixed?
IMHO yes.

> But b43 with the
> default firmware actually _is_ capable of changing the number of retries
> (default to 3/3 or 3/4 I think), just not per frame. Should we have that
> in the API too?
Minstrel won't use it, because the value that it selects is dependent
on the rate that is to be used there. Maybe it'd make sense for other 
stuff, though.

> Another thing, it seems you didn't update those drivers to report the
> rates and number of tries, at least for b43 that is actually possible.
> 
> Also, can you explain the use of IEEE80211_TX_CTL_RATE_CTRL_PROBE?
When using MRR and the get_rate function determines that it's time to do
some sampling, and the sampling rate it selected is lower than the calculated
max throughput rate, it wouldn't make sense to put the sampling rate in the
first stage of the MRR chain, because that would lower the effective
throughput unnecessarily.

Instead it throws the sampling rate in the second stage of the MRR chain
and increases a separate counter to prevent it from doing large bursts of
sampling attempts.

However if the hw never gets to the second MRR stage, because the first one
worked just fine, it should not mark this as a successful sampling, because
the sample rate was not actually attempted.

The IEEE80211_TX_CTL_RATE_CTRL_PROBE flag is used to tell the tx_status
function that there is a sampling rate in the second MRR stage, so that
it can update the sampling counter accordingly, in case the sampling rate
actually got used.

If the sampling counter instead was to be updated unconditionally, then
minstrel would frequently not use the second MRR stage as an opportunity
to figure out which of the lower rates actually work and thus might leave
most of them with a calculated probability of 0% until the max throughput
rate gets reduced through a change in the link quality.

That itself would cause the algorithm to use a much lower fallback rate than 
it has to, thus taking more time to get proper stats in place once the 
link becomes just a little bit weaker.

- Felix
