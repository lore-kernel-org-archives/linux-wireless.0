Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:2510 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761461AbXGFVNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 17:13:38 -0400
Received: by ug-out-1314.google.com with SMTP id j3so788228ugf
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2007 14:13:36 -0700 (PDT)
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: Multiple interfaces in mac80211
Date: Fri, 6 Jul 2007 23:16:29 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com> <200707062000.32741.IvDoorn@gmail.com> <9e4733910707061137i5baf2d3fw7ad1469f46632520@mail.gmail.com>
In-Reply-To: <9e4733910707061137i5baf2d3fw7ad1469f46632520@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707062316.30009.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 July 2007, Jon Smirl wrote:
> On 7/6/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > On Friday 06 July 2007, Jon Smirl wrote:
> > > On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > > On Fri, 2007-07-06 at 08:55 -0400, Jon Smirl wrote:
> > > >
> > > > > Yes, only interface is monitor.
> > > > >
> > > > > Here is something else that is odd.
> > > > >
> > > > > Beacons are reporting channel 1...
> > > > >
> > > > > But I am tuned to channel 10.
> > > >
> > > > That's fishy. What hardware?
> > >
> > > Ralink rt2x00usb
> >
> > Thats odd, are only beacons reported to be on channel 1?
> > Because the channel for rx frames is automatically set when
> > the channel is configured by mac80211.
> 
> The channel field appears to be uninitialized for beacon frames. When
> I booted this time it is displaying channel 9 and I am on channel 10.
> 
> Other frames show channel 10 as expected.

Which is quite weird since the beacon frames use the same rx_status structure
as the regular frames. No distinction is made within rt2x00 between rx frames...

Ivo

