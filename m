Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f167.google.com ([209.85.218.167]:39030 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZBSGdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 01:33:41 -0500
Received: by bwz11 with SMTP id 11so317942bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 22:33:39 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
	<8763j7qyfx.fsf@litku.valot.fi> <1235014330.6344.18.camel@rainbow>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 19 Feb 2009 08:33:37 +0200
In-Reply-To: <1235014330.6344.18.camel@rainbow> (Jason Andryuk's message of "Wed\, 18 Feb 2009 22\:32\:10 -0500")
Message-ID: <87fxibhr5q.fsf@litku.valot.fi> (sfid-20090219_073345_972619_F6DA60F0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> On Wed, 2009-02-18 at 22:31 +0200, Kalle Valo wrote:
>> Jason Andryuk <jandryuk@gmail.com> writes:
>> 
>> > Additionally, I added some ieee80211_{wake,stop}_queues calls that
>> > were contained in the older at76_usb.  There is ambiguity as to
>> > whether at76_join should be called before or after waking the queues.
>> 
>> I would like to have a separate patch for this. Also I would like to
>> know what kind of bug this fixes.
>> 
>> Sorry to be so picky, but I'm going to push the driver into mainline
>> soon and I try avoid regressions right now.
>
> I must admit, I do not have the best understanding of the driver.

Don't worry, we both are new here. I'm not that familiar with usb :)

> As such, I was making modifications to at76c50x-usb to be as similar
> to at76_usb+mac80211 as possible to prevent the driver from
> oops-ing.

I'm very glad that you have been working with that, it has helped me a
lot.

> I don't know the proper usage of ieee80211_{wake,stop}_queues, but my
> understanding is they should be called at different times to indicate
> readiness for transmitting frames to the mac80211 stack.

Yes, you have understood correctly. It's just that I don't see any
problems with my device, so I would like to understand why these
changes are needed and what issue they fix. I didn't analyse this
properly yet, though.

> I am having issues with my Linksys WUSB11 adapter.  It has the intersil
> 3861 and the scan command is reporting Command Status of 0x03 - Invalid
> parameter.  For right now, scanning does not work for me.

Oh, that's bad. And the device is working fine with the old at76_usb
driver? Can you send some debug logs, please? Especially I'm
interested about hardware differences between your Linksys and the
Belkin I have.

> Sorry about the corrupt patches.  The gmail web interface was causing
> problems.

No problem, I'm used to this. For example at work our mail servers are
corrupting all patches. We need to send them as attachments and even
gzip so that the mail don't convert tabs to spaces. Not fun at all :/

-- 
Kalle Valo
