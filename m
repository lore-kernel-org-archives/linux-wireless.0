Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39440 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZJaKRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 06:17:21 -0400
Received: by ewy28 with SMTP id 28so3661806ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 03:17:25 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ieee80211_tx_status: headroom too small
Date: Sat, 31 Oct 2009 11:17:22 +0100
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
References: <1094614475.20091030230028@mail.ru> <200910311044.45687.IvDoorn@gmail.com> <1256983432.3555.121.camel@johannes.local>
In-Reply-To: <1256983432.3555.121.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910311117.22300.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 October 2009, Johannes Berg wrote:
> On Sat, 2009-10-31 at 10:44 +0100, Ivo van Doorn wrote:
> 
> > > Or maybe we should just not bother with having drivers do the alignment
> > > any more -- mac80211 does that now and it only does it if necessary
> > > (i.e. not on powerpc/x86)
> > 
> > I think you mean the RX alignment, while I am talking about the TX alignment.
> > Beacons and some othe frames must be 4-byte alignment because the wireleless
> > hardware requires it.
> 
> Oh, indeed, I got confused.
> 
> Hmm. TX alignment is weird ... no driver really needs that except rt2x00
> afaik. Which frames require this?

At the least the beacons, but I am not sure about if there are other frame types
which also have this requirement.

Users had reported that if they align beacon frames, rt2500pci finally starts
beaconing correctly in master mode.

Ivo
