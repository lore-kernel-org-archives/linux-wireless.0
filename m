Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33667 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbZEUQcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 12:32:10 -0400
Subject: Re: rfkill vs. interface up
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
In-Reply-To: <1242921924.4212.11.camel@johannes.local>
References: <1242736331.4797.22.camel@johannes.local>
	 <1242920389.14369.16.camel@localhost.localdomain>
	 <1242921924.4212.11.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 21 May 2009 12:32:07 -0400
Message-Id: <1242923527.14369.29.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-21 at 18:05 +0200, Johannes Berg wrote:
> On Thu, 2009-05-21 at 11:39 -0400, Dan Williams wrote:
> 
> > That proposal sounds fine to me from a userspace perspective.  Sane
> > implementations don't assume the interface is IFF_UP when they configure
> > the device anyway (since it's not necessarily up at boot time or after
> > hibernate for example), and since you need a reconfigure after rfkill,
> > this seems reasonable.
> > 
> > You wouldn't have to give up on txpower either, you could simply map
> > 'txpower off' to SW-rfkill, and 'txpower on' to un-SW-rfkill, where of
> > course the interface would be !IFF_UP after 'txpower on' just like
> > flipping the killswitch would.
> 
> Yeah, good point, that sounds better than having to give up on it -- the
> key though is that we can't recover IFF_UP state when that happens; if
> that's ok this should be fairly simple.

I don't think recovering IFF_UP needs to be done by the kernel.  rfkill
already hoses the card state anyway, requiring a full setup by
userspace, which usually includes ensuring the device is up (which, for
example, both NM and wpa_supplicant have done since the beginning of
time).

Dan

