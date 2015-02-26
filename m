Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61233 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbBZQJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 11:09:02 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ArikX Nemtsov <arik@wizery.com>
Subject: RE: [PATCH v6 1/2] cfg80211: Add API to change the indoor
	regulatory setting
Date: Thu, 26 Feb 2015 16:08:52 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04D0231F9@HASMSX106.ger.corp.intel.com> (sfid-20150226_170908_105985_F548AC1F)
References: <1424224284-17377-1-git-send-email-ilan.peer@intel.com>
 <1424577430-24382-1-git-send-email-ilan.peer@intel.com>
 <20150224000317.GO20824@wotan.suse.de>
 <CB3B3D4774441E42AA3EA0E1BA8230A04D02200C@HASMSX106.ger.corp.intel.com>
 <20150226020758.GF8749@wotan.suse.de>
In-Reply-To: <20150226020758.GF8749@wotan.suse.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Luis R. Rodriguez
> Sent: Thursday, February 26, 2015 04:08
> To: Peer, Ilan
> Cc: Jouni Malinen; linux-wireless@vger.kernel.org; ArikX Nemtsov
> Subject: Re: [PATCH v6 1/2] cfg80211: Add API to change the indoor
> regulatory setting
> 
> On Wed, Feb 25, 2015 at 02:30:40PM +0000, Peer, Ilan wrote:
> > Hi Luis,
> >
> > > -----Original Message-----
> > > From: Luis R. Rodriguez [mailto:mcgrof@suse.com]
> > > Sent: Tuesday, February 24, 2015 02:03
> > > To: Peer, Ilan; Jouni Malinen
> > > Cc: linux-wireless@vger.kernel.org; ArikX Nemtsov
> > > Subject: Re: [PATCH v6 1/2] cfg80211: Add API to change the indoor
> > > regulatory setting
> > >
> > > On Sat, Feb 21, 2015 at 10:57:10PM -0500, Ilan Peer wrote:
> > > > Previously, the indoor setting configuration assumed that as long
> > > > as a station interface is connected, the indoor environment
> > > > setting does not change. However, this assumption is problematic
> > > > as:
> > > >
> > > > - It is possible that a station interface is connected to a mobile
> > > >   AP, e.g., softAP or a P2P GO, where it is possible that both the
> > > >   station and the mobile AP move out of the indoor environment making
> > > >   the indoor setting invalid. In such a case, user space has no way to
> > > >   invalidate the setting.
> > >
> > > At the protocol level should we consider the need for a dynamic
> > > environment change? Until then a change of environment likely should
> > > implicate an AP disconnect, which is what Linux does. With your
> > > changes in place we could do something even more graceful should the
> protocol allow for it.
> > >
> >
> > Not sure I follow ...
> 
> OK right now we should disconnect if there are some regulatory params that
> do not agree. This event will also ony happen *rarely*. Even though this
> happens rarely I can find use for forcing this to happen in a not so rare case to
> help optimize RF spectrum use dynamically, if the protocol had a way to
> communicate a desired change in environment this could be reused for a
> dynaic RF spectrum change in environment.
> 

I think that RF spectrum changes are addressed in some extend in 11h, 11k and 11v etc. So maybe
What you are looking for is already there.

> > > For instance if the regulatory parameters for a country are the same
> > > for indoor and outdoro a change in environment should not require a
> disconnect.
> > >
> >
> > So you are suggesting to extend the mechanism to also indicate if a
> > teardown of active interfaces is needed or not? And if so, not sure
> > that this should be done by the kernel.
> 
> If the AP *knew* a change in environment (now forget indoor/outdoor as that
> is rare today) was not disruptive this could be information that the STAs can
> get to use to evaluate and make a better decision as to whether or not it did
> need to tear down or not.
> 
> > > If the change was from a more restrictive environment to a more
> > > liberal set of regulatory settings it could mean increasing TX power
> > > of the AP changing to a channel which perhaps was not allowed before.
> > >
> >
> > I think that such a flow needs to be handled in user-space by hostapd,
> > which can leverage the proper mechanisms to do the change, e.g., eCSA.
> 
> Right but that's the AP, how would the STAs get that information? This is why I
> mentioned the idea of a possible protocol enhancement to let the AP inform
> STAs of an environmental change. The AP *could* feed more than just the
> boring parameters we're used to. Its OK this is just an idea, ignore it.
> 

I think that APs (at least what the spec allows) have mechanisms to inform the client
on some change such as channel switch, operational bandwidth (11ac), tx power control etc.

> > > If the change was from a less restrictive environment to a more
> > > restrictive environment the AP might want to change channels for
> > > instance or reduce TX power.
> > >
> >
> > Same as above. For example, hostapd handles DFS related channel
> > changes in user space. We also added flows to handle channel switch etc. in
> wpa_supplicant ...
> > and I need to resubmit them to hostap.
> 
> OK..
> 
> > > While change in indoor/outdoor might be something silly to consider
> > > given the likelihood of it being a common thing to happen that you
> > > change an AP from indoor / outdoor regularly I'd consider instead
> > > the possibility to reuse such a dynamic environment change
> > > notification for purposes of dynamic environmental adjustments of
> > > BSSes. Typically BSSes settings are static but RF environments
> > > change regularly so its silly to expect a BSS and its initial
> > > Automatic Channel Selection algorithm to be corrrect during the lifetime
> of a BSS.
> > >
> > > > - A station interface disconnection does not necessarily imply that
> > > >   the device is no longer operating in an indoor environment, e.g.,
> > > >   it is possible that the station interface is roaming but is still
> > > >   stays indoor.
> > >
> > > Sure.
> > >
> > > You also fail to explain how we currently provide the indoor thing
> > > to the kernel, I think its worth providing that in the commit log
> > > and also explaining how we don't use the country IE environment thing at
> all.
> > >
> >
> > I explained some of the use cases in previous patches, e.g., AC power,
> > device type etc. I can add this, but I do not understand how country
> > IE is related here.
> 
> Mention it and the country IE is important given its the other place folks
> expect it to be deduced from -- and we don't use it at all. Without that
> information folks can assume we do unless they are familiar with the code.
> It provides useful context for your change, even for me!
> 

Done.

Thanks,

Ilan.
