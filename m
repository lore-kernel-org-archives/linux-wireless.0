Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:46961 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932693AbaEMKbf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 06:31:35 -0400
Message-ID: <1399977086.7968.12.camel@dubbel> (sfid-20140513_123141_019566_2BBF8714)
From: Luca Coelho <luca@coelho.fi>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Tue, 13 May 2014 13:31:26 +0300
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A0333F4475@HASMSX106.ger.corp.intel.com>
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
	 <1399373244.4218.21.camel@jlt4.sipsolutions.net>
	 <CB3B3D4774441E42AA3EA0E1BA8230A0333F3C57@HASMSX106.ger.corp.intel.com>
	 <1399444778.5038.3.camel@jlt4.sipsolutions.net>
	 <CB3B3D4774441E42AA3EA0E1BA8230A0333F41ED@HASMSX106.ger.corp.intel.com>
	 <1399461582.10517.18.camel@jlt4.sipsolutions.net>
	 <CB3B3D4774441E42AA3EA0E1BA8230A0333F4475@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 1/4] cfg80211/nl80211: add channel switch started and
 failed notifications
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally got the time to come back to this...

On Wed, 2014-05-07 at 11:55 +0000, Peer, Ilan wrote:
> 
> 
> > -----Original Message-----
> > From: Johannes Berg [mailto:johannes@sipsolutions.net]
> > Sent: Wednesday, May 07, 2014 14:20
> > To: Peer, Ilan
> > Cc: Luca Coelho; linux-wireless@vger.kernel.org; michal.kazior@tieto.com;
> > Otcheretianski, Andrei
> > Subject: Re: [PATCH 1/4] cfg80211/nl80211: add channel switch started and
> > failed notifications
> > 
> > On Wed, 2014-05-07 at 10:27 +0000, Peer, Ilan wrote:
> > 
> > > > In the first case, there's no notification, nor any need for it. In
> > > > the second case, the scenario you suggest doesn't apply, and STOP_AP
> > > > has to happen anyway because the state is completely messed up,
> > > > clients will be in the process of switching etc.
> > > >
> > > > > Other than that, a STOP_AP might introduce some races, as
> > > > > wpa_supplicant/hostap will not know if the stop_ap was due to the
> > > > > failed CS or due to some other reason.
> > > >
> > > > I don't see why that would matter - even if the STOP_AP *was* for
> > > > some other reason, but happened in the middle of the CS flow, the
> > > > reaction would presumably be the same?
> > > >
> > >
> > > It can be beneficial to know that the STOP_AP was called due to
> > > failure of CS, as wpa_supplicant/hostap can tear down the AP and then
> > > (if possible) set it up again on the new channel or another channel.
> > 
> > Maybe that's more of an argument for adding a sort of "reason" or "cause" to
> > the STOP_AP? (Btw, no tear down needed in this case - that's already done)
> > 
> 
> Yes :)
> 
> > OTOH, what else are you thinking of doing? Why would you ever, under any
> > circumstances, not restart the AP if it was stopped by the device?
> 
> Actually this is the default today: on STOP_AP notification a GO interface is simply deleted, as the assumption is that something unrecoverable happened. In case of CS failure, it would be *nice* to know if the failure is recoverable or not.

Okay, so this is what I'll do:

* remove the failed notifications
* in a new patch, add a reason attribute to the STOP_AP notification;

--
Luca.

