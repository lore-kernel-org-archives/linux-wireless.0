Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1ATJYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:24:31 -0500
Subject: Re: [RFC 1/4] mac80211: support for IEEE80211N in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110120T093834-982@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>
	 <1295447708.4685.5.camel@jlt3.sipsolutions.net>
	 <loom.20110120T093834-982@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 10:24:29 +0100
Message-ID: <1295515469.3693.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 09:10 +0000, Alexander Simon wrote:

> What do you mean with a "not so refactoring version"? I am adding a new IE.
> These are only insertions, no other changes. Or do you mean that dev_alloc_skb?
> However, i took the last "try" from Benoit.

Well, then maybe I just discussed this with him -- there's similar code
building the HT IEs for stations, that code should be shared.

> I split my patch into 4 sections: Setting channel_type, Building the HT IE when
> joining an IBSS, parse the HT IE of a newly joined station and enable
> aggregation code for IBSS.
> 
> This first patch adds setting nl80211_channel_type for an IBSS. This is mostly
> Benoits work.
> When a IBSS to connect to is given by iw, there is a new argument to set HT20,
> HT40+ or HT40-.
> When we create an IBSS, we have that struct params where we can find the channel
> type set by iw.
> When we join a already existing IBSS, we don't. If we find a HT IE, then we will
> distinguish our channel type by that.
> Here the problem remains if a legacy station has joined a HT IBSS and we got its
> beacon. Then we'll won't have an HT IE... This has to be fixed, maybe something
> like "found a HT20 STA, switching to HT20. And now found a HT40-, switching to
> HT40-"


Yes all of that might be necessary, but can you post patches that do one
thing at a time? Like at least one cfg80211/nl80211 patch that adds the
configurability, and then a mac80211 patch that will use it.

Also, I think cfg80211 should support advertising to userspace that it's
supported.

Yes, I sometimes accept combined cfg80211/mac80211 patches, but I think
this feature is bigger than that.

johannes


