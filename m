Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:15802 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbYDJQ7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 12:59:23 -0400
Received: by mu-out-0910.google.com with SMTP id i10so108321mue.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2008 09:59:21 -0700 (PDT)
To: Bas Hulsken <bhulsken@hotmail.com>
Subject: Re: hostapd hangs on rt2500pci, leaving the nic in an unstable state
Date: Thu, 10 Apr 2008 18:59:49 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1207412527.6965.21.camel@Bas> <200804091933.03615.IvDoorn@gmail.com> <1207845596.2907.2.camel@Bas>
In-Reply-To: <1207845596.2907.2.camel@Bas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804101859.50470.IvDoorn@gmail.com> (sfid-20080410_175927_583121_3412B1A8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 April 2008, Bas Hulsken wrote:
> Hi,
> 
> On Wed, 2008-04-09 at 19:33 +0200, Ivo van Doorn wrote:
> 
> > > Does the patch by Daniel Wagner:
> > > 	rt61pci: rt61pci_beacon_update do not free skb twice
> > > which was send to the linux-wireless mailing list today help?
> > 
> > wait never mind, that was a stupid comment since you are using rt2500pci... :S
> > I'll see if the patch also is applicable for rt2500pci and post that patch if that is
> > the case. :)
> 
> I assume the patch as it applies to rt2500pci is this one: "rt2x00: Only
> free skb when beacon_update fails"

Not really, it was something I found while looking through the beaconing code,
the rt61pci was indeed something that only was bugged in rt61pci, the other
drivers did the beacon handling correctly.

> I've tried it, and it does not solve the problem, still exactly the same
> hang as before.

I expected as much, I'm still looking into other causes for this bug.

Ivo
