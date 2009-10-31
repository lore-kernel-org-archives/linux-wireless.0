Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx48.mail.ru ([94.100.176.62]:53981 "EHLO mx48.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757784AbZJaORC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 10:17:02 -0400
Date: Sat, 31 Oct 2009 17:24:37 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <7724371.20091031172437@mail.ru>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re[2]: ieee80211_tx_status: headroom too small
In-reply-To: <1256981677.3555.94.camel@johannes.local>
References: <1094614475.20091030230028@mail.ru>
 <200910310959.43260.IvDoorn@gmail.com>
 <1256981113.3555.92.camel@johannes.local>
 <200910311030.45582.IvDoorn@gmail.com> <1256981677.3555.94.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Saturday, October 31, 2009, 12:34:37 PM, Johannes Berg wrote:
>> > > 4 actually, wasn't there some cases where the header could have an odd
>> > > number of bytes and would require 3 bytes for alignment?
>> > 
>> > Hm, is there? I thought they changed the 11s draft to no longer have
>> > that.
>> 
>> Well 2 is fine in that case, (I was basing my comment on something said on this mailinglist
>> a long time ago). :)

> However, it really all depends on the hardware too ... Maybe we should
> put more of the logic into drivers, and have mac80211 only export its
> required headroom?

> Or maybe we should just not bother with having drivers do the alignment
> any more -- mac80211 does that now and it only does it if necessary
> (i.e. not on powerpc/x86)

I'm having this issue on mips platform, if it matters. I cannot test
it on x86 yet.

Now, searching for "extra_tx_headroom" gives me essentially the
following two:

net/mac80211/main.c:
        local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
                                   sizeof(struct ieee80211_tx_status_rtap_hdr));

drivers/net/wireless/rt*pci.c:
        rt2x00dev->hw->extra_tx_headroom = 0;

So, as a quick-and-dirty fix, should I replace "max_t(..." by "4 + max_t(..."
or "= 0" by "= 4" ?

Thank you!

Nikolai ZHUBR

> johannes


