Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2KSOLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:11:14 -0500
Message-ID: <1353334304.18299.2.camel@jlt4.sipsolutions.net> (sfid-20121119_151117_496021_8003A402)
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 19 Nov 2012 15:11:44 +0100
In-Reply-To: <50AA237F.4090102@posedge.com>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	 <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
	 <50AA237F.4090102@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 17:48 +0530, Mahesh Palivela wrote:

> > +	case NL80211_CHAN_WIDTH_160:
> > +		if (chandef->center_freq1 != control_freq + 70 &&
> > +		    chandef->center_freq1 != control_freq + 50 &&
> > +		    chandef->center_freq1 != control_freq + 30 &&
> > +		    chandef->center_freq1 != control_freq + 10 &&
> > +		    chandef->center_freq1 != control_freq - 10 &&
> > +		    chandef->center_freq1 != control_freq - 30 &&
> > +		    chandef->center_freq1 != control_freq - 50 &&
> > +		    chandef->center_freq1 != control_freq - 70)
> > +			return false;
> 
> Should we create a macro instead of +70 to -70 to take care of all 3 
> cases 80, 80p80 and 160?

Not sure, I hope we won't duplicate this code anywhere else, so I don't
really think we need to?

johannes

