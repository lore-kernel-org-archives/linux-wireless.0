Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbaBSOoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 09:44:19 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"Spinadel, David" <david.spinadel@intel.com>
Subject: RE: [PATCH v3 1/6] cfg80211: Add indoor only and GO concurrent
 channel attributes
Date: Wed, 19 Feb 2014 14:44:14 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A033382369@HASMSX106.ger.corp.intel.com> (sfid-20140219_154423_044282_200C5EC0)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-2-git-send-email-ilan.peer@intel.com>
 <20140218224950.GA14296@garbanzo.do-not-panic.com>
In-Reply-To: <20140218224950.GA14296@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Thanks for the comments.

Ilan.

> > + * @IEEE80211_CHAN_INDOOR_ONLY: Only indoor use is permitted on
> this channel.
> > + *	A channel marked with IEEE80211_CHAN_INDOOR_ONLY can only be
> used when
> > + *	there is a clear assessment that the device is operating in an indoor
> > + *	surroundings, i.e., it is connected to AC power (and not through
> > + *	portable DC inverters)
> 
> Curious, what are the plans to avoid the situation of portable DC inverters
> from being used in this case ? Stating that is in the documentation alludes
> that this is possible in userspace.
> 
> Is it?
> 

The motivation here was to allow this in cases that the device is truly an indoor device such as media center etc. I am not aware of plans to avoid such situations. Will take this with our regulatory people.

> > or is under the control of a master that is
> > + *	acting as an AP and is connected to AC power.
> > + * @IEEE80211_CHAN_GO_CONCURRENT: GO operation is allowed on this
> channel if
> > + *	it's connected concurrently to a BSS on the same channel on 2.4 or
> > + *	to a channel in the same UNII band on 5.2.
> 
> What do you mean "on 5.2" ? Maybe just "the 5 GHz band" would be better
> if this is not UNII specific. If the rule applies to a UNII band then mentioning
> the band name nomenclature would make it clearer, ie, UNII-1, or UNII-2. If
> this flag could later be used by other 5 GHz UNII bands then making it in the
> documentation UNII band agnostic and just using 5 GHz would suffice, while
> your handler in code adjusts as regulations change.
> 

As far as I understand the concept of UNII bands, a UNII band is a group of channels/frequencies that share the same regulatory rules. Thus, if we are currently connected to a BSS on a channel in a specific UNII band, we can deduce that operating on all the channels in the same UNII band is allowed as these channels share the same operating rules as the channel we are currently connected to on the BSS interface. I'll rephrase the comment to better express so.

> > + *	Instantiating a GO on a channel marked with
> IEEE80211_CHAN_GO_CONCURRENT
> > + *	can be done when there is a clear assessment that the device is
> > + *	operating under the guidance of an authorized master, i.e., setting
> up a
> > + *	GO while the device is also connected to an AP with DFS and radar
> > + *	detection on the UNII band (however, this example does not imply
> that
> > + *	all channels marked with IEEE80211_CHAN_RADAR must also be
> marked with
> > + *	IEEE80211_CHAN_GO_CONCURRENT and vise versa).
> 
> Your mentioning of DFS here makes things a bit confusing. We should be
> distinguishing between the case of a device beign associated to on a BSS
> where the AP is on a DFS channel, and the case where the AP is not on a DFS
> channel. Are you saying that if IEEE80211_CHAN_GO_CONCURRENT is
> enabled on a channel that also has IEEE80211_CHAN_RADAR that the device
> can start GO on the same channel if it *doesn't support DFS itself* if its
> associated to a real AP, which presumably supports DFS? If so consider then a
> third GO which would associate to the secondary GO, we now have a link of 3
> devices and an inherent delay can be created letting a master device do
> things. How do we avoid latency issues in communication in this type of
> setup?
> 
> If IEEE80211_CHAN_GO_CONCURRENT is meant only for channels that do
> not have IEEE80211_CHAN_RADAR that makes it simpler but I think you were
> trying to clarify that daisy chaning trust on the root AP is valid.
> 
> Please clarify both use cases on the documentation.

Yep this required more clarification: the GO concurrent relaxation is intended for the NO_IR flag and not for the RADAR flag. If RADAR is set then a GO cannot be instantiated. I will clarify this in the documentation.

> 
> > diff --git a/include/uapi/linux/nl80211.h
> > b/include/uapi/linux/nl80211.h index 91054fd..06440ac 100644
> > --- a/include/uapi/linux/nl80211.h
> > +++ b/include/uapi/linux/nl80211.h
> > @@ -2304,6 +2304,11 @@ enum nl80211_band_attr {
> >   * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not
> 80+80) channel
> >   *	using this channel as the primary or any of the secondary channels
> >   *	isn't possible
> > + * @NL80211_FREQUENCY_ATTR_INDOOR_ONLY: Indoor only use is
> permitted
> > + *	on this channel in current regulatory domain.
> > + * @NL80211_FREQUENCY_ATTR_GO_CONCURRENT: GO operation is
> allowed on this
> > + *      channel if it's connected concurrently to a BSS on the same channel
> on
> > + *      2.4 or to a channel in the same UNII band on 5.2.
> 
> Same UNII band clarification applies here.
> 
>   Luis
