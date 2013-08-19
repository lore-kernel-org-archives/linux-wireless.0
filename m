Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3HSKfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 06:35:11 -0400
Message-ID: <1376908507.14734.10.camel@jlt4.sipsolutions.net> (sfid-20130819_123515_292188_7DA97584)
Subject: Re: [PATCHv2 4/6] mac80211: add support for CSA in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Mon, 19 Aug 2013 12:35:07 +0200
In-Reply-To: <20130816133629.GA9932@pandem0nium>
References: <1376058920-17779-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1376058920-17779-5-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1376649188.15299.11.camel@jlt4.sipsolutions.net>
	 <20130816133629.GA9932@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-16 at 15:36 +0200, Simon Wunderlich wrote:

> Hmm ... changing HT40+/- can only be represented by using either ECSA (which i did not
> implement) or secondary channel offsets in action frames (which comes in a later
> patch, but could be merged ...). Secondary channel offsets are not allowed in
> beacon/presp, and therefore the client would keep the current mode (HT40+ or HT40-)
> as announced in the HT IEs of the beacon/presp. If I add support for secondary channel
> offsets in the action frames, the beacons and action frames would contradict, and that
> would not be good either.
> 
> So I thought it is easier to forbid this case and avoid this mess. :)

Oh, hmm. ok.

> > And why disallow switching bandwidth (was above this code)? That doesn't
> > seem right either?
> 
> IEEE 802.11-2012 10.9.8.3 says:
> 
> "A 20/40 MHz IBSS cannot be changed to a 20 MHz IBSS, and a 20 MHz IBSS cannot be changed to a 20/40 MHz IBSS."

Interesting, I wonder why they say that.

> Also I don't want to allow to switch to a 5 MHz/10 MHz channel or other funky stuff.

Obviously.

> TBH I don't understand the TSF magic completely, but as far as I know it is
> used for IBSS cell merging. What we don't want is to change the tsf when
> generating the new beacon and therefore (accidently) kick of some merging process.
> Therefore I'm keeping the TSF just as in ieee80211_sta_join_ibss().
> 
> ieee80211_ibss_build_presp() needs to put in the beacon, so I need to supply some
> valid TSF, don't I?

Doesn't make much sense - the host can't put the TSF into the frame
accurately anyway so the device should be doing it ... anyway I guess
you're not changing this so let's not discuss it here.

> > > +static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
> > > +{
> > 
> > Is this some refactoring that should be separate? I don't see how it's
> > really related to CSA? Maybe I'm missing something?
> 
> The only relation is that I need it refactored for IBSS/CSA. Disconnecting for
> some reason and going back to search mode wasn't required so far.
> 
> I can put that in a separate patchset.

Please do. I also might have to make a patch to add some new driver API
and this would probably help there as well as making this particular
patch easier to read.

johannes

