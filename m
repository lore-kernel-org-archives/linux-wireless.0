Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:60807 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbXJIRhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 13:37:45 -0400
Received: by ug-out-1314.google.com with SMTP id z38so142344ugc
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2007 10:37:43 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] Mode selection in mac80211
Date: Tue, 9 Oct 2007 19:54:03 +0200
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200710052319.10600.linux@baker-net.org.uk> <200710091932.45235.IvDoorn@gmail.com> <1191950973.4013.45.camel@johannes.berg>
In-Reply-To: <1191950973.4013.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710091954.03727.IvDoorn@gmail.com> (sfid-20071009_183750_698026_CBC543AE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 October 2007, Johannes Berg wrote:
> On Tue, 2007-10-09 at 19:32 +0200, Ivo van Doorn wrote:
> 
> > Well that is my point, if the documentation is correct then rt2500usb
> > has 2 locations to initialize the IFS. So it would always be set and the question
> > would be what the impact would be to set the IFS per packet only.
> > But that is something I need to test with just some experiments.
> 
> Well, it's not too strange that it has two places since there's the SIFS
> too which is needed for ACK/CTS timing, these packets aren't sent from
> the host so you can't have those timings in a per-packet descriptor.

You mean things like ACK_TIMEOUT, those are all seperate registers in the Ralink hardware.
ButI think I should be more clearer on this, rt2500pci and rt2500usb are
basically the same chipset but only the bus type is different.
What is notable is that _only_ rt2500usb has this IFS register, none of the
other Ralink chipsets (including rt2500pci) have it.

> > This means that the device would be able to operate correctly for
> > 802.11B even with the 802.11G timing initialization. Because according
> > to the way the legacy driver is setup, working in 802.11G while working
> > with the CCK rates would be possible.
> > This also means associating to 802.11B AP's while in 802.11G mode.
> > So we might be making a big deal out of something while the source
> > of the problem is very simple:  The legacy driver code is just wrong. ;)
> 
> Well, no, if you have a pure 802.11B AP then you have to use the 11B
> slot timing, if you have a G AP then it'll tell you which timing to use
> (I think)

True, but in G mode you are compatible with B. The legacy driver doesn't
switch back to B mode when the AP is in B mode. This means that it will
be using the G timing values.
Even if the G AP is telling which timing it is using, it is ignored by the
legacy driver since the timing value is hardcoded for both B as G mode.

Ivo
