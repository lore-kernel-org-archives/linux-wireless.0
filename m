Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53151 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbbCaO1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 10:27:54 -0400
Message-ID: <1427812067.2057.27.camel@sipsolutions.net> (sfid-20150331_162758_327425_7F26E55C)
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 31 Mar 2015 16:27:47 +0200
In-Reply-To: <5500AE12.6040103@candelatech.com>
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>
	 	  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>
	 	 <54EB66CC.1030800@candelatech.com>
	  <1424772714.2192.16.camel@sipsolutions.net>
	  <54EC8C5D.5090400@candelatech.com>
	 <1424788834.2192.34.camel@sipsolutions.net>
	 <5500AE12.6040103@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 14:05 -0700, Ben Greear wrote:

> I took a look at the hw-scan code a bit...I guess we might could do additional
> info calls to user-space as we iterate through the channels while scanning?
> 
> A real driver would be causing the NIC to change channels at these junctures,
> either by directly setting registers or sending some message off to the
> target NIC's cpu, right?

Well, depends. Our driver just asks the firmware to do the scan, and it
will do all the scheduling by itself, i.e. it'll go through the channels
at convenient times etc.

> I would assume that off-channel work could do similar logic.

Yeah.

> Is that the sort of thing you had in mind?

To be honest, I'm not really sure myself. It seems to really do this
you'd also need powersave handling (tell the AP you're going to sleep
when scanning) and potentially P2P-GO NoA handling (tell the clients
you're going to sleep).

The thing with hwsim right now is that it totally makes use of its
ability to be on as many channels at the same time as it wants, so it
doesn't have to worry about that, but if you want to actually have the
channel "changed" then we need to handle a lot more details.

johannes

