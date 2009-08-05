Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:48492 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZHES5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 14:57:47 -0400
Received: by ey-out-2122.google.com with SMTP id 9so215939eyd.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 11:57:47 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 TX frame alignment
Date: Wed, 5 Aug 2009 20:57:45 +0200
Cc: linux-wireless@vger.kernel.org
References: <200908041905.11632.IvDoorn@gmail.com> <1249407436.24787.6.camel@johannes.local>
In-Reply-To: <1249407436.24787.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908052057.45715.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Do you know if for outgoing frames the header should always
> > be 4-byte aligned?
> 
> I know that there's no alignment guarantee.
>
> > I have a bugreport from users claiming that master mode
> > is failing for rt2500pci because the beacons passed to the
> > driver are not 4-byte aligned which causes the device not
> > to send out the beacons correctly.
> > 
> > I'm just wondering if this is something that should be fixed
> > in the driver or in mac80211.
> 
> I don't think we can fix that in mac80211, since we don't know whether
> or not any alignment is required. We could align beacon frames, I
> suppose, since those are created on the fly, but not data frames.

Ok, I'll look into a patch for making sure rt2x00 aligns all frames
correctly before mapping the DMA.

Thanks,

Ivo
