Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2IFJyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 05:54:24 -0400
Message-ID: <1346925298.5469.4.camel@jlt4.sipsolutions.net> (sfid-20120906_115455_113907_B20D2DE5)
Subject: Re: [RFC v2] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 06 Sep 2012 11:54:58 +0200
In-Reply-To: <50481C2E.5040303@posedge.com>
References: <5046FB3D.6090803@posedge.com>
	 <1346852356.4364.9.camel@jlt4.sipsolutions.net>
	 <50481C2E.5040303@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 09:14 +0530, Mahesh Palivela wrote:
> On 09/05/2012 07:09 PM, Johannes Berg wrote:
> > On Wed, 2012-09-05 at 12:41 +0530, Mahesh Palivela wrote:
> >
> >> + * @prim_chan_freq: primary channel frequency
> >
> > I still don't like this as a frequency, I think it makes a lot more
> > sense to stick to how the standard does it.
> >
> 
>  From spec:
> 
> Channel center frequency [MHz]
> = Channel starting frequency + 5 * dot11CurrentChannelCenterFrequencyIndex
> 
> Primary 20 MHz channel center frequency [MHz]
> = Channel starting frequency + 5 * dot11CurrentPrimaryChannel
> 
> The channel starting frequency is defined as dot11ChannelStartingFactor 
> × 500 kHz. If a channel center frequency is 5.000 GHz, it shall be 
> indicated by dot11ChannelStartingFactor = 8000 and
> dot11CurrentPrimaryChannel = 200
> 
> end spec:
> 
> So spec defined center freq index and prim channel numbers. 

No, it doesn't. It *derives* these. Check "Table 22-22—Fields to specify
VHT channels" for how it actually *specifies* them.

> >> +	if (center_freq == 0 || bw_khz == 0)
> >> +		return false;
> >
> > Can that actually happen?
> >
> 
> just a defensive check. I can remove it, if redundant

I was thinking then it should have a WARN_ON_ONCE() maybe.


> >> +	r = freq_reg_info_regd(wiphy,
> >> +			       chan_config->prim_chan_freq,
> >> +			       desired_bw_khz,
> >
> > This is wrong, I think? We won't use 40/80/160 MHz around the primary
> > channel frequency, we use it around the center_freq1/2.
> >
> 
> This is to find the regulatory rule only. Not checking desired BW around 
> prim channel. center freq chan 42 of 36, 40, 44 and 48 for 80 MHz BW may 
> not be in list of freq values in reg rule.

Hmm? Don't think I understand this. Why do you pass in the right
bandwidth if it's not used?

> >> +	ret = reg_sec_chans_permitted(wiphy,
> >> +				      chan_config->center_freq1,
> >> +				      desired_bw_khz);
> >
> > This seems better, but is missing the bandwidth check?
> 
> bandwidths are checked in reg_chan_use_permitted. reg rule decides it right?

I guess I don't really understand this.

johannes

