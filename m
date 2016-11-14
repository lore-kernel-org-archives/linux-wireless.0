Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59904 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbcKNO4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 09:56:43 -0500
Message-ID: <1479135396.12007.11.camel@sipsolutions.net> (sfid-20161114_155647_033551_CAFC375F)
Subject: Re: [RFC] change mac80211_hwsim tx_rates to ieee80211_tx_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2016 15:56:36 +0100
In-Reply-To: <838c443a-f8aa-ab21-61b0-9352f24442b1@uni-rostock.de>
References: <dcc2ec52-abe0-3182-e7f5-d1df40fd492b@uni-rostock.de>
         <1478984929.4226.3.camel@sipsolutions.net>
         <faf081ea-18c6-8ad5-e336-aac9a79a0ce3@uni-rostock.de>
         <1479132555.12007.6.camel@sipsolutions.net>
         <838c443a-f8aa-ab21-61b0-9352f24442b1@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Mhh, I thought also some atheros drivers implement hardware multirate
> retry changes, which maps to this struct. Only one rate per frame
> would introduce a extreme additional communication overhead, which
> will make testing with standard wmediumd impractical. I think we need
> to keep such a structure, but we should align that with other
> mac80211 depended drivers.

Yeah, I was being imprecise. The driver interface is usually similar to
the mac80211 struct in one way or another (though it might also be a
more global table, like other drivers implement).

I was more thinking of the actual air interface. I'm not too worried
about the efficiency of this (we can push quite a few gbps over hwsim
today iirc), but it actually doesn't make sense because an accurate
simulation would require NAV/TXOP simulation, and that wouldn't be
possible with "software retry".

So I think our best bet remains to map this to new attributes - better
with properly formatted ones etc. than with the struct (keeping that
only for compatibility)

If you're worried about the overhead, we could consider converting
hwsim to use the rate_table API - see struct ieee80211_sta -> rates,
and maybe adding a signal to update that in the driver, send that to
userspace directly and work with that, rather than "serializing" the
table for every frame?

johannes
