Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:28673 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZBSDcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 22:32:14 -0500
Received: by qw-out-2122.google.com with SMTP id 5so145213qwi.37
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 19:32:12 -0800 (PST)
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <8763j7qyfx.fsf@litku.valot.fi>
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
	 <8763j7qyfx.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 22:32:10 -0500
Message-Id: <1235014330.6344.18.camel@rainbow> (sfid-20090219_043221_569988_EA9E240A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-18 at 22:31 +0200, Kalle Valo wrote:
> Jason Andryuk <jandryuk@gmail.com> writes:
> 
> > With the latest mac80211 stack, the driver needs to be updated for
> > cfg80211 scanning.  I based the changes off of modifications for
> > at76_usb found here:
> > http://johannes.sipsolutions.net/patches/old/all/2008-09-19-13:35/020-cfg80211-scan.patch
> >
> > The trick was that max_signal also needs to be set to avoid a divide
> > by zero Oops.  I just guessed and used the value 100 for now.
> 
> Thank you for doing this. Unfortunately the patch was corrupted, so I
> had to manually take your changes. I also included the
> ieee80211_scan_compileted() fix to this patch.
> 
> > Additionally, I added some ieee80211_{wake,stop}_queues calls that
> > were contained in the older at76_usb.  There is ambiguity as to
> > whether at76_join should be called before or after waking the queues.
> 
> I would like to have a separate patch for this. Also I would like to
> know what kind of bug this fixes.
> 
> Sorry to be so picky, but I'm going to push the driver into mainline
> soon and I try avoid regressions right now.

I must admit, I do not have the best understanding of the driver.  As
such, I was making modifications to at76c50x-usb to be as similar to
at76_usb+mac80211 as possible to prevent the driver from oops-ing.

I don't know the proper usage of ieee80211_{wake,stop}_queues, but my
understanding is they should be called at different times to indicate
readiness for transmitting frames to the mac80211 stack.

I am having issues with my Linksys WUSB11 adapter.  It has the intersil
3861 and the scan command is reporting Command Status of 0x03 - Invalid
parameter.  For right now, scanning does not work for me.

Sorry about the corrupt patches.  The gmail web interface was causing
problems.

Take care.

Jason

