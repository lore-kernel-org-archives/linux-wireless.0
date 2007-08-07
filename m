Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:52421 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967338AbXHGWDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 18:03:42 -0400
Date: Wed, 8 Aug 2007 00:03:41 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: further plan wrt. monitor interfaces
Message-ID: <20070807220341.GA24236@deine-taler.de>
References: <1186178959.13315.30.camel@johannes.berg> <46B3B2AD.1040509@gentoo.org> <20070804074616.GA17144@deine-taler.de> <1186395427.28655.56.camel@johannes.berg> <20070806212300.GA14347@deine-taler.de> <1186480002.4067.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1186480002.4067.28.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> > A bunch
> > of parameters are already set with a single function, only config
> > and config_interface need to be replaced by parameter-specific
> > functions. Reset should be removed. 
> 
> Not sure what reset is for.

Now, we are at least two.

> > add_interface() and
> > remove_interface() are comparable to my enable_mac() and
> > disable_mac() as you discovered. 
> 
> Aha, but they're not fully compatible. First of all, you were talking
> about multiple MACs which isn't something we're going to support
> (multiple MAC addresses yes).

I would state we should the support the functionality that the
device supports. Everything else is "form follows function". 

> Secondly, a WDS and AP interface will be
> running with the same MAC address but have quite different
> configuration. Thirdly, always doing lookups by MAC address (even if it
> were possible which it is not due to WDS vs AP) is rather inefficient.

The MAC address lookup issue could be handled. 

Assuming that the device would be able to create beacons on a
specific MAC address, would it need to know about WDS or AP mode?

> > Tell the driver on the real interface, which packets it should
> > report to the mac80211 stack. 
> 
> That's what I proposed.
> 
> > Don't bother the driver with virtual
> > interfaces. The stack should handle it completely transparently.
> 
> What I'm trying to explain to you is that basically you cannot do that.
> AP vs WDS interfaces, lookups by MAC address, beaconing, ...

Beaconing needs to be supported by the device. AP and WDS are
working on the same MAC address, but why should the people know
about it. It doesn't look into the packets transmitted.

> > Don't call the driver before open() or after stop() is called.
> 
> Do we do that? In any case, it's rather orthogonal to the issue at hand.

Sure. Some drivers support the configuration of the channel before
the device is up. There has been the request for the zd1211rw
driver to shadow the configuration in the device data structure.
But I believe that is something the stack should handle.

Ciao,

Uli

-- 
Uli Kunitz
