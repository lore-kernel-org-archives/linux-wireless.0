Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38460 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab1K3Maj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 07:30:39 -0500
Subject: Re: [PATCH 2/4] nl80211: Parse channel type attribute in an ibss
 join request
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
In-Reply-To: <20111130122731.GA14283@pandem0nium>
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1322502917-28205-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1322655406.3982.12.camel@jlt3.sipsolutions.net>
	 <20111130122731.GA14283@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 13:30:35 +0100
Message-ID: <1322656235.3982.14.camel@jlt3.sipsolutions.net> (sfid-20111130_133041_141011_903430EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-30 at 13:27 +0100, Simon Wunderlich wrote:
> Hey Johannes,
> 
> On Wed, Nov 30, 2011 at 01:16:46PM +0100, Johannes Berg wrote:
> > On Mon, 2011-11-28 at 18:55 +0100, Simon Wunderlich wrote:
> > > Prepare cfg80211 for IBSS HT:
> > >  * extend cfg80211 ibss struct with channel_type
> > >  * Check if extension channel can be used
> > >  * Export can_beacon_sec_chan for use in mac80211 (will be called
> > >    from ibss.c later).
> > 
> > I'm thinking there should be a "driver supports HT IBSS" flag, and we
> > reject the config otherwise?
> 
> There is already an implicit check for this - rdev_freq_to_chan() checks
> if the channel_type is supported, and -EINVAL otherwise. So if I call 
> ibss_join with HT20 or HT40 on ath5k, it gets rejected already.

Right, but this just checks if HT is supported, not if HT-IBSS is
supported. I can see some cfg80211 drivers implementing HT and IBSS, but
not HT-IBSS, just like mac80211 before these patches.

> If this is not enough and we need a further flag, could you please give
> me a hint how/where to implement it?

I'd add it to enum nl80211_feature_flags.

johannes

