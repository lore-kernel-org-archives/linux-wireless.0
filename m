Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2KTH1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 02:27:15 -0500
Message-ID: <1353396466.9399.0.camel@jlt4.sipsolutions.net> (sfid-20121120_082718_969721_B5961595)
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 20 Nov 2012 08:27:46 +0100
In-Reply-To: <50AB1D3E.4090808@posedge.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	  <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
	  <50AA237F.4090102@posedge.com>
	 <1353334304.18299.2.camel@jlt4.sipsolutions.net>
	 <50AB1D3E.4090808@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 11:33 +0530, Mahesh Palivela wrote:
> On 11/19/2012 07:41 PM, Johannes Berg wrote:
> > On Mon, 2012-11-19 at 17:48 +0530, Mahesh Palivela wrote:
> >
> >>> +	case NL80211_CHAN_WIDTH_160:
> >>> +		if (chandef->center_freq1 != control_freq + 70 &&
> >>> +		    chandef->center_freq1 != control_freq + 50 &&
> >>> +		    chandef->center_freq1 != control_freq + 30 &&
> >>> +		    chandef->center_freq1 != control_freq + 10 &&
> >>> +		    chandef->center_freq1 != control_freq - 10 &&
> >>> +		    chandef->center_freq1 != control_freq - 30 &&
> >>> +		    chandef->center_freq1 != control_freq - 50 &&
> >>> +		    chandef->center_freq1 != control_freq - 70)
> >>> +			return false;
> >>
> >> Should we create a macro instead of +70 to -70 to take care of all 3
> >> cases 80, 80p80 and 160?
> >
> > Not sure, I hope we won't duplicate this code anywhere else, so I don't
> > really think we need to?
> >
> 
> you kind of used it in cfg80211_check_beacon_chans() in wireless/chan.c
> 
>          for (freq = center_freq - bw/2 + 10;
>               freq <= center_freq + bw/2 - 10;
>               freq += 20)
> 
> we can use in 3 switch cases, 80, 80p80 and 160.

That's different code though, it iterates all the subchannels, while the
previous one checks the offset. I don't see how to unify that with a
single macro?

johannes

