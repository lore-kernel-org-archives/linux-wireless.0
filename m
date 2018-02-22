Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:37043 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbeBVTfw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 14:35:52 -0500
Received: by mail-pf0-f194.google.com with SMTP id s24so2491525pfm.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2018 11:35:52 -0800 (PST)
Date: Thu, 22 Feb 2018 11:35:49 -0800
From: Brian Norris <briannorris@chromium.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] mwifiex: support sysfs initiated device coredump
Message-ID: <20180222193547.GA78462@rodete-desktop-imager.corp.google.com> (sfid-20180222_203611_338475_C6A16466)
References: <1519210220-22437-1-git-send-email-arend.vanspriel@broadcom.com>
 <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
 <20180221225903.GA42395@rodete-desktop-imager.corp.google.com>
 <5A8EB4F4.2030103@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A8EB4F4.2030103@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Thu, Feb 22, 2018 at 01:17:56PM +0100, Arend van Spriel wrote:
> On 2/21/2018 11:59 PM, Brian Norris wrote:
> > On Wed, Feb 21, 2018 at 11:50:19AM +0100, Arend van Spriel wrote:
> > > Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
> > > it is possible to initiate a device coredump from user-space. This
> > > patch adds support for it adding the .coredump() driver callback.
> > > As there is no longer a need to initiate it through debugfs remove
> > > that code.
> > > 
> > > Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > > ---
> > >   drivers/net/wireless/marvell/mwifiex/debugfs.c | 31 +-------------------------
> > >   drivers/net/wireless/marvell/mwifiex/pcie.c    | 19 ++++++++++++++--
> > >   drivers/net/wireless/marvell/mwifiex/sdio.c    | 13 +++++++++++
> > >   drivers/net/wireless/marvell/mwifiex/usb.c     | 14 ++++++++++++
> > >   4 files changed, 45 insertions(+), 32 deletions(-)
> > 
> > The documentation doesn't really say [1], but is the coredump supposed
> > to happen synchronously? Because the mwifiex implementation is
> > asynchronous, whereas it looks like the brcmfmac one is synchronous.
> 
> Well, that depends on the eye of the beholder I guess. From user-space
> perspective it is asynchronous regardless. A write access to the coredump
> sysfs file eventually results in a uevent when the devcoredump entry is
> created, ie. after driver has made a dev_coredump API call. Whether the
> driver does that synchronously or asynchronously is irrelevant as far as
> user-space is concerned.

Is it really? The driver infrastructure seems to guarantee that the
entirety of a driver's ->coredump() will complete before returning from
the write. So it might be reasonable for some user to assume (based on
implementation details, e.g., of brcmfmac) that the devcoredump will be
ready by the time the write() syscall returns, absent documentation that
says otherwise. But then, that's not how mwifiex works right now, so
they might be surprised if they switch drivers.

Anyway, *I'm* already personally used to these dumps being asynchronous,
and writing tooling to listen for the uevent instead. But that doesn't
mean everyone will be.

Also, due to the differences in async/sync, mwifiex doesn't really
provide you much chance for error handling, because most errors would be
asynchronous. So brcmfmac's "coredump" has more chance for user programs
to error-check than mwifiex's (due to the asynchronous nature) [1].

BTW, I push on this mostly because this is migrating from a debugfs
feature (that is easy to hand-wave off as not really providing a
consistent/stable API, etc., etc.) to a documented sysfs feature. If it
were left to rot in debugfs, I probably wouldn't be as bothered ;)

> > Brian
> > 
> > [1] In fact, the ABI documentation really just describes kernel
> > internals, rather than documenting any user-facing details, from what I
> > can tell.
> 
> You are right. Clearly I did not reach the end my learning curve here. I
> assumed referring to the existing dev_coredump facility was sufficient, but
> maybe it is worth a patch to be more explicit and mention the uevent
> behavior. Also dev_coredump facility may be disabled upon which the trigger
> will have no effect in sysfs. In the kernel the data passed by the driver is
> simply freed by dev_coredump facility.

Is there any other documentation for the coredump feature? I don't
really see much.

Brian

[1] Oh wait, but I see that while ->coredump() has an integer return
code...the caller ignores it:

static ssize_t coredump_store(struct device *dev, struct device_attribute *attr,
			    const char *buf, size_t count)
{
	device_lock(dev);
	if (dev->driver->coredump)
		dev->driver->coredump(dev);
	device_unlock(dev);

	return count;
}
static DEVICE_ATTR_WO(coredump);

Is that a bug or a feature?
