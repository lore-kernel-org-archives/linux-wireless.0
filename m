Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab1INR71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 13:59:27 -0400
Subject: Re: Latency and connection problems with a carl9170-based AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Harshal Chhaya <harshal@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1316021915.4663.0.camel@jlt3.sipsolutions.net> (sfid-20110914_193848_416896_BA7DA3F8)
References: <CAJ8GFOgNRAr7LvnO8f0Y8uvkQdwhz7uUXRQ6BXomjO05RiiYjg@mail.gmail.com>
	 <201109141932.02929.chunkeey@googlemail.com>
	 (sfid-20110914_193219_215086_8DB3821B)  <1316021915.4663.0.camel@jlt3.sipsolutions.net>
	 (sfid-20110914_193848_416896_BA7DA3F8)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 19:59:19 +0200
Message-ID: <1316023159.4663.1.camel@jlt3.sipsolutions.net> (sfid-20110914_195930_695778_37C24907)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-14 at 19:38 +0200, Johannes Berg wrote:
> On Wed, 2011-09-14 at 19:32 +0200, Christian Lamparter wrote:
> > On Wednesday, September 14, 2011 01:19:59 PM Harshal Chhaya wrote:
> > > Most of the disconnects seem to be caused by beacons that update the
> > > TIM IE but not the overall length. The result is a corrupted RSN IE
> > > (e.g. the IE length says 20 bytes but the IE is only 19 bytes in size)
> > > which causes the clients to disconnect. This problem lasts for only
> > > one beacon (i.e. the next beacon has the right size) but it is enough
> > > to cause the clients to disconnect. Is there a way to fix this?
> > Now that is really interesting. Do you know if the TIM IE is generated
> > properly by ieee80211_beacon_add_tim in net/mac80211/tx.c?
> 
> Hm, looking at that code, is it really correct?
> 
>         tim = pos = (u8 *) skb_put(skb, 6);
>         *pos++ = WLAN_EID_TIM;
>         *pos++ = 4;
> ...
>                 tim[1] = n2 - n1 + 4;
>                 skb_put(skb, n2 - n1);
> 
> 
> shouldn't the latter be skb_put(skb, n2 - n1 - 2)?

Nah, I'm just confused.

johannes

