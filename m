Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:30354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761546AbYAKTvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 14:51:49 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1240540fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 11:51:47 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 06/12] rt2x00: Put 802.11 data on 4 byte boundary
Date: Fri, 11 Jan 2008 20:51:41 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200801062337.35904.IvDoorn@gmail.com> <200801062340.27509.IvDoorn@gmail.com> <1200011531.3861.118.camel@johannes.berg>
In-Reply-To: <1200011531.3861.118.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801112051.41913.IvDoorn@gmail.com> (sfid-20080111_195154_609060_1D81A987)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Sorry I'm late in noticing this :\
> 
> > +		/*
> > +		 * The data behind the ieee80211 header must be
> > +		 * aligned on a 4 byte boundary.
> > +		 */
> > +		align = NET_IP_ALIGN + (2 * (header_size % 4 == 0));
> 
> I don't think you should be using NET_IP_ALIGN at all, I think the code
> should be just
> 
> 		align = header_size % 4;
> 
> (which will evaluate to two or four).

Makes sense. I'll fix this asap.

> I have, so far, in mac80211 forced you to align the 802.11 data payload
> to a four-byte boundary *even on powerpc* which is the only platform
> where NET_IP_ALIGN is not two (it is zero because DMA sucks when done to
> unaligned addresses on some powerpc machines).

Ouch, that would make rt2x00usb panicking as soon as it is used when
NET_IP_ALIGN in 0 and alignment is needed. :S
This will be fixed asap as well.

Thanks,

Ivo
