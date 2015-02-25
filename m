Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:61345 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbbBYObH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 09:31:07 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>, Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ArikX Nemtsov" <arik@wizery.com>
Subject: RE: [PATCH v6 1/2] cfg80211: Add API to change the indoor
	regulatory setting
Date: Wed, 25 Feb 2015 14:30:40 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04D02200C@HASMSX106.ger.corp.intel.com> (sfid-20150225_153114_440671_88239FD0)
References: <1424224284-17377-1-git-send-email-ilan.peer@intel.com>
 <1424577430-24382-1-git-send-email-ilan.peer@intel.com>
 <20150224000317.GO20824@wotan.suse.de>
In-Reply-To: <20150224000317.GO20824@wotan.suse.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@suse.com]
> Sent: Tuesday, February 24, 2015 02:03
> To: Peer, Ilan; Jouni Malinen
> Cc: linux-wireless@vger.kernel.org; ArikX Nemtsov
> Subject: Re: [PATCH v6 1/2] cfg80211: Add API to change the indoor
> regulatory setting
> 
> On Sat, Feb 21, 2015 at 10:57:10PM -0500, Ilan Peer wrote:
> > Previously, the indoor setting configuration assumed that as long as a
> > station interface is connected, the indoor environment setting does
> > not change. However, this assumption is problematic
> > as:
> >
> > - It is possible that a station interface is connected to a mobile
> >   AP, e.g., softAP or a P2P GO, where it is possible that both the
> >   station and the mobile AP move out of the indoor environment making
> >   the indoor setting invalid. In such a case, user space has no way to
> >   invalidate the setting.
> 
> At the protocol level should we consider the need for a dynamic environment
> change? Until then a change of environment likely should implicate an AP
> disconnect, which is what Linux does. With your changes in place we could do
> something even more graceful should the protocol allow for it.
> 

Not sure I follow ...

> For instance if the regulatory parameters for a country are the same for
> indoor and outdoro a change in environment should not require a disconnect.
> 

So you are suggesting to extend the mechanism to also indicate if a teardown
of active interfaces is needed or not? And if so, not sure that this should be done by
the kernel.

> If the change was from a more restrictive environment to a more liberal set of
> regulatory settings it could mean increasing TX power of the AP changing to a
> channel which perhaps was not allowed before.
> 

I think that such a flow needs to be handled in user-space by hostapd, which can
leverage the proper mechanisms to do the change, e.g., eCSA. 

> If the change was from a less restrictive environment to a more restrictive
> environment the AP might want to change channels for instance or reduce TX
> power.
> 

Same as above. For example, hostapd handles DFS related channel changes in
user space. We also added flows to handle channel switch etc. in wpa_supplicant ...
and I need to resubmit them to hostap.

> While change in indoor/outdoor might be something silly to consider given
> the likelihood of it being a common thing to happen that you change an AP
> from indoor / outdoor regularly I'd consider instead the possibility to reuse
> such a dynamic environment change notification for purposes of dynamic
> environmental adjustments of BSSes. Typically BSSes settings are static but RF
> environments change regularly so its silly to expect a BSS and its initial
> Automatic Channel Selection algorithm to be corrrect during the lifetime of a
> BSS.
> 
> > - A station interface disconnection does not necessarily imply that
> >   the device is no longer operating in an indoor environment, e.g.,
> >   it is possible that the station interface is roaming but is still
> >   stays indoor.
> 
> Sure.
> 
> You also fail to explain how we currently provide the indoor thing to the
> kernel, I think its worth providing that in the commit log and also explaining
> how we don't use the country IE environment thing at all.
> 

I explained some of the use cases in previous patches, e.g., AC power,
device type etc. I can add this, but I do not understand how country IE is related
here.

> > To handle the above, extend the indoor configuration API to allow user
> > space to indicate a change of indoor settings, and allow it to
> > indicate weather it controls the indoor setting, such that:
> >
> > 1. If the user space process explicitly indicates that it is going
> >    to control the indoor setting, do not clear the indoor setting
> >    internally, unless the socket is released. The user space process
> >    should use the NL80211_ATTR_SOCKET_OWNER attribute in the command
> >    to state that it is going to control the indoor setting.
> > 2. Reset the indoor setting when restoring the regulatory settings in
> >    case it is not owned by a user space process.
> >
> > While at it directly update the indoor setting without wrapping it as
> > a regulatory request, to simplify the processing.
> 
> Please wrap that specific change into its own separate commit, it will make it
> easier to review the changes and also make this change atomic.
> 

Ok.

Thanks,

Ilan.
