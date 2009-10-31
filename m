Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50387 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbZJaJon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 05:44:43 -0400
Received: by mail-ew0-f228.google.com with SMTP id 28so3652769ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 02:44:48 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ieee80211_tx_status: headroom too small
Date: Sat, 31 Oct 2009 10:44:45 +0100
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
References: <1094614475.20091030230028@mail.ru> <200910311030.45582.IvDoorn@gmail.com> <1256981677.3555.94.camel@johannes.local>
In-Reply-To: <1256981677.3555.94.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910311044.45687.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 October 2009, Johannes Berg wrote:
> On Sat, 2009-10-31 at 10:30 +0100, Ivo van Doorn wrote:
> 
> > > > 4 actually, wasn't there some cases where the header could have an odd
> > > > number of bytes and would require 3 bytes for alignment?
> > > 
> > > Hm, is there? I thought they changed the 11s draft to no longer have
> > > that.
> > 
> > Well 2 is fine in that case, (I was basing my comment on something said on this mailinglist
> > a long time ago). :)
> 
> However, it really all depends on the hardware too ... Maybe we should
> put more of the logic into drivers, and have mac80211 only export its
> required headroom?
> 
> Or maybe we should just not bother with having drivers do the alignment
> any more -- mac80211 does that now and it only does it if necessary
> (i.e. not on powerpc/x86)

I think you mean the RX alignment, while I am talking about the TX alignment.
Beacons and some othe frames must be 4-byte alignment because the wireleless
hardware requires it.

Ivo
