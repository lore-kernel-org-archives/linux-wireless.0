Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:23285 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYIQWeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 18:34:23 -0400
Received: by ik-out-1112.google.com with SMTP id c30so3074417ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 15:34:20 -0700 (PDT)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [RFC] Redesigning aggregation on mac80211
Date: Thu, 18 Sep 2008 00:34:16 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <43e72e890809151203p213fae37ia3bd6871c3bfe2c2@mail.gmail.com> <200809162005.30002.IvDoorn@gmail.com> <1ba2fa240809171514y72b070d0t775702ea48360331@mail.gmail.com>
In-Reply-To: <1ba2fa240809171514y72b070d0t775702ea48360331@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809180034.16758.IvDoorn@gmail.com> (sfid-20080918_003428_887377_74DAAA1E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Tomas Winkler wrote:
> On Tue, Sep 16, 2008 at 9:05 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Hi,
> >
> >> We're considering redesigning how aggregation works on mac80211 to
> >> ensure its vendor neutral and to remove as much as redundant code in
> >> drivers. We'd like some feedback from people and driver developers,
> >> even those who haven't *yet* posted their new shiny 11n drivers, like
> >> Marvell or Ralink driver developers.
> >
> > Well technically speaking there are 2 Ralink drivers in the Kernel already
> > which *should* support aggregation (rt61 and rt73).
> >
> > I'm sorry I have not read the entire thread on the new aggregation support
> > yet, but I'll write what I know from rt61/rt73/rt2800 here anyway. :)
> >
> >> Ivo, are you familiar yet with how aggregation works on Ralink
> >> hardware? Does the new 11n hardware require firmware? Specifically
> >> we're curious about how the hardware queues are managed.
> >
> > Ralink defines 4 queues, 1 Management queue (can be abused as regular TX queue)
> > and a Beacon queue.
> >
> > There is no such thing as seperate aggregation queues, as soon as the device
> > wants to perform aggregation it grabs a normal entry from the TX queue,
> > and assignes all frames to it.
> >
> > rt61: 5 addresses can be provided for Aggrated frames, I am not sure
> > if the first is a header only frame or not.
> > rt73: Not sure what should be done
> > rt2800: 2 addresses can be provided, where the first is a header/descriptor
> > only address. In the second address frames can be provided.
> 
> > Because the aggregated frame is created directly into a TX entry, no other
> > frames should go through that queue until the aggregated frame has been
> > completed.
> >
> 
> What type of aggregation is this? AMSDU or AMPDU? In AMPDU you need
> somehow handle
> out of order resend of the packets.  rt61 and rt2800 looks more like
> AMSDU (Not sure) we don't support that in iwlwifi TX side of it yet,
> it just doesn't outperform AMPDU aggregation.
> Tomas

It is a bit confusing since comments, variable names are a conflicting eachother
in the legacy driver code. Comments state MSDU where variables are named MPDU
and later the same variable is accompanies with comments regarding MPDU.

I really have to look deeper in the actual implementation to see what the driver
is doing exactly before I can answer the question what aggregation it is using.

> > I'm afraid that is currently all the information I got at this time,
> > It is only a little, but I never got around to fully look into the aggregation support,
> > although I definately want it implemented in the drivers to increase the
> > performance a bit. :)
> 
> Need to find out what kind of aggregation the cards support. For TX
> AMSDU we need add more code into mac80211, the AMSDU sub frames have
> 14 bytes (eth) headers.

Ivo
