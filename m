Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:34086 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdCCTrs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 14:47:48 -0500
Received: by mail-ot0-f179.google.com with SMTP id o24so15916433otb.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Mar 2017 11:46:55 -0800 (PST)
From: Jesse Jones <jjones@uniumwifi.com>
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
 <b285e11810b612a6a156693f34e232ac@mail.gmail.com> <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com>
In-Reply-To: <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 3 Mar 2017 10:49:51 -0800
Message-ID: <39c846a5bcfa1fff26f69a082466e414@mail.gmail.com> (sfid-20170303_204815_979391_81BB7F5C)
Subject: RE: [PATCH v2] mac80211: mesh - always do every discovery retry
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Yes, that is a real issue. We are planning on doing some further work
> > in this area to  try to minimize the explosions that can be seen with
> > PREQs in larger networks while balancing the need for reliability.
> >
> > Path discovery
> >> should stop once the path is established. By attempting 2nd, 3rd or
> >> 4th doesn't guarantee the next path will be "good".
> >
> > It doesn't guarantee anything of course but it does raise the
> > probability that the right path will be found. For example take four
> > nodes in a ring where the A-B, B-C, C-D links are all good but the A-D
> > link is poor. Poor enough that the higher data rates are hosed for
> > that link but the basic rate used by management frames is relatively
> > unaffected. If we assume that the reliability of management frames is
> > 90% then in order for A to route to D it needs to get a PREQ to D and
> > a PREP back. It has two options 1) for A-D the reliability will be
> > 0.9^2 = 81% 2) for A-B-C-D the reliability will be 0.9^6 = 53%.
>
> What is round trip delay between A-D compared to A-B-C-D? 1 hop away the
> throughput is reduced by half.

Well A-D is going to have a much smaller RTT than A-B-C-D. And, yes, using
multiple hops is going to reduce throughput but I'd much rather use multiple
120 Mbps links than a link that only supports 12 Mbps.

>Also if you have more nodes using longer
> path, you consume more airtime leads to really bad network performance,
> especially when B, C, or even D wants to start initial data transmission.

That's why there are link and path metrics.

> One way of improving the path is either enhancing the airtime link metric
> by
> considering the factor that you mentioned in or else introducing vendor-
> specific path metric. Sending more broadcast frames over the network won't
> be a good solution.

Improving the link metric isn't going to help with PREQ reliability
problems. Sending more PREQs will.

  -- Jesse
