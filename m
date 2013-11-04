Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([83.151.30.3]:48736 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab3KDOb6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 09:31:58 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [RFC] mac80211: don't transmit beacon with CSA count 0
Date: Mon, 4 Nov 2013 15:31:56 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
References: <1383569955-13236-1-git-send-email-luciano.coelho@intel.com> <201311041436.51673.sw@simonwunderlich.de> <1383574023.5928.149.camel@porter.coelho.fi>
In-Reply-To: <1383574023.5928.149.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311041531.56693.sw@simonwunderlich.de> (sfid-20131104_153202_006050_EDEEBE96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Luca,

> > 
> > Thanks for checking back - I've read the part in the spec again [1], and
> > appearently you are right.
> > 
> > With your proposed change, shouldn't we also change the behaviour if the
> > userspace requests a channel switch with count = 0? I guess we should
> > immediately change the channel then without waiting for beacons? I don't
> > see the point in changing the beacons if we don't send them, after all.
> 
> You're right, changing the beacons doesn't make sense in this case.
> I'll change that and send v2.
> 
> Another thing is that we are missing the action frames.  The idea with
> the count == 0 is that the STA's should start listening on the other
> channel immediately after receiving the action frame (because the switch
> will happen at any time).
> 
> If we don't send the action frame, passing context == 0 from the
> userspace doesn't much make sense, because the clients won't know we're
> switching.  Well, maybe it makes a bit of sense, if there are no clients
> connected, but nevertheless.

Yeah, switching without actionframe and count == 0 is pretty useless.

> 
> count == 0 should probably be avoided, because the specs are not that
> clear about it.  In case transmission on our channel needs to be stopped
> immediately (eg. with DSS), we can always use the channel switch mode
> (ie. no TX until the switch happens).

Hmm, we probably need to review the IBSS part too - we adopt the channel 
switch from others here, and adopting with count = 0 works now but would 
create a warning with your change ...

> 
> I'll probably start looking into the action frame implementation soon.

I've recently added CSA action frame support for the IBSS mode, because the 
distributed beaconing may lead to slow adoption of the CSA IEs in the IBSS. 
Check ieee80211_send_action_csa() for that. I guess it would be useful to send 
at least the action frames out if we want to change "fast" (count=0).

For AP mode, I guess the right place to implement the action frames would be 
hostap? This would at least allow great flexibility with CSA, ECSA and all the 
new channel switch IEs coming now. The beacons are also generated in 
userspace, after all.

BTW, I've just checked and the WiFi Alliance requires at least 5 beacons with 
CSA-IEs to pass the 802.11h test. :)

> 
> > Currently,
> > ath9k calls the csa_finish() after checking whether beacon sending was
> > complete ... so this would have to be changed.
> 
> Yeah, that's what I suspected from my very quick look at the ath9k code.
> I'll see if I can change this easily.  I'll probably need some help with
> testing, because I don't have an ath9k device. :\

No problem, I can test here, just tell me what to test. :)

Cheers,
    Simon
