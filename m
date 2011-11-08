Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1KHVAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 16:00:07 -0500
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320785889.24797.75.camel@jlt3.sipsolutions.net> (sfid-20111108_215815_206338_233E9EBD)
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>
	 <1320780995-30483-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_203659_989707_E33ECA13) <1320782949.24797.45.camel@jlt3.sipsolutions.net>
	 <4EB994A1.1020808@candelatech.com>
	 <1320785889.24797.75.camel@jlt3.sipsolutions.net>
	 (sfid-20111108_215815_206338_233E9EBD)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 22:00:05 +0100
Message-ID: <1320786005.24797.76.camel@jlt3.sipsolutions.net> (sfid-20111108_220011_312338_EE1C039E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 21:58 +0100, Johannes Berg wrote:
> On Tue, 2011-11-08 at 12:44 -0800, Ben Greear wrote:
> > On 11/08/2011 12:09 PM, Johannes Berg wrote:
> > > On Tue, 2011-11-08 at 11:36 -0800, greearb@candelatech.com wrote:
> > >
> > >> +			/*
> > >> +			 * We always need to advert at least MCS0-7, to
> > >> +			 * be a compliant HT station, for instance
> > >> +			 */
> > >> +			if (((i * 8 + q)>= min_rates)&&
> > >
> > > This is a little misleading -- why min_rates when the comment says
> > > MCS0-7?
> > 
> > I let caller determine the min, but comment was to tell why
> > the min might be set.  In APs, the min supported rates are 16, evidently...not
> > that this code supports APs at the moment...
> 
> About APs: that can't be right, there certainly will be 1x1 APs.
> 
> > When this is about local use instead of advertising, then any minimum
> > is OK.
> > 
> > Want me to just remove the comment entirely?
> 
> Well, so, I think the logic there is a little odd anyway -- why aren't
> you doing it byte-wise, if the only thing that can possibly happen is
> that the first byte is masked or not? Maybe change the parameter to
> "bool allow_single_stream_mask" or something like that and adjust the
> algorithm like:
> 
> start = allow_single_stream_mask ? 0 : 1;
> 
> for (i = start; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
> 	u8 val = smask[i] & scaps[i];
> 	val |= ht_cap->mcs.rx_mask[i] & ~smask[i];
> 	ht_cap->mcs.rx_mask[i] val;
> }

Ok, no, I totally misunderstood the variables here, but anyway, it seems
there's no need for bit-wise stuff.

johannes

