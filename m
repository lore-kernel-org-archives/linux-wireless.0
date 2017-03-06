Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:36824 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753700AbdCFSZy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 13:25:54 -0500
Received: by mail-ot0-f181.google.com with SMTP id i1so118991385ota.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 10:25:53 -0800 (PST)
From: Jesse Jones <jjones@uniumwifi.com>
References: <CAEFj984umxKZgMqzgbQvX+VgPjqCW98E17bfED9+Yg3XGzatOw@mail.gmail.com>
 <b285e11810b612a6a156693f34e232ac@mail.gmail.com> <CAEFj9874ynLcjn7AhpB-ajre3twpwHM4iEVN2ozYEGDPGErs0Q@mail.gmail.com>
 <39c846a5bcfa1fff26f69a082466e414@mail.gmail.com> <CAEFj987m=5a6pWZLMtTcVshmVfOmwwbb-+s0FR_+Dz6_xx7Dtw@mail.gmail.com>
 <CAEFj9868zDVomdjQhrzNKs9ANaRF85wdA49vKwVZJ2dUiTpoVg@mail.gmail.com>
In-Reply-To: <CAEFj9868zDVomdjQhrzNKs9ANaRF85wdA49vKwVZJ2dUiTpoVg@mail.gmail.com>
MIME-Version: 1.0
Date: Mon, 6 Mar 2017 10:25:51 -0800
Message-ID: <faafc817ee74ba39171199985756b87b@mail.gmail.com> (sfid-20170306_192627_276071_DE1AD9EC)
Subject: RE: [PATCH v2] mac80211: mesh - always do every discovery retry
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, Alexis Green <agreen@cococorp.com>,
        Alexis Green <agreen@uniumwifi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >> Well A-D is going to have a much smaller RTT than A-B-C-D. And, yes,
> >> using multiple hops is going to reduce throughput but I'd much rather
> >> use multiple
> >> 120 Mbps links than a link that only supports 12 Mbps.
> >>
> >
> > Airtime link metrics should choose the multiple links if it is good
> > compared to direct link.
> >
> >> That's why there are link and path metrics.
> >
> > I don't think that you don't get this. Every nodes sends out multiple
> > PREQs.
> > Other nodes received it with rebroadcast again. Take note on this.
> >
> >> Improving the link metric isn't going to help with PREQ reliability
> >> problems.
> >
> > PREQ realiabilit? It is broadcast management frame and usually using
> > lowest transmission rate. So it is realiabe.

They are only reliable when compared to individual rate controlled frames.
But, in general, they are most certainly not reliable. Even in a shielded
and conductive (i.e. with physical wires connecting antennas) environment
lost PREQ frames are not hard to see.

  -- Jesse
