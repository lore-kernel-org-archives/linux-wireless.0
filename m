Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:58461 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab0BDJPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 04:15:01 -0500
Received: by ey-out-2122.google.com with SMTP id d26so521887eyd.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 01:14:59 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mac80211: Retry null data frame for power save.
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
	<1265271903.29119.107.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 04 Feb 2010 11:14:56 +0200
In-Reply-To: <1265271903.29119.107.camel@johannes.local> (Johannes Berg's message of "Thu\, 04 Feb 2010 09\:25\:03 +0100")
Message-ID: <87hbpxjran.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On the other hand, there is hardware (even from Atheros/Zydas!) that
> will not provide status reports for every frame.

Also at76c50x-usb doesn't report status AFAIK. I think we need to have
a new hw flag to indicate if driver reports frame status.

> Also, I'm not entirely sure why the AP would lose the frame? It's a
> unicast frame that will be retransmitted quite a number of times. Is it
> really actually going out on the air or is there something else wrong?
> Maybe just the queue priority inversion issue since this frame goes out
> as higher priority as most data frames?

I have received reports that in a busy office networks nullfunc frames
get lost, I'm assuming due to collisions on the air. For example,
wl1251 (in which firmware sends the nullfunc frame) sends an event to
the host if nullfunc frame fails for some reason. I think we need to
take into account in mac80211 the case when nullfunc frames get lost.

> If you really need to provide this functionality I think you should
> probably do it "properly" in the sense that you react to the "frame
> acked" by enabling PS, rather than the other way around.

This is much better. Also I'm worried about the test for nullfunc
frame being a racy. I would prefer to make it sure that the nullfunc
frame really is for the powersave transition.

> That requires a hardware flag though that enables mac80211 to know
> that all frames will get a status report unless something is
> seriously wrong, since otherwise we'd *never* go into PS.

Agreed.

-- 
Kalle Valo
