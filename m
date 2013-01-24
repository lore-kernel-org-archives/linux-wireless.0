Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3AXJKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 04:10:09 -0500
Message-ID: <1359018633.4639.2.camel@jlt4.sipsolutions.net> (sfid-20130124_101023_339387_BEC0F2A2)
Subject: Re: [RFC v2] cfg80211/mac80211: support reporting wakeup reason
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 24 Jan 2013 10:10:33 +0100
In-Reply-To: <1359010005.6252.185.camel@cumari.coelho.fi>
References: <1358958882-14246-1-git-send-email-johannes@sipsolutions.net>
	 <1359010005.6252.185.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-24 at 08:46 +0200, Luciano Coelho wrote:

> > Change-Id: I7766f071273f3e31020395cc74eabcc6d165fa3a

> As I asked on IRC, what are these Change-Id tags you've been using
> recently? Just curious.

For gerrit. We use it internally, and I was sending the review patches
from my internal review tree. Usually I strip them when applying to my
kernel tree(s), but sometimes I forget.

> > + * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8022_LEN: Original length of the 802.3
> > + *	packet, may be bigger than the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023
> > + *	attribute if the packet was truncated somewhere.
> 
> This seems wrong.  Why PKT_8023 and PKT_8022_LEN?

Yeah, typo.

> Also, is there any specific reason you want to know the original length?
> Just to check whether the packet was truncated or not?

Yeah our device has a certain buffer size only (it's pretty large) but
the packet could be truncated due to that, so I added that to be able to
see that truncation.

johannes

