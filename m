Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:62009 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbYKEKai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 05:30:38 -0500
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Christoph Hellwig" <hch@infradead.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No ProbeResp - assume out of range
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	<20081104181958.GA22897@infradead.org>
	<43e72e890811041115v1f7901a0w36593f9852d03c86@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 05 Nov 2008 12:30:20 +0200
Message-ID: <87ljvyfosj.fsf@nokia.com> (sfid-20081105_113042_247448_C82EB9E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

> I posted a patch which enables beacons to be received by the STA --
> this however, as was pointed out by the patch that disabled the beacon
> filter on ath5k (note not ath9k, but ath9k also had it disabled),
> increases the number of interrupts on the device, as it seems it
> enables beacons not only for the BSSID you are on but for all BSSIDs.
> Not sure what other devices support and how their beacon filter, if
> they have any, works.

There are beacon filter implementations, for example stlc4560 works
such that it doesn't send any beacons to the host but sends an event
whenever it cannot here beacons anymore.

> The patch I posted is a fix that works with what mac80211 expects --
> beacons. The way I'm inclined to resolve this properly in mac80211
> is so that we tell drivers to enable beacons in STA mode (if it
> supports this, HW_CAP flag I guess) only after we miss a probe
> reply, or while we are scanning, that way we can also listen for
> beacons in case we want to roam away to another AP. Just throwing
> some ideas out there. Any comments?

I and Johannes discussed about this earlier:

http://marc.info/?l=linux-wireless&m=122441202315681&w=2

It should be fairly trivial to implement as a first step, we can
improve it as we learn more.

-- 
Kalle Valo
