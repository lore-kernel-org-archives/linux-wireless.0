Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:34428 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762516AbXFEOJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 10:09:26 -0400
Date: Tue, 5 Jun 2007 16:09:24 +0200
From: David Lamparter <lists@diac24.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: nl80211 status? (implying cfg80211 status)
Message-ID: <20070605140924.GC5221@charon.n2.diac24.net>
References: <20070604193034.GA16350@charon.n2.diac24.net> <1181040798.8274.10.camel@johannes.berg> <1181051870.8274.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1181051870.8274.17.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hooray, message crossing :)

> What I'd do if I had time now is add things to nl80211/cfg80211 and then
> implement the calls in mac80211 (or a fullmac driver of your choice.)
> Then write the appropriate userspace tool for testing and see if it
> works, i.e. you can associate, do key operations etc. Use WEP for now,
> and then maybe modify wpa_supplicant too for nl80211. Then, at some
> point, you have wpa_supplicant working on mac80211 (or the driver). Then
> in theory you don't need wext any more, and as an afterthought you can
> still add wext compatibility so the deprecated wireless tools continue
> to work.

Yeah, I agree. Guess I overshooted a bit on converting wext. For the
userspace part I started by adding some genetlink helper functions to
iproute2, will try to get them upstream later. (tomorrow)

I'm hoping to add an "ip wireless" part, since iproute2 already has all the
netlink stuff and I really like its syntax. I rudimentarily started hacking
it up, which is why I noticed there's no PHY configuration command.

For the kernel part, if I were to work on it, I'd be adding it to mac80211.
The only 802.11 devices I own are a laptop with a rt2500 and a WRT router,
and developing for that router isn't that fun.


David

---

[equinox@neptune]:~/src/iproute2/ip # ./ip w
0: phy0
RTNETLINK answers: Operation not supported
    6: wlan0: association status unknown
RTNETLINK answers: Operation not supported
    5: wmaster0: association status unknown

