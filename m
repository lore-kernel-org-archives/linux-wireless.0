Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1H2N0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 09:26:51 -0400
Subject: Re: [PATCH] mac80211: make ieee80211_send_bar available for drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4E4FFC3A.8070706@openwrt.org>
References: <1313848435-45702-1-git-send-email-nbd@openwrt.org>
	 <4E4FFC3A.8070706@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 15:26:49 +0200
Message-ID: <1314624409.8959.4.camel@jlt3.sipsolutions.net> (sfid-20110829_152659_024364_3EA2F347)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-08-20 at 20:26 +0200, Felix Fietkau wrote:
> On 2011-08-20 3:53 PM, Felix Fietkau wrote:
> > To properly maintain the peer's block ack window, the driver needs to be
> > able to control the new starting sequence number that is sent along with
> > the BlockAckReq frame.
> >
> > Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> > ---
> > turns out that I will need this change in mac80211 anyway to properly
> > handle a few corner cases wrt. aggregation and off-channel activity.
> >
> > When ath9k goes off-channel it may need to drop some packets that are
> > still part of the BAW, but at that point in time it would be a very
> > bad idea to try to send BAR frames. Instead I want to send the BAR
> > after switching back to the primary channel as a kind of barrier before
> > sending more packets.
> Johannes, do you think it would make the driver API better if instead of 
> exporting this function, I add an ieee80211_bar_get function (similar to 
> ieee80211_nullfunc_get or ieee80211_probereq_get) to avoid concerns over 
> the missing _ni variant or the weird callchain from the driver back into 
> the tx function?

Probably not -- especially since that might be tricky wrt. rate control?

I don't really know. Seems that the call back from the driver into
itself is possible with mesh too -- I guess we need to decide whether
that is something we do or not.

johannes

