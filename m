Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:47233 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZHGQzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 12:55:41 -0400
Received: by ewy10 with SMTP id 10so1673447ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 09:55:41 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow DMA optimisation
Date: Fri, 7 Aug 2009 18:55:38 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1249656135.7194.6.camel@johannes.local>
In-Reply-To: <1249656135.7194.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908071855.38921.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> If we have a lot of frames to transmit at once, for
> instance with fragmentation, it can be an optimisation
> to only tell the DMA engine about them on the last
> fragment/frame to avoid banging the IO too much. This
> patch allows implementation such an optimisation by
> telling the driver when more frames can be expected.

Wouldn't this be the same as the
	if (ieee80211_has_morefrags())
		.. kick queue ...

Other then that this flag is very nice, I already had some
similar sort of mechanism build into rt2x00 based on
RTS/CTS and ieee80211_has_morefrags()

> Currently, this is used by mac80211 only on fragmented
> frames, but could also be used in the future on other
> frames when the queue was full and there are multiple
> frames pending.
>
> Note that drivers need to be careful when using this
> flag, they need to kick their DMA engines not just
> when this flag is clear, but also when the queue gets
> full so that progress can be made.

What would a good value be for the threshold?
rt2x00 currently uses 10% of the queue, which means that
2 or 3 entries are kept available at all times.
 
Ivo
