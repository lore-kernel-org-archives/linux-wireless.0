Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48222 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1DZTPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 15:15:46 -0400
Date: Tue, 26 Apr 2011 15:12:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 1/2] mac80211: allow low level drivers to report packet
 loss
Message-ID: <20110426191247.GJ2804@tuxdriver.com> (sfid-20110426_211550_341199_5D97182F)
References: <1303125749-31967-1-git-send-email-arik@wizery.com>
 <1303129610.3588.7.camel@jlt3.sipsolutions.net>
 <BANLkTikc9wrZ__8URZ3ASQ6F=rUHix2iGA@mail.gmail.com>
 <1303216566.3603.6.camel@jlt3.sipsolutions.net>
 <BANLkTik81g3NOwHcQk2eqOcMjaubCLdk+w@mail.gmail.com>
 <1303286933.3619.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303286933.3619.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 20, 2011 at 10:08:53AM +0200, Johannes Berg wrote:
> On Wed, 2011-04-20 at 00:54 +0300, Arik Nemtsov wrote:
> 
> > > That's your choice, but I wouldn't do it. You'll have to support TX
> > > status when requested, otherwise AP operation won't work, so you need
> > > the code anyway.
> > 
> > Can you elaborate why?
> > 
> > I'm assuming you mean the removal of
> > IEEE80211_HW_REPORTS_TX_ACK_STATUS (in the second patch of this
> > series). Note that it was only added recently, and AP/STA modes seemed
> > to work fine without it.
> > From a look in the code it seems this flag helps with connection
> > monitoring in STA mode. The other use is determining the current PS
> > mode when IEEE80211_HW_PS_NULLFUNC_STACK is enabled. These two are
> > done by HW in wl12xx cards.
> 
> Well, there's the flag saying "you can rely on it", but there's also the
> fact that AP mode relies on status for (some) frames anyway. So if you
> just want to remove the flag I guess that's OK, but if you want to
> remove all status processing .. that'll cause issues with AP mode.

Do the wl12xx guys still want this?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
