Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:59042 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbYDUVdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 17:33:54 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1904042fgb.17
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 14:33:50 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/9] rt2x00: Use rt2x00 queue numbering
Date: Mon, 21 Apr 2008 23:40:44 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com> <200804211958.31363.IvDoorn@gmail.com> <1208800577.26186.125.camel@johannes.berg>
In-Reply-To: <1208800577.26186.125.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804212340.45024.IvDoorn@gmail.com> (sfid-20080421_233501_533239_BAD2ED92)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 April 2008, Johannes Berg wrote:
> 
> > > This function only exists to move the translation in a single location.
> > > When the translation isn't needed anymore because skb_get_queue_mapping(skb)
> > > or something else is used, then this function can be removed completely. :)
> > 
> > Ps. Can I assume that skb_get_queue_mapping(skb) or whatever replacement
> > for control->queue will make sure the given queue will not exceed the max
> > number of supported queues as configured by the driver (through hw->queues)?
> > 
> > Or should the driver drop such packets or resolve it to the highest queue available?
> 
> Well there are two cases.
> 
> (1) MQ is not configured -> it always returns 0
> (2) MQ is configured, mac80211 will create a device with hw->queues
> queues, so it'll be in the range [0 .. hw->queues-1]

Excellent.
That means the same assumptions can be made about the queue parameter
as with the old solution. :)

Ivo
