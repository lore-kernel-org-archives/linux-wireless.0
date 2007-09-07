Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:45597 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592AbXIGViV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 17:38:21 -0400
Received: by wa-out-1112.google.com with SMTP id v27so671952wah
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2007 14:38:21 -0700 (PDT)
Message-ID: <6b8cef970709071438o6870cecej355119fee4396dcb@mail.gmail.com>
Date: Fri, 7 Sep 2007 17:38:20 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1189193840.28781.197.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
	 <1189125944.28781.125.camel@johannes.berg>
	 <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
	 <1189193840.28781.197.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forgot to "reply to all." Resending.

On 9/7/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-09-07 at 15:31 -0400, Rob Hussey wrote:
>
> > This was with wireless-dev git. I can try DEBUG_KOBJECT once I get a chance.
>
> That'd be good.
>

I took some pictures of the screen with DEBUG_KOBJECT enabled. It's
tough to get it all though, since the messages don't really fit on one
screen. I played around with the vga= line, and was able to get the
scrolling to stop at different points (the stack trace and all appears
about 1 msec after booting, so this was my only choice). The pictures
can be found here:
http://www.healthcarelinen.com/misc/

These two are probably the best:
http://www.healthcarelinen.com/misc/101_1988.jpg
http://www.healthcarelinen.com/misc/101_1992.jpg

Hopefully the pictures have what you need.

> > I'd like to try to bisect this though, but I'm having trouble finding
> > a point in which it worked.
>
> > If I do:
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git
> > and then:
> > git pull . remotes/origin/rt2x00
> >
> > Then my commit history has all rt2x00 commits on top, and trying to
> > reset to an earlier point in time reverts rt2x00 commits, but not
> > wireless-dev commits (unless I  reset to before the initial rt2x00
> > commit). This causes compile errors mostly involving undeclared stuff
> > prefixed "IEEE80211_" Is there a better way to do this? Did I even
> > start out correctly?
>
> I'm not sure you can bisect due to the way mac80211/rt2x00 are currently
> developed, in lockstep but in different branches that are pulled
> together.
>

Bummer.
