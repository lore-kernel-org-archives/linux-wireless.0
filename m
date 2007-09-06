Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:40460 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXIFQjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 12:39:22 -0400
Received: by ug-out-1314.google.com with SMTP id z38so186433ugc
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2007 09:39:21 -0700 (PDT)
To: Dan Williams <dcbw@redhat.com>
Subject: Re: rfkill interface (was Re: [PATCH V3] Add iwlwifi wireless drivers)
Date: Thu, 6 Sep 2007 18:49:36 +0200
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <f6ca9fed0709051233h69f66aebi45aac65ab1a96f0e@mail.gmail.com> <1189039823.13730.4.camel@xo-3E-67-34.localdomain>
In-Reply-To: <1189039823.13730.4.camel@xo-3E-67-34.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200709061849.36579.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 September 2007, Dan Williams wrote:
> On Wed, 2007-09-05 at 21:33 +0200, dragoran wrote:
> > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > On Tuesday 04 September 2007, dragoran wrote:
> > > > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > > > On Tuesday 04 September 2007, dragoran wrote:
> > > > > > On 9/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > > > > > On Tuesday 04 September 2007, dragoran wrote:
> > > > > > > > >+static ssize_t show_rf_kill(struct device *d,
> > > > > > > > >+                        struct device_attribute *attr, char *buf)
> > > > > > > > >+{
> > > > > > > > >+    /*
> > > > > > > > >+     * 0 - RF kill not enabled
> > > > > > > > >+     * 1 - SW based RF kill active (sysfs)
> > > > > > > > >+     * 2 - HW based RF kill active
> > > > > > > > >+     * 3 - Both HW and SW based RF kill active
> > > > > > > > >
> > > > > > > > >that as well, along with all the other sysfs bits. Also, how about using
> > > > > > > > >the generic rfkill infrastructure Ivo did?
> > > > > > > >
> > > > > > > > is the generic rfkill interface already stable and merged into the linus tree?
> > > > > > >
> > > > > > > Yes. It currently is only missing users.
> > > > > >
> > > > > > ok thats great ;) is the (userspace) interface defined somewhere? or
> > > > > > should I read the code to understand how it works? (would like to add
> > > > > > support to hal)
> > > > >
> > > > > There isn't a documentation file for it, so best thing to do would be looking at the code.
> > > > > basically hal only needs to check the sysfs files:
> > > > >
> > > > >         name -> Name of device/interface
> > > > >         type -> wlan, bluetooth, irda
> > > > >         state -> Current device state. 0: Off, 1: On
> > > > >         claim -> 0: Kernel handles events, 1: Userspace handles events
> > > > >
> > > > > "name" and "type" are read-only
> > > > > "claim" and "state" are read/writable
> > > > >
> > > > > Note that there is a bug in 2.6.22 which causes the "state" file to be read-only,
> > > > > this has been fixed in 2.6.23-rc.
> > > >
> > > > ok that isn't complicated what is the claim used for?
> > > > does It has to be set to userspace to be able to toggle the status via software?
> > >
> > > By default the kernel will act when the rfkill button is pressed, it will loop
> > > through all registered buttons of the same type and change the state.
> > > Userspace can read the "state" sysfs file to see the current status,
> > > but if a userspace tools wants to take control of taking action when the button is pressed,
> > > or at least doesn't want the kernel to do anything, 1 should be written to "claim" to
> > > tell the kernel that it should back off and ignore all events.
> > 
> > ok thx for explaining this will talk to the nm and hal people about it
> > and see how they want things to work than I will create patches to
> > implement it.
> > which drivers support it now? rt2x00 and ?? or are they the only ones right now?
> 
> Since it's in the kernel, the next step is to get HAL aware of the
> killswitches through sysfs and not through fdi files keyed on
> Dell/Sony/etc.
> 
> Ivo: how does one tell whether or not the switch needs to be polled?
> That's something that HAL will need to deal with polling/non-polling
> intelligently.  I assume that either the layer or the driver
> implementing the button will know that it needs to be polled and should
> be the thing that sets the value.  Ideally just an attribute in sysfs
> like "require-poll" with a value of 1 or 0 or something like that.

No, because like I explained userspace is not in control of polling,
because there should be no userspace dependency. This means that
if the device requires polling, it should register itself with the input_polldev handler.
This way the radio button will allwats work as expected, without requiring
some version of HAL..

Ivo
