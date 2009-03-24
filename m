Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:12719 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZCXKgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 06:36:20 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: Google Summer of Code 2009 -- Linux wireless roaming project
Date: Tue, 24 Mar 2009 11:36:03 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Mircea Gherzan <mgherzan@gmail.com>
References: <20090320215705.GE8120@tesla> <200903241006.43512.hs4233@mail.mn-solutions.de> <200903241115.29868.helmut.schaa@gmail.com>
In-Reply-To: <200903241115.29868.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903241136.03991.hs4233@mail.mn-solutions.de> (sfid-20090324_113624_832939_5EC3ADBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Got your point. My concern was not about the AP selection ;).

Yeah, I now realized that we talked about different thresholds:

a) when to do scanning
b) what AP to select

and on top of this b) with absolute and relative meaning :-)


> Hmm, quick example: AP1 - STA - AP2
>
> We cannot consider the signal strength as constant as it
> varies over time even when neither the STA nor the AP are
> moving. Assume a threshold value of t=40. Furthermore, the
> signal strength of AP1 and AP2 might alter between 35-50 which
> means we have an average signal strength of 42,5 > t.
> Nevertheless that would result in ping-pongs between AP1 and
> AP2 because the signal might drop below t on both APs, while
> it would be better to stick to one AP as the signal is already
> quite bad (but still good enough to do some communication).

Yeah, but if the client is moving, you have to live with that, 
more or less.

And if the client is not moving (and roaming is a loadable kernel 
module), then simply don't load it :-)


My ad-hoc approach that I already implemented (for non-mac80211) 
shows a quite number of scannings. But that is ok for my 
use-case (e.g. telnet connection via WLAN). "Connection lost" is 
way worse than one scanning/reassociation too much, especially 
if the scanning/association is done intelligently.

So for now I wouldn't optimize here, but make non-sucking roaming 
possible in the first place. We can build upon this anyway.



BTW, I actually looked once into mac80211, to see if I can get a 
roaming similar to what madwifi with a little patch does now. 
However, I quickly was lost in the djungle of cfg80211, nl80211, 
mac80211. I found it overly complex just to add one additional 
netlink-message, e.g. to specify the threshold via "iw". Maybe 
I've done something wrong (e.g. not stared long enought at the 
source-code), but I think it was necessary to change 80-100 
lines just to get one value from "iw" into mac80211.
