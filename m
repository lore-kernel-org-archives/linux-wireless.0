Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:46089 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753339AbXJOJA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 05:00:29 -0400
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: atheros hardware needs padding for QoS data
Date: Mon, 15 Oct 2007 18:00:36 +0900
Cc: linux-wireless@vger.kernel.org
References: <200710121946.30024.bruno@thinktube.com> <200710151241.17651.bruno@thinktube.com> <1192438036.3349.16.camel@johannes.berg>
In-Reply-To: <1192438036.3349.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710151800.36338.bruno@thinktube.com> (sfid-20071015_100034_976288_710D164B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 October 2007 17:47:16 Johannes Berg wrote:
> > another solution i thought of was signalling the mac80211 layer that we
> > need padding which could then just adjust it's headerlen. but then
> > different drivers might need different padding in different places (i
> > don't know?). what do you think of this approach?
>
> That could be worthwhile, though the headerlen calculation is called
> very very often and adding another branch into it could very well impact
> performance worse than doing the memmove.

now you confuse me. this is exactly what i attempted with the previous patch, 
which you didn't like... 

unfortunately it's not possible to implement it there as a zero copy solution, 
because ieee80211_rx_h_remove_qos_control messes with the header itself.

bruno
