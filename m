Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1KHVIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 16:08:37 -0500
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB999BE.8050909@candelatech.com>
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>
	 <1320780995-30483-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_203659_989707_E33ECA13) <1320782949.24797.45.camel@jlt3.sipsolutions.net>
	 <4EB994A1.1020808@candelatech.com>
	 <1320785889.24797.75.camel@jlt3.sipsolutions.net>
	 <4EB999BE.8050909@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 22:08:35 +0100
Message-ID: <1320786515.24797.80.camel@jlt3.sipsolutions.net> (sfid-20111108_220840_328525_F9FDBB68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 13:06 -0800, Ben Greear wrote:

> > About APs: that can't be right, there certainly will be 1x1 APs.
> 
> Section 20.1.1 again:
> 
> "An HT non-AP STA shall support all equal modulation (EQM) rates for one spatial stream (MCSs 0 through
> 7) using 20 MHz channel width. An HT AP shall support all EQM rates for one and two spatial streams
> (MCSs 0 through 15) using 20 MHz channel width."
> 
> Again, I think the requirement is lame, and maybe everyone will just ignore it,
> but it is there...

Funny. Yeah I'm pretty sure everybody ignores that. Of course maybe you
can't get a 1x1 AP certified as an AP, but surely that'll happen with a
P2P GO all the time.

> > start = allow_single_stream_mask ? 0 : 1;
> >
> > for (i = start; i<  IEEE80211_HT_MCS_MASK_LEN; i++) {
> > 	u8 val = smask[i]&  scaps[i];
> > 	val |= ht_cap->mcs.rx_mask[i]&  ~smask[i];
> > 	ht_cap->mcs.rx_mask[i] val;
> > }
> >
> > or so. right? Much simpler?
> 
> Depends on whether we want to honour the AP part of 20.1.1.
> Since we don't support AP mode anyway right now,
> I'm fine with your suggestion.  Let me know if you want
> me to proceed with your suggested changes.

I don't want to honour it. In fact, the more I think about it the less I
want to honour the 0-7 part here, since that just made the code more
complex and almost nobody will be using this override anyway.

johannes

