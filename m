Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33864 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbdJJQF6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 12:05:58 -0400
Message-ID: <1507651555.26041.81.camel@sipsolutions.net> (sfid-20171010_180630_439020_657EE57D)
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 10 Oct 2017 18:05:55 +0200
In-Reply-To: <20171010140208.1515-1-toke@toke.dk> (sfid-20171010_160341_258014_BDC1BDA8)
References: <20171010140208.1515-1-toke@toke.dk>
         (sfid-20171010_160341_258014_BDC1BDA8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In particular, I'm not sure what the right thing to do in regards to
> PS wakeup is...

Can you explain what you were _trying_ to do?

I don't like calling this "driver_buffered" because that's already a
term for frames that are buffered in the driver ... :-)

PS is complicated, we basically transmit, in the following order:
 * filtered frames (tx_filtered)
 * buffered frames (ps_tx_buf)
 * regular frames

This is when we _leave_ powersave. When we deliver frames while the
station is sleeping (PS-Poll or U-APSD), they don't even go through the
TXQ. They still come from this place, but currently go directly to the
->tx() method, which to me is actually pretty weird but that's what it
is now.

As I think I said in my other thread, we should probably eventually
just get rid of ps_tx_buf entirely, instead just keeping the frames on
the TXQ. Then, filtered can just be pushed onto txqi->frags [*], and we
get rid of having that separately as well.

Then, we've completely solved the wakeup scenario, we just start
scheduling that TXQ normally again.

For the deliver-while-sleeping (PS-Poll/U-APSD) scenario, I think the
driver should still pull frames, after calling something like
drv_release_buffered_frames(). We want this to be scheduled pretty much
immediately, so we shouldn't just put the TXQ into the normal rotation,
but otherwise it should work similarly - except limited to a certain
number of frames [**].
In this case the driver probably needs to pull the frames using a
different function so that we can
 a) tag the packets properly (more-data, EOSP)
 b) generate nulldata as EOSP container where needed
Thus, it seems likely that we'll want a separate function, "pull for PS
delivery" rather than the normal ieee80211_tx_dequeue().

johannes

[*] ok not exactly, if there are frags there already things get messy.
    but we can probably solve that somehow without needing more special
    cases
