Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:13378 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXIDTIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 15:08:51 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2324991wah
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2007 12:08:50 -0700 (PDT)
Message-ID: <f6ca9fed0709041208rfabb10en634674a6fb64a750@mail.gmail.com>
Date: Tue, 4 Sep 2007 21:08:45 +0200
From: dragoran <drago01@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
In-Reply-To: <200709042058.15463.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com>
	 <200709042015.34764.IvDoorn@gmail.com>
	 <f6ca9fed0709041118o2dcd4b18mcb25f2b93f648479@mail.gmail.com>
	 <200709042058.15463.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Tuesday 04 September 2007, dragoran wrote:
> > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > On Tuesday 04 September 2007, dragoran wrote:
> > > > >+static ssize_t show_rf_kill(struct device *d,
> > > > >+                        struct device_attribute *attr, char *buf)
> > > > >+{
> > > > >+    /*
> > > > >+     * 0 - RF kill not enabled
> > > > >+     * 1 - SW based RF kill active (sysfs)
> > > > >+     * 2 - HW based RF kill active
> > > > >+     * 3 - Both HW and SW based RF kill active
> > > > >
> > > > >that as well, along with all the other sysfs bits. Also, how about using
> > > > >the generic rfkill infrastructure Ivo did?
> > > >
> > > > is the generic rfkill interface already stable and merged into the linus tree?
> > >
> > > Yes. It currently is only missing users.
> >
> > ok thats great ;) is the (userspace) interface defined somewhere? or
> > should I read the code to understand how it works? (would like to add
> > support to hal)
>
> There isn't a documentation file for it, so best thing to do would be looking at the code.
> basically hal only needs to check the sysfs files:
>
>         name -> Name of device/interface
>         type -> wlan, bluetooth, irda
>         state -> Current device state. 0: Off, 1: On
>         claim -> 0: Kernel handles events, 1: Userspace handles events
>
> "name" and "type" are read-only
> "claim" and "state" are read/writable
>
> Note that there is a bug in 2.6.22 which causes the "state" file to be read-only,
> this has been fixed in 2.6.23-rc.

ok that isn't complicated what is the claim used for?
does It has to be set to userspace to be able to toggle the status via software?


> > shouldn't the new interface send events so that polling isn't required?
>
> Not really, rfkill was intended for a generic interface, which would make
> the rfkill buttons work with or without intervention of userspace. So polling
> is required unless the hardware generates interrupts when the button is called.

ok
