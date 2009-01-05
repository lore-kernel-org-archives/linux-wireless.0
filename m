Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:52106 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZAEQgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 11:36:44 -0500
Message-ID: <49623712.4060106@openwrt.org> (sfid-20090105_173647_589776_3B37C0A4)
Date: Mon, 05 Jan 2009 17:36:34 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49620BE5.9030507@openwrt.org> <20090105142343.GS496@one.firstfloor.org> <49621C36.70602@openwrt.org> <20090105152410.GT496@one.firstfloor.org> <49622686.9050005@openwrt.org> <20090105163553.GU496@one.firstfloor.org>
In-Reply-To: <20090105163553.GU496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
> Ok, but I see the same thing with two different cards, with different
> chipsets (RaLink and RealTek). You think they both have that problem?
Yes, I think that's not unlikely.

>> Maybe we can see more if you provide some minstrel stats after
>> you've pushed more traffic through the link - 25-50 packets is not
>> nearly enough for getting an accurate view of how good the link is.
>> Try to push through a few megabytes of data...
> 
> Here are the statistics after a few MB.
> 
> rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
> TtP  1         0.9       97.9      100.0          1(  1)      19284       21249
>      2         0.0        0.0        0.0          0(  0)          0         101
>      5.5       0.0        0.0        0.0          0(  0)          0         104
>     11         0.0        0.0        0.0          0(  0)        253         397
>      6         0.0        0.0        0.0          0(  0)          0         103
>      9         0.0        0.0        0.0          0(  0)          0         106
>     12         0.0        0.0        0.0          0(  0)          0         107
>     18         0.0        0.0        0.0          0(  0)          0         104
>     24         0.0        0.0        0.0          0(  0)          0         111
>     36         0.0        0.0        0.0          0(  0)          0         120
>     48         0.0        0.0        0.0          0(  0)          0         179
>     54         0.0        0.0        0.0          0(  0)          0         253
> 
> Total packet count::    ideal 9023      lookaround 474
According to the rate control's view, only the 1M has a usable
success probability. It's rather insteresting that 11M is the only
other rate that had some successes. With this kind of results, the
only two options that I can think of are either a systematic tx
status reporting error (false negative for the IEEE80211_TX_STAT_ACK
flag), or something PHY related.
I think the latter is more likely.

- Felix
