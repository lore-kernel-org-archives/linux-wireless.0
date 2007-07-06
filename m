Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:48767 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760122AbXGFShc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 14:37:32 -0400
Received: by wa-out-1112.google.com with SMTP id v27so376379wah
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2007 11:37:32 -0700 (PDT)
Message-ID: <9e4733910707061137i5baf2d3fw7ad1469f46632520@mail.gmail.com>
Date: Fri, 6 Jul 2007 14:37:32 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: Multiple interfaces in mac80211
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200707062000.32741.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <1183726738.3779.2.camel@johannes.berg>
	 <9e4733910707060600x51f7b967p9ac6e1671f0713ef@mail.gmail.com>
	 <200707062000.32741.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/6/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Friday 06 July 2007, Jon Smirl wrote:
> > On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > On Fri, 2007-07-06 at 08:55 -0400, Jon Smirl wrote:
> > >
> > > > Yes, only interface is monitor.
> > > >
> > > > Here is something else that is odd.
> > > >
> > > > Beacons are reporting channel 1...
> > > >
> > > > But I am tuned to channel 10.
> > >
> > > That's fishy. What hardware?
> >
> > Ralink rt2x00usb
>
> Thats odd, are only beacons reported to be on channel 1?
> Because the channel for rx frames is automatically set when
> the channel is configured by mac80211.

The channel field appears to be uninitialized for beacon frames. When
I booted this time it is displaying channel 9 and I am on channel 10.

Other frames show channel 10 as expected.

>
> Directly after rt2x00lib has send the channel switch event to the
> driver the rt2x00dev->rx_status.channel value is updated...
>
> Ivo
>


-- 
Jon Smirl
jonsmirl@gmail.com
