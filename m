Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:60897
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab2IFDox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 23:44:53 -0400
Message-ID: <50481C2E.5040303@posedge.com> (sfid-20120906_054456_909883_E24AA4D8)
Date: Thu, 6 Sep 2012 09:14:46 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [RFC v2] cfg80211: VHT regulatory
References: <5046FB3D.6090803@posedge.com> <1346852356.4364.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1346852356.4364.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 07:09 PM, Johannes Berg wrote:
> On Wed, 2012-09-05 at 12:41 +0530, Mahesh Palivela wrote:
>
>> + * @prim_chan_freq: primary channel frequency
>
> I still don't like this as a frequency, I think it makes a lot more
> sense to stick to how the standard does it.
>

 From spec:

Channel center frequency [MHz]
= Channel starting frequency + 5 * dot11CurrentChannelCenterFrequencyIndex

Primary 20 MHz channel center frequency [MHz]
= Channel starting frequency + 5 * dot11CurrentPrimaryChannel

The channel starting frequency is defined as dot11ChannelStartingFactor 
× 500 kHz. If a channel center frequency is 5.000 GHz, it shall be 
indicated by dot11ChannelStartingFactor = 8000 and
dot11CurrentPrimaryChannel = 200

end spec:

So spec defined center freq index and prim channel numbers. From those 
we compute actual freq value. I though push arithmetic part to apps.
If we move to represent as numbers then will change types from u16 to 
u8. Let me know.

>> +	if (center_freq == 0 || bw_khz == 0)
>> +		return false;
>
> Can that actually happen?
>

just a defensive check. I can remove it, if redundant

>> +	// get chan BW from config
>
> Please don't use C99-style comments.
>

Sure. will change it.

>> +	r = freq_reg_info_regd(wiphy,
>> +			       chan_config->prim_chan_freq,
>> +			       desired_bw_khz,
>
> This is wrong, I think? We won't use 40/80/160 MHz around the primary
> channel frequency, we use it around the center_freq1/2.
>

This is to find the regulatory rule only. Not checking desired BW around 
prim channel. center freq chan 42 of 36, 40, 44 and 48 for 80 MHz BW may 
not be in list of freq values in reg rule.

>> +	ret = reg_sec_chans_permitted(wiphy,
>> +				      chan_config->center_freq1,
>> +				      desired_bw_khz);
>
> This seems better, but is missing the bandwidth check?

bandwidths are checked in reg_chan_use_permitted. reg rule decides it right?

>
> johannes
>
