Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:28815 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbXJIRQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 13:16:24 -0400
Received: by ug-out-1314.google.com with SMTP id z38so138305ugc
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2007 10:16:23 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] Mode selection in mac80211
Date: Tue, 9 Oct 2007 19:32:45 +0200
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200710052319.10600.linux@baker-net.org.uk> <200710091627.44276.IvDoorn@gmail.com> <1191949526.4013.34.camel@johannes.berg>
In-Reply-To: <1191949526.4013.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710091932.45235.IvDoorn@gmail.com> (sfid-20071009_181631_430496_4E2BC8BF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 October 2007, Johannes Berg wrote:
> On Tue, 2007-10-09 at 16:27 +0200, Ivo van Doorn wrote:
> 
> > The IFS is also passed on as argument by mac80211 when it configures the
> > TX rings. The EIFS register is something different, all other Ralink devices
> > have only 1 value for the EIFS. I am not even sure how the device will react
> > when the same value is set for rt2500usb.
> 
> Ok but IFS definitely needs to be set. EIFS I'm not entirely sure about,
> haven't looked at the timing diagrams for a long time.

Well that is my point, if the documentation is correct then rt2500usb
has 2 locations to initialize the IFS. So it would always be set and the question
would be what the impact would be to set the IFS per packet only.
But that is something I need to test with just some experiments.

> > I guess it requires some experimentation to see if initializing those
> > 2 registers differently has any effect. (And if it doesn't, then rt2500usb doesn't
> > require to know whether it is operating in B or G mode at all).
> 
> That won't be easy to tell, but the IFS is different afaik so there the
> mode has an influence. But I think that this mode setting need not be
> tied to the frequency table.

Well I just had another thought about this:
Legacy driver only makes the difference when it is configured to use
802.11B it doesn't make this difference for the CCK rates.
This means that the device would be able to operate correctly for
802.11B even with the 802.11G timing initialization. Because according
to the way the legacy driver is setup, working in 802.11G while working
with the CCK rates would be possible.
This also means associating to 802.11B AP's while in 802.11G mode.
So we might be making a big deal out of something while the source
of the problem is very simple:  The legacy driver code is just wrong. ;)

Ivo
