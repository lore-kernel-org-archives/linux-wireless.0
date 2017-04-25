Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34140 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948208AbdDYOh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 10:37:59 -0400
Message-ID: <1493131069.2609.1.camel@sipsolutions.net> (sfid-20170425_163819_094464_DBD0DFF1)
Subject: Re: [Battlemesh] wifibroadcast
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>,
        Daniel Golle <daniel@makrotopia.org>
Cc: battlemesh@ml.ninux.org, gnunet-developers@gnu.org,
        linux-wireless@vger.kernel.org
Date: Tue, 25 Apr 2017 16:37:49 +0200
In-Reply-To: <1806801.tVQKAhPZbv@prime>
References: <CANjd3nfeiGgaHMcgOyKOKhRRKEwnn43VgC4GRcw-fuCkCdg2zQ@mail.gmail.com>
         <2945991.ay5rM9MeUZ@prime> <20170422153703.GE1681@makrotopia.org>
         <1806801.tVQKAhPZbv@prime>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-04-23 at 00:01 +0200, Simon Wunderlich wrote:

> What is missing (or at least I didn't find it
> and  implemented something on my own) is a library/function to build
> radiotap  headers (i.e. for writing). There are quite a few things to
> consider (padding, alignment, etc). 

Yeah, that could be done - but generally it's actually quite easy since
a given application will only have a given subset of radiotap
information it generates... wrapping all of that with some kind of
helper function could result in pretty bloated code.

> To make it useful, you would also need to build ieee80211 headers at
> the same time ...

I don't really agree - these can and should be separate IMHO.

Anyway, there isn't any such thing today.

johannes
