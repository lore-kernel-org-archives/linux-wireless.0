Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58952
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbXC1J4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:56:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
Date: Wed, 28 Mar 2007 11:55:51 +0200
Cc: Andy Green <andy@warmcat.com>, Jiri Benc <jbenc@suse.cz>,
	Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
References: <20070325231817.9C5887B409F@zog.reactivated.net> <200703262239.07013.mb@bu3sch.de> <1175073595.5151.28.camel@johannes.berg>
In-Reply-To: <1175073595.5151.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703281155.52208.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 March 2007 11:19, Johannes Berg wrote:
> On Mon, 2007-03-26 at 22:39 +0200, Michael Buesch wrote:
> 
> > Well, yeah. It does of course. If you have a STA and a MON interface,
> > the STA also receives the packs with bad CRCs. But that's how
> > mac80211 designed the virt-interface stuff.
> > Same goes for promisc. If you have a STA and a MON you can't have
> > the STA in non-promisc mode, so you also receive promisc packets on
> > the STA. That's how it's supposed to be. (I think mac80211 filters
> > them in the STA code somewhere).
> 
> Yeah, it filters those later by BSSID, that's intended, but it wasn't
> ever programmed to check the CRC. We'll need to introduce a new rx
> status flag "was crc checked".
> 
> > The modparams actually are just a temporary hack and were never meant
> > to stay there. I wanted to have the knob in cfg80211, sooner or later.
> > So when the knob is there, mac80211 should take care that the STA
> > doesn't receive the bad packets.

I think we need at least two "stages" for this config.
One that says: Get all packets with bad FCS
And one that says: Get all packets with bad FCS and everything else
that looks like a signal, which is probably your microwave oven, though.

So, when these packets are passed up the stack the PLCP is stripped.
I think we should make the stack aware of the PLCP (and add an RX flag
PLCP_available) so that it is able to check the PLCP checksum.
Otherwise the only way to detect your microwave oven from the packet
stream would be failed FCS. Which would also most likely failed then, but
I think it's probably useful for the user to see the PLCP, too, on
a mon interface.

So we need RX flags "PLCP_available" and "Not_checksummed".

-- 
Greetings Michael.
