Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaEGGjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 02:39:53 -0400
Message-ID: <1399444778.5038.3.camel@jlt4.sipsolutions.net> (sfid-20140507_083956_903969_68B8B77C)
Subject: Re: [PATCH 1/4] cfg80211/nl80211: add channel switch started and
 failed notifications
From: Johannes Berg <johannes@sipsolutions.net>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Luca Coelho <luca@coelho.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Wed, 07 May 2014 08:39:38 +0200
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A0333F3C57@HASMSX106.ger.corp.intel.com>
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
	 <1399373244.4218.21.camel@jlt4.sipsolutions.net>
	 <CB3B3D4774441E42AA3EA0E1BA8230A0333F3C57@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 06:08 +0000, Peer, Ilan wrote:

> > I'm not really sure why you have this - it seems that in this case the interface
> > will be stopped so you'll get a STOP_AP or DISCONNECT or whatever other
> > notification. This may not actually be completely true right now (I seem to
> > remember a fix in this area but can't seem to find it in my tree!!) but we'll
> > have to fix that part anyway. Not really sure why then that couldn't be used
> > instead of this notification? The userspace code is going to have to worry
> > about that anyway, I'd think.
> > 
> 
> At least for AP/GO, there are cases that a failed channel switch
> should not necessarily trigger a STOP_AP flow. For example, in case
> that multi-channel is supported, wpa_supplicant might request a
> channel switch to try to switch an AP/GO interface to a channel used
> by a station interface (to avoid multi channel operation), but in case
> that such a transition fails, it is still a valid to continue to use
> current channel and do not stop the GO. In such a case, it would be
> useful to get a failure notification. Generally, I think that since
> hostapd/wpa_supplicant have started the channel switch, it might be
> better to have them handle a notification and take the appropriate
> action (if needed stop the AP/GO ...). 

I don't understand this - there are two ways the channel switch can
fail:

 * the request fails
   this just returns an error code to userspace during the request,
there's no
   notification even with these patches
 * the request succeeds, but real switch fails
   we beacon with the CSA, counting it down etc., but when it comes to
actually
   switching, the switch fails. This should hopefully be rather
unlikely, but if
   it really happens the only thing we can do to recover (and actually
do now
   after Michal's patches) is to STOP_AP

In the first case, there's no notification, nor any need for it. In the
second case, the scenario you suggest doesn't apply, and STOP_AP has to
happen anyway because the state is completely messed up, clients will be
in the process of switching etc.

> Other than that, a STOP_AP might introduce some races, as
> wpa_supplicant/hostap will not know if the stop_ap was due to the
> failed CS or due to some other reason.

I don't see why that would matter - even if the STOP_AP *was* for some
other reason, but happened in the middle of the CS flow, the reaction
would presumably be the same?

johannes

