Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43430 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751476AbcLEO5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:57:30 -0500
Message-ID: <1480949847.31788.33.camel@sipsolutions.net> (sfid-20161205_155735_186831_B07E3331)
Subject: Re: [PATCH] mac80211: fix Tx BA session stuck issue during sw
 scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Chris Chiu <chiu@endlessm.com>
Cc: linux-wireless@vger.kernel.org, linux@endlessm.com
Date: Mon, 05 Dec 2016 15:57:27 +0100
In-Reply-To: <CAB4CAwfJeE15nhXuLi_V-FYeCj4wj=1ojij+pwZ8V7=gdER76Q@mail.gmail.com> (sfid-20161201_122456_423194_378125CA)
References: <1479887968-17473-1-git-send-email-chiu@endlessm.com>
         <1480424369.10012.6.camel@sipsolutions.net>
         <CAB4CAwfJeE15nhXuLi_V-FYeCj4wj=1ojij+pwZ8V7=gdER76Q@mail.gmail.com>
         (sfid-20161201_122456_423194_378125CA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > The premise seems fairly reasonable, although I'm a little worried
> > that if so much new traffic is coming in we never finish the scan
> > suspend? Actually, the queues are still stopped, so it's only
> > management frames that can come in, so that should be ok?
> > 
> 
> Actually it will finish scan eventually and back to SCAN_DECISION
> state but almost 20~30 seconds elapsed. The local->scanning should be
> cleared after all channels been scanned. However, from the debug
> messages I added in ieee80211_iface_work(), it still returns when
> check local->scanning and the DELBA still has no chance to be
> transferred then stuck again at the next scan state machine. Supposed
> to be another scan request issued but I don't know who's the killer.
> Except to find who issue the next scan request, BA session have no
> chance to reset in this long scan period (>20s) still need to be
> taken
> care.

No no, you misunderstood. My question is more like:

Where is this traffic coming from, since netdev queues should be
stopped?

And then, if there's so much traffic coming in that we can take 20-30
seconds to send it out, could we - with the change - get stuck forever?

> You're right. I just want to clear_bit and set_bit in this case,
> sorry for that confusing. Or any better suggestion?

We seem to be using set_bit/clear_bit so that seems reasonable, unless
you can prove that all of those are under the lock and we can remove
the atomics entirely ... Not that it matters hugely, we don't scan all
the time after all!

johannes
