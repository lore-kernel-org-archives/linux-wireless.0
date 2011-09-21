Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1IUIfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 04:35:45 -0400
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Johannes Berg <johannes@sipsolutions.net>
To: victorg@ti.com
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <4E799DF9.9060807@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <4E799DF9.9060807@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 10:35:38 +0200
Message-ID: <1316594138.3940.10.camel@jlt3.sipsolutions.net> (sfid-20110921_103549_155963_0BE19155)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-21 at 11:19 +0300, Victor Goldenshtein wrote:

> Just talked with Luciano, and we though to make this event more generic 
> and to pass the whole BSS info instead of just BSSID and rssi, what do 
> you think?

I think there are two choices:

1) do what you say, and send the whole BSS info in the event

2) send a per-channel "scanned this channel" event, and allow filtering
the BSS dump per channel


There are a few trade-offs here:

advantages of 1:
+ info is directly available
+ very fine-grained

disadvantages of 1:
- lots of context switches, fairly expensive


advantages of 2:
+ adds more generic filtering capability
+ fewer context switches since retrieving BSS dump is limited & only
needs very few messages

disadvantages of 2:
- not quite as fine-grained


Personally, I prefer 2 because of the context switches issue, and
because I think there's little point in having so fine-grained
information. But I'm willing to concede that there may be a point in it,
more easily if you could explain why that's useful :-)


johannes

