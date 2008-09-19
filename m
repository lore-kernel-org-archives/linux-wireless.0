Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:43581 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYISUB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 16:01:26 -0400
Received: by ug-out-1314.google.com with SMTP id k3so1067510ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 13:01:24 -0700 (PDT)
Date: Fri, 19 Sep 2008 16:01:15 -0400
From: Celejar <celejar@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Subject: Re: Can't connect to AP with hidden essid with 2.6.27-rc6
Message-Id: <20080919160115.c591532c.celejar@gmail.com> (sfid-20080919_220130_940373_CB00ECA8)
In-Reply-To: <48D3FB0F.1000909@lwfinger.net>
References: <20080916220904.75283811.celejar@gmail.com>
	<48D06B9E.70307@lwfinger.net>
	<20080918004509.23a4bdc9.celejar@gmail.com>
	<48D1E42C.70904@lwfinger.net>
	<20080918015202.8c5f6381.celejar@gmail.com>
	<48D24911.80101@lwfinger.net>
	<20080918160957.94ea063d.celejar@gmail.com>
	<48D2D728.6070105@lwfinger.net>
	<20080919001050.d9ed273a.celejar@gmail.com>
	<48D3CFBC.6070504@lwfinger.net>
	<43e72e890809191105p26841666l50a4a139a7177590@mail.gmail.com>
	<20080919142740.60e2c0e8.celejar@gmail.com>
	<48D3FB0F.1000909@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 19 Sep 2008 14:18:39 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Celejar wrote:
> > On Fri, 19 Sep 2008 11:05:35 -0700
> > "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
> > 
> >> On Fri, Sep 19, 2008 at 9:13 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> >>
> >>> I do not think a bisection is necessary. Your successful test of the
> >>> old regulatory code suggests to me that there is some kind of problem
> >>> with the CRDA database.
> >> BTW the "old regulatory code" is actually not "old regulatory code"
> >> but instead static regulatory definitions slapped in the kernel just
> >> as they were before but under the new regulatory infrastructure guise.
> >>
> >>> Luis - to fill you in, he can connect to an AP with a hidden essid
> >>> using the old regulatory code, but not using CRDA. There seems to be
> >>> some critical difference between them.
> >> Thanks for bringing this up Larry.
> >>
> >> If by old regulatory code you mean with CONFIG_WIRELESS_OLD_REGULATORY
> >> then I would narrow the search down to testing as follows:
> >>
> >> --- Without crda:
> >>
> >> mv /sbin/crda /sbin/crda-foo
> >> sudo rmmod your_driver mac80211 cfg80211
> >> sudo modprobe your_driver
> >>
> >> # Check channels using iw
> >>
> >> --- With crda:
> >> mv /sbin/crda-foo /sbin/crda
> >> sudo rmmod your_driver mac80211 cfg80211
> >> sudo modprobe your_driver
> >>
> >> # check channels using iw
> >> ---
> >>
> >> By default when CONFIG_WIRELESS_OLD_REGULATORY is set the built-in
> >> "US" static regulatory domain is used. If crda is present though a new
> >> regulatory domain will be updated onto the kernel, so we'll get the
> >> new regulatory domain built by crda from the original db.txt. Without
> >> crda present the static regulatory domain shall be used.
> >>
> >> What frequency is the AP on?
> > 
> > I (the user) am currently connecting successfully with CRDA to a hidden
> > essid AP.  I previously had claimed that it was still not working, even
> > though the iw channel output looked good, but it currently seems to be
> > okay.  I may have previously done something wrong, such as not
> > rebuilding CRDA for the current kernel, although in that case I'm not
> > sure why the iw output would have been correct.  In any event, at this
> > point it seems that it may have been some mistake on my part.  Thanks
> > for the help, sorry for the noise, and I'll report back if I see any
> > more trouble.
> 
> Is it correct that your current setup has
> CONFIG_WIRELESS_OLD_REGULATORY set? If I remember correctly, your
> previous failure with CRDA was with CONFIG_WIRELESS_OLD_REGULATORY
> unset. If that is true, could you please unset it and try again. The
> code paths are different.

My current setup does not have CONFIG_WIRELESS_OLD_REGULATORY set.

> I think that CRDA runs in userspace and should be relatively
> independent of kernel version.

You are right.  I had thought that although it runs in userspace, since
the build seems to use headers specific to the running kernel, that
might be significant, but I have tested and it does not seem to make a
difference, at least between the two fairly recent -rc6 kernel that I
tried. From the CRDA Makefile:

ifeq ($(origin $(KLIB)), undefined)
KLIB:=          /lib/modules/$(shell uname -r)
endif
KLIB_BUILD ?=   $(KLIB)/build

...

CFLAGS += -I$(KLIB_BUILD)/include -DUSE_GCRYPT

I think the problem I had was that on boot, the b43 / 80211 modules get
loaded, but they don't seem to be calling CRDA, and I can't access my
hidden essid AP.  Doing the module removal and reloading that Luis
suggested causes CRDA to be called, and then things work fine.

> Larry

Celejar
--
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

