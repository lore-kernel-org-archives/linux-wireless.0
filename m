Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706AbZCMRU7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 13:20:59 -0400
Subject: Re: [PATCH] cfg80211: drop wext channel list if too long
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090313145445.GC5551@tuxdriver.com>
References: <1236882244.25931.5.camel@johannes.local>
	 <20090313145445.GC5551@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 13:18:50 -0400
Message-Id: <1236964730.9657.10.camel@localhost.localdomain> (sfid-20090313_182102_446793_E6DB3149)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-03-13 at 10:54 -0400, John W. Linville wrote:
> On Thu, Mar 12, 2009 at 07:24:04PM +0100, Johannes Berg wrote:
> > wext limits the number of channels it can list to 32, we obey
> > that limitation but show a partial list which is confusing.
> > Thus, when going over the limit, drop the list completely to
> > make the users aware that something is wrong and hopefully
> > prompt them to use iw instead. We still let iwlist print out
> > the total number of available channels.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Will this make wpa_supplicant or Networkmanager barf?

It doesn't look like wpa_supplicant cares about the returned channel
list from SIOCGIWRANGE.

NM, however, uses the returned channel list to figure out a free
supported adhoc frequency to use when creating an adhoc network (like
for connection sharing).  If it can't find an intersection between an
internal "safe" frequency list and what the card supports (which it
wouldn't be able to with this patch), it will simply use 2462 or 5180
MHz.

Thus, I don't think you'll *break* anything specifically, but this patch
would cause the default frequency for an IBSS created by NM  to move
from channel 1 to channel 11.

Dan


