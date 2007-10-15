Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:39099 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750885AbXJODlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 23:41:13 -0400
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: atheros hardware needs padding for QoS data
Date: Mon, 15 Oct 2007 12:41:17 +0900
Cc: linux-wireless@vger.kernel.org
References: <200710121946.30024.bruno@thinktube.com> <1192190297.4770.48.camel@johannes.berg> <1192194578.4770.55.camel@johannes.berg>
In-Reply-To: <1192194578.4770.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710151241.17651.bruno@thinktube.com> (sfid-20071015_044122_141709_FE2D9EDC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 12 October 2007 22:09:38 Johannes Berg wrote:
> On Fri, 2007-10-12 at 13:58 +0200, Johannes Berg wrote:
> > b43 also has padding added on RX which we simply remove with a memmove()
>
> Umm, no, this is wrong, the padding is in another place.

nevermind. i thought of this as an option as well.

but isn't doing a memmove() quite inefficient? especially since we are dealing 
with QoS packets that might be important.

another solution i thought of was signalling the mac80211 layer that we need 
padding which could then just adjust it's headerlen. but then different 
drivers might need different padding in different places (i don't know?). 
what do you think of this approach?

bruno
