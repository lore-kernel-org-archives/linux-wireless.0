Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:56076 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab2FMVGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 17:06:06 -0400
Received: by lagz14 with SMTP id z14so960137lag.35
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 14:06:01 -0700 (PDT)
Message-ID: <1339621559.10534.95.camel@cumari.coelho.fi> (sfid-20120613_230610_620896_723B8DDA)
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
From: Luciano Coelho <coelho@ti.com>
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org,
	victorg@ti.com
Date: Thu, 14 Jun 2012 00:05:59 +0300
In-Reply-To: <20120613205007.GB3043@pista>
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1339566003.4519.1.camel@jlt3.sipsolutions.net>
	 <1339587447.3840.272.camel@cumari.coelho.fi>
	 <4FD87FEA.3070208@qca.qualcomm.com> <20120613205007.GB3043@pista>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 13:50 -0700, Pedersen, Thomas wrote:
> On Wed, Jun 13, 2012 at 02:56:26PM +0300, Kalle Valo wrote:
> > On 06/13/2012 02:37 PM, Luciano Coelho wrote:
> > > On Wed, 2012-06-13 at 07:40 +0200, Johannes Berg wrote:
> > >> On Tue, 2012-06-12 at 13:43 -0700, Thomas Pedersen wrote:
> > >>> Support configuring an RSSI threshold in dBm (s32) when requesting
> > >>> scheduled scan, below which a BSS won't be reported by the cfg80211
> > >>> driver.
> > >>
> > >> I'm confused -- were you going to do scheduled scan only? Makes sense,
> > >> but if you could maybe change the subject a bit to "specify ... in
> > >> scheduled scan"?
> > > 
> > > It makes more sense with scheduled scans, but maybe it is also desirable
> > > with normal scans to reduce the amount of scan results traffic?
> > > 
> > > At least if we consider the intermediate scan results that Victor has
> > > been working on... We may want to report all scan results at the end,
> > > but only send intermediate events if all the matches are satisfied, for
> > > example.
> > > 
> > > Just thinking out loud a bit.
> > 
> > Good point.
> > 
> > Funnily enough I don't have any idea how ath6kl has implemented this
> > feature, but in theory this feature is useful also for the current
> > normal scan (when the firmware/hardware supports it) as we can avoid
> > host wakeups. If there are 10 APs, but all are below the RSSI threshold,
> > we will have only 1 host wakeup (scan ready event) opposed to 11 wakeups
> > (10 AP found events plus 1 scan ready event).
> 
> But can the host even sleep on normal scans?

Why not? If you're doing a full scan in 11bg + 11a channels it can take
a long time...

Some applications may use very frequent scans, for example for location
services, so saving some wake-ups every time can prove a big improvement
in power consumption in the long run...

> If so, maybe it makes sense to convert NL80211_ATTR_SCHED_SCAN_MATCH
> into general scan matching parameters instead of having a set for each
> scan type?

I'm sure I discussed this with Johannes a long time ago, but now I can't
remember why we decided to keep it for sched scans only...

--
Luca.

