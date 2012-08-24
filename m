Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:60290
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab2HXNIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 09:08:47 -0400
Message-ID: <50377CD9.3090204@posedge.com> (sfid-20120824_150851_841070_797A37C5)
Date: Fri, 24 Aug 2012 18:38:41 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <502E85D9.5050301@posedge.com>  <1345480718.4459.37.camel@jlt3.sipsolutions.net>  <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>  <50338E84.3050709@posedge.com>  <1345564421.10280.9.camel@jlt3.sipsolutions.net>  <5033CE76.6040306@posedge.com>  <1345619008.4635.3.camel@jlt3.sipsolutions.net>  <20120822090104.GA4959@redhat.com>  <1345626282.4635.8.camel@jlt3.sipsolutions.net>  <20120822101252.GA6082@redhat.com> <50376671.7080007@posedge.com> <1345809927.6991.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1345809927.6991.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2012 05:35 PM, Johannes Berg wrote:
> On Fri, 2012-08-24 at 17:03 +0530, Mahesh Palivela wrote:
>
>> /**
>>    * enum ieee80211_chan_width - channel bandwidths
>>    *
>>    * @IEEE80211_CHAN_WIDTH_20MHZ: 20 MHz chan bandwidth
>>    * @IEEE80211_CHAN_WIDTH_40MHZ: 40 MHz chan bandwidth
>>    * @IEEE80211_CHAN_WIDTH_80MHZ: 80 MHz chan bandwidth
>>    * @IEEE80211_CHAN_WIDTH_160MHZ: 160 MHz chan bandwidth
>>    */
>
> We might need 20MHZ_NOHT or something?

Yes, I missed that.
20MHZ_NOHT in 5G band and legacy operation 2.4G band may be 5MHZ.

>
>>           enum ieee80211_chan_width chan_width2;
>>           u16 control_offset2;
>
> Those shouldn't be necessary, I think? The secondary 80 MHz channel
> can't have a control channel, it seems, and the width should be the same
> as well? Plus this is only allowed in 80+80 anyway.
>
> johannes
>
11ac d3.0 spec section 8.4.2.10 says

An operating class for an 80+80 MHz channel bandwidth is expressed by 
two consecutive Operating/Sub-
band Sequences, where the first Operating/Subband Sequence field 
contains an Operating Triplet for an
80 MHz Channel Spacing with an 80+ Behavior Limit and the second 
Operating/Subband Sequence field
contains an Operating Triplet for an 80 MHz Channel Spacing without an 
80+ Behavior Limit.

so country might allow primary chan to fall in other frequency segment?

- Mahesh
