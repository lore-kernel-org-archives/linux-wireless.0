Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:3490 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbXGFR5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 13:57:43 -0400
Received: by ug-out-1314.google.com with SMTP id j3so756131ugf
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2007 10:57:41 -0700 (PDT)
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: Multiple interfaces in mac80211
Date: Fri, 6 Jul 2007 20:00:32 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com> <1183726738.3779.2.camel@johannes.berg> <9e4733910707060600x51f7b967p9ac6e1671f0713ef@mail.gmail.com>
In-Reply-To: <9e4733910707060600x51f7b967p9ac6e1671f0713ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707062000.32741.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 July 2007, Jon Smirl wrote:
> On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2007-07-06 at 08:55 -0400, Jon Smirl wrote:
> >
> > > Yes, only interface is monitor.
> > >
> > > Here is something else that is odd.
> > >
> > > Beacons are reporting channel 1...
> > >
> > > But I am tuned to channel 10.
> >
> > That's fishy. What hardware?
> 
> Ralink rt2x00usb

Thats odd, are only beacons reported to be on channel 1?
Because the channel for rx frames is automatically set when
the channel is configured by mac80211.

Directly after rt2x00lib has send the channel switch event to the
driver the rt2x00dev->rx_status.channel value is updated...

Ivo
