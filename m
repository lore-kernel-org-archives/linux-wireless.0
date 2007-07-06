Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:62628 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXGFWdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 18:33:49 -0400
Received: by wx-out-0506.google.com with SMTP id h31so311545wxd
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2007 15:33:48 -0700 (PDT)
Message-ID: <1ba2fa240707061533u7db0eda4i2d76576690b33dec@mail.gmail.com>
Date: Sat, 7 Jul 2007 01:33:48 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: Multiple interfaces in mac80211
Cc: "Jon Smirl" <jonsmirl@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200707062316.30009.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <200707062000.32741.IvDoorn@gmail.com>
	 <9e4733910707061137i5baf2d3fw7ad1469f46632520@mail.gmail.com>
	 <200707062316.30009.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/7/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Friday 06 July 2007, Jon Smirl wrote:
> > On 7/6/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > On Friday 06 July 2007, Jon Smirl wrote:
> > > > On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > > > On Fri, 2007-07-06 at 08:55 -0400, Jon Smirl wrote:
> > > > >
> > > > > > Yes, only interface is monitor.
> > > > > >
> > > > > > Here is something else that is odd.
> > > > > >
> > > > > > Beacons are reporting channel 1...
> > > > > >
> > > > > > But I am tuned to channel 10.
> > > > >
> > > > > That's fishy. What hardware?
> > > >
> > > > Ralink rt2x00usb
> > >
> > > Thats odd, are only beacons reported to be on channel 1?
> > > Because the channel for rx frames is automatically set when
> > > the channel is configured by mac80211.
> >
> > The channel field appears to be uninitialized for beacon frames. When
> > I booted this time it is displaying channel 9 and I am on channel 10.
> >
> > Other frames show channel 10 as expected.
>
> Which is quite weird since the beacon frames use the same rx_status structure
> as the regular frames. No distinction is made within rt2x00 between rx frames...
>
> Ivo
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
I'm not sure if this is relevant but:
It is normal to hear beacons for adjacent channel on 2.4 spectrum as
channel overlaps. One must read DS information element from the beacon
to determine on which channel the beacon was really sent.
