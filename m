Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55138 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeBWKvH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 05:51:07 -0500
Message-ID: <1519383062.2231.5.camel@sipsolutions.net> (sfid-20180223_115121_612537_ECAABC6D)
Subject: Re: [PATCH 2/3] mwifiex: support sysfs initiated device coredump
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 23 Feb 2018 11:51:02 +0100
In-Reply-To: <5A8FEF68.5080900@broadcom.com> (sfid-20180223_113938_578183_0B4B09C3)
References: <1519210220-22437-1-git-send-email-arend.vanspriel@broadcom.com>
         <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
         <20180221225903.GA42395@rodete-desktop-imager.corp.google.com>
         <5A8EB4F4.2030103@broadcom.com>
         <20180222193547.GA78462@rodete-desktop-imager.corp.google.com>
         <5A8FEF68.5080900@broadcom.com> (sfid-20180223_113938_578183_0B4B09C3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

Hadn't really followed this discussion much due to other fires
elsewhere :-)

On Fri, 2018-02-23 at 11:39 +0100, Arend van Spriel wrote:

> > > Well, that depends on the eye of the beholder I guess. From user-space
> > > perspective it is asynchronous regardless. A write access to the coredump
> > > sysfs file eventually results in a uevent when the devcoredump entry is
> > > created, ie. after driver has made a dev_coredump API call. Whether the
> > > driver does that synchronously or asynchronously is irrelevant as far as
> > > user-space is concerned.
> > 
> > Is it really? The driver infrastructure seems to guarantee that the
> > entirety of a driver's ->coredump() will complete before returning from
> > the write. So it might be reasonable for some user to assume (based on
> > implementation details, e.g., of brcmfmac) that the devcoredump will be
> > ready by the time the write() syscall returns, absent documentation that
> > says otherwise. But then, that's not how mwifiex works right now, so
> > they might be surprised if they switch drivers.

I can see how you might want to have that kind of behaviour, but you'd
have to jump through some hoops to see if the coredump you saw is
actually the right one - you probably want an asynchronous coredump
"collector" and then wait for it to show up (with some reasonable
timeout) on the actual filesystem, not on sysfs?

Otherwise you have to trawl sysfs for the right coredump I guess, which
too is possible.

> > > You are right. Clearly I did not reach the end my learning curve here. I
> > > assumed referring to the existing dev_coredump facility was sufficient, but
> > > maybe it is worth a patch to be more explicit and mention the uevent
> > > behavior. Also dev_coredump facility may be disabled upon which the trigger
> > > will have no effect in sysfs. In the kernel the data passed by the driver is
> > > simply freed by dev_coredump facility.
> > 
> > Is there any other documentation for the coredump feature? I don't
> > really see much.
> 
> Any other than the code itself you mean? I am not sure. Maybe Johannes 
> knows.

There isn't really, it originally was really simple, but then somebody
(Kees perhaps?) requested a way to turn it off forever for security or
privacy concerns and it became more complicated.

> > static ssize_t coredump_store(struct device *dev, struct device_attribute *attr,
> > 			    const char *buf, size_t count)
> > {
> > 	device_lock(dev);
> > 	if (dev->driver->coredump)
> > 		dev->driver->coredump(dev);
> > 	device_unlock(dev);
> > 
> > 	return count;
> > }
> > static DEVICE_ATTR_WO(coredump);
> > 
> > Is that a bug or a feature?
> 
> Yeah. Let's call it a bug. Just not sure what to go for. Return the 
> error or change coredump callback to void return type.

I'm not sure it matters all that much - the underlying devcoredump
calls all have no return value (void), and given the above complexities
with the ability to turn off devcoredumping entirely you cannot rely on
this return value to tell you if a dump was created or not, at least
not without much more infrastructure work.

johannes
