Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2DAVLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 17:11:55 -0400
Message-ID: <1333314713.22977.2.camel@jlt3.sipsolutions.net> (sfid-20120401_231158_569360_B30B6A44)
Subject: Re: [RFC] mac80211:  Support on-channel scan option.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Apr 2012 23:11:53 +0200
In-Reply-To: <4F78C056.4080307@candelatech.com>
References: <1333233041-3246-1-git-send-email-greearb@candelatech.com>
	   (sfid-20120401_003057_469452_61057064) <1333305916.3703.2.camel@jlt3.sipsolutions.net>
	  <4F78BE67.8090609@candelatech.com>
	 <1333313357.22977.0.camel@jlt3.sipsolutions.net>
	 <4F78C056.4080307@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-04-01 at 13:53 -0700, Ben Greear wrote:
> On 04/01/2012 01:49 PM, Johannes Berg wrote:
> > On Sun, 2012-04-01 at 13:45 -0700, Ben Greear wrote:
> >> On 04/01/2012 11:45 AM, Johannes Berg wrote:
> >>> On Sat, 2012-03-31 at 15:30 -0700, greearb@candelatech.com wrote:
> >>>
> >>>
> >>>>    static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
> >>>>    				  struct cfg80211_scan_request *req)
> >>>> @@ -438,6 +461,33 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
> >>>>    	local->scan_req = req;
> >>>>    	local->scan_sdata = sdata;
> >>>>
> >>>> +	/* If we are scanning only on the current channel, then
> >>>> +	 * we do not need to stop normal activities
> >>>> +	 */
> >>>> +	if ((req->n_channels == 1)&&
> >>>> +	    (req->channels[0]->center_freq ==
> >>>> +	     local->hw.conf.channel->center_freq)) {
> >>> ...
> >>>> +		return 0;
> >>>> +	}
> >>>> +
> >>>>    	if (local->ops->hw_scan)
> >>>>    		__set_bit(SCAN_HW_SCANNING,&local->scanning);
> >>>
> >>> Clearly, you're joking.
> >>
> >> That is worthless feedback and gives me no idea what you
> >> think should be fixed about it.
> >>
> >> If you hate the entire idea of optimizing scanning on channel,
> >> just say so plainly.
> >
> > I did quote only the relevant pieces -- you're completely ignoring hw
> > scan. Why should I care about this patch then?
> 
> Well, I was hoping that a simple scan-on-channel wouldn't need to
> care about the hw-scan logic.

So you thought about it, but didn't document it? This bothers me quite a
bit -- why should I have to always do the thinking again?

> But, I can change it so that the optimized scan-on-channel only
> is supported on NICs that do software-scan?

In any case, yes, you'll have to do that. Think about how scanning
works, and consider that devices may very well chose to filter by BSSID
when associated etc.

johannes

