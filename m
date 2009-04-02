Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:64524 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193AbZDBRaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 13:30:14 -0400
Received: by ewy9 with SMTP id 9so651557ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 02 Apr 2009 10:30:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Always send a null data frame if TIM bit is  set.
Date: Thu, 2 Apr 2009 19:30:04 +0200
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Vivek Natarajan <vivek.natraj@gmail.com>,
	linux-wireless@vger.kernel.org
References: <20090302145030.GA4660@myhost.users.atheros.com> <87ocvfiovd.fsf@litku.valot.fi> <1238666571.4141.14.camel@johannes.local>
In-Reply-To: <1238666571.4141.14.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200904021930.06031.IvDoorn@gmail.com> (sfid-20090402_193020_823764_2137E442)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 April 2009, Johannes Berg wrote:
> On Thu, 2009-04-02 at 08:52 +0300, Kalle Valo wrote:
> 
> > I really would like to have some frame ack callback to mac80211, even
> > not all drivers support that. Otherwise we cannot reliably go to power
> > save because the AP might not receive our nullfunc frame. I have to
> > think about this and I'll try to propose something later on.
> 
> I suppose we could well assume that we do get TX status for those
> devices that do support power save -- which devices would that affect?

rt2500usb and rt73usb don't provide a valid TX status but do support
power save at he moment. I have to add that I'm in contact with somebody
who is looking into supporting Ack-based TX status reporting in mac80211
which could cure this problem. I have directed him to the linux-wireless list
so he will probably soon send his ideas to the list.

In any case, for now we can assume rt2500usb and rt73usb to be a problem.

Ivo
