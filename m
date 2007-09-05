Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:30969 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbXIETdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 15:33:44 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2697024wah
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2007 12:33:43 -0700 (PDT)
Message-ID: <f6ca9fed0709051233h69f66aebi45aac65ab1a96f0e@mail.gmail.com>
Date: Wed, 5 Sep 2007 21:33:37 +0200
From: dragoran <drago01@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: rfkill interface (was Re: [PATCH V3] Add iwlwifi wireless drivers)
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Tuesday 04 September 2007, dragoran wrote:
> > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > On Tuesday 04 September 2007, dragoran wrote:
> > > > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > > > On Tuesday 04 September 2007, dragoran wrote:
> > > > > > >+static ssize_t show_rf_kill(struct device *d,
> > > > > > >+                        struct device_attribute *attr, char *buf)
> > > > > > >+{
> > > > > > >+    /*
> > > > > > >+     * 0 - RF kill not enabled
> > > > > > >+     * 1 - SW based RF kill active (sysfs)
> > > > > > >+     * 2 - HW based RF kill active
> > > > > > >+     * 3 - Both HW and SW based RF kill active
> > > > > > >
> > > > > > >that as well, along with all the other sysfs bits. Also, how about using
> > > > > > >the generic rfkill infrastructure Ivo did?
> > > > > >
> > > > > > is the generic rfkill interface already stable and merged into the linus tree?
> > > > >
> > > > > Yes. It currently is only missing users.
> > > >
> > > > ok thats great ;) is the (userspace) interface defined somewhere? or
> > > > should I read the code to understand how it works? (would like to add
> > > > support to hal)
> > >
> > > There isn't a documentation file for it, so best thing to do would be looking at the code.
> > > basically hal only needs to check the sysfs files:
> > >
> > >         name -> Name of device/interface
> > >         type -> wlan, bluetooth, irda
> > >         state -> Current device state. 0: Off, 1: On
> > >         claim -> 0: Kernel handles events, 1: Userspace handles events
> > >
> > > "name" and "type" are read-only
> > > "claim" and "state" are read/writable
> > >
> > > Note that there is a bug in 2.6.22 which causes the "state" file to be read-only,
> > > this has been fixed in 2.6.23-rc.
> >
> > ok that isn't complicated what is the claim used for?
> > does It has to be set to userspace to be able to toggle the status via software?
>
> By default the kernel will act when the rfkill button is pressed, it will loop
> through all registered buttons of the same type and change the state.
> Userspace can read the "state" sysfs file to see the current status,
> but if a userspace tools wants to take control of taking action when the button is pressed,
> or at least doesn't want the kernel to do anything, 1 should be written to "claim" to
> tell the kernel that it should back off and ignore all events.

ok thx for explaining this will talk to the nm and hal people about it
and see how they want things to work than I will create patches to
implement it.
which drivers support it now? rt2x00 and ?? or are they the only ones right now?
