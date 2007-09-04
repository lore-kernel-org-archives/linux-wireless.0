Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:31906 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbXIDVIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 17:08:44 -0400
Received: by nf-out-0910.google.com with SMTP id f5so1545974nfh
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2007 14:08:43 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Date: Tue, 4 Sep 2007 23:18:46 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com> <200709042058.15463.IvDoorn@gmail.com> <f6ca9fed0709041208rfabb10en634674a6fb64a750@mail.gmail.com>
In-Reply-To: <f6ca9fed0709041208rfabb10en634674a6fb64a750@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709042318.46417.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 September 2007, dragoran wrote:
> On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > On Tuesday 04 September 2007, dragoran wrote:
> > > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > > On Tuesday 04 September 2007, dragoran wrote:
> > > > > >+static ssize_t show_rf_kill(struct device *d,
> > > > > >+                        struct device_attribute *attr, char *buf)
> > > > > >+{
> > > > > >+    /*
> > > > > >+     * 0 - RF kill not enabled
> > > > > >+     * 1 - SW based RF kill active (sysfs)
> > > > > >+     * 2 - HW based RF kill active
> > > > > >+     * 3 - Both HW and SW based RF kill active
> > > > > >
> > > > > >that as well, along with all the other sysfs bits. Also, how about using
> > > > > >the generic rfkill infrastructure Ivo did?
> > > > >
> > > > > is the generic rfkill interface already stable and merged into the linus tree?
> > > >
> > > > Yes. It currently is only missing users.
> > >
> > > ok thats great ;) is the (userspace) interface defined somewhere? or
> > > should I read the code to understand how it works? (would like to add
> > > support to hal)
> >
> > There isn't a documentation file for it, so best thing to do would be looking at the code.
> > basically hal only needs to check the sysfs files:
> >
> >         name -> Name of device/interface
> >         type -> wlan, bluetooth, irda
> >         state -> Current device state. 0: Off, 1: On
> >         claim -> 0: Kernel handles events, 1: Userspace handles events
> >
> > "name" and "type" are read-only
> > "claim" and "state" are read/writable
> >
> > Note that there is a bug in 2.6.22 which causes the "state" file to be read-only,
> > this has been fixed in 2.6.23-rc.
> 
> ok that isn't complicated what is the claim used for?
> does It has to be set to userspace to be able to toggle the status via software?

By default the kernel will act when the rfkill button is pressed, it will loop
through all registered buttons of the same type and change the state.
Userspace can read the "state" sysfs file to see the current status,
but if a userspace tools wants to take control of taking action when the button is pressed,
or at least doesn't want the kernel to do anything, 1 should be written to "claim" to
tell the kernel that it should back off and ignore all events.

Ivo
