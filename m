Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1EMLzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 07:55:07 -0400
Subject: Re: Setting my WiFi adhoc connection in power save mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jorge Miguel <jmiggal@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20110513115030.GB5516@redhat.com> (sfid-20110513_135049_107032_FDA55541)
References: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com>
	 <20110513115030.GB5516@redhat.com> (sfid-20110513_135049_107032_FDA55541)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 13:55:03 +0200
Message-ID: <1305287703.3487.16.camel@jlt3.sipsolutions.net> (sfid-20110513_135510_900067_6934612B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 13:50 +0200, Stanislaw Gruszka wrote:

> > I need to set power save mode. In order to do so I tried to change
> > period and timeout options of iwconfig command so that beacon period
> > and ATIM window are changed.
> > 
> > For instance
> > :~$ sudo iwconfig wlan0 power period 2
> >     Error for wireless request "Set Power Management" (8B2C):
> >     SET failed on device wlan0 ; Invalid argument.
> > 
> > As you can see I get an error. Is it because it is not supported in my
> > card? Is there any way to set beacon interval and ATIM window
> > parameters?
> 
> This should work until you do this in managed mode, power save is only a
> infrastructure network feature. Particularly this will not work on IBSS
> network  (ad-hoc mode).

Technically there is a PS mechanism for IBSS (ATIM and all that) but
it's not supported in the stack right now.

> Also in kernel 2.6.39, after driver split into iwlegacy, power save
> is marked as not supported by driver. I wonder it was deliberate action
> from Intel developers, or just IEEE80211_HW_SUPPORTS_PS is missed by
> mistake. I'm going to look at this.

Deliberate. On some platforms/systems, the way the device goes to sleep
caused DMA trouble or something like that, and the ucode would sysassert
when it tried to wake itself up. The problem was fairly rare, but of
course the device wakes up 10 times a second or so ...

johannes

