Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33534 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaIEOL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 10:11:27 -0400
Received: by mail-ig0-f181.google.com with SMTP id h15so3394150igd.2
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 07:11:26 -0700 (PDT)
Date: Fri, 5 Sep 2014 10:10:39 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dani Camps <danicamps81@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wmediumd performance penalty
Message-ID: <20140905141039.GB26808@localhost> (sfid-20140905_161135_405598_99CC8C7F)
References: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com>
 <1409597534.2703.9.camel@jlt4.sipsolutions.net>
 <CAD3NH5Wimu9muPeL-zFrw=u1G3Q+8749cj0SYUmeQuLF6LKibQ@mail.gmail.com>
 <1409644512.1808.2.camel@jlt4.sipsolutions.net>
 <CAD3NH5XEfHU7KMWwrmZdZz9LKP_86b4EFogpHrnC+AhREHjOPw@mail.gmail.com>
 <20140905130325.GA26808@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140905130325.GA26808@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 05, 2014 at 09:03:25AM -0400, Bob Copeland wrote:
> Indeed you can.
> 
> For what it's worth, although I can't speak for wmediumd at the moment,
> in the precursor to it that I wrote, I got about 25 Mbps achieved with
> a phy rate of 54 Mbps when simulating the physical layer, which I think
> is pretty close to real world overhead in non-agg case.  With plain old
> mac80211_hwsim you can get several Gbps.

Sort of - it relied on a different hwsim interface than what made it
upstream, and was for a one-off investigation, so it's mostly useless.
Code is here though:

http://bobcopeland.com/srcs/wifi_sim.tar.gz

Glancing at the wmediumd code again, it doesn't try to simulate airtime
either, just does some loss reporting.  Do you have a use-case which
needs the airtime simulation?

A while ago, I rewrote my PER computations in C instead of pre-generating
them from matlab into a huge lookup table (see per.c):

https://github.com/bcopeland/wmediumd/tree/add_per_model

So, I'd be interested in hooking that up and throwing a scheduler into
wmediumd to optionally simulate airtime.

-- 
Bob Copeland %% www.bobcopeland.com
