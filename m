Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2HUGqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 02:46:09 -0400
Message-ID: <1345531562.4676.11.camel@jlt3.sipsolutions.net> (sfid-20120821_084614_006610_393387B3)
Subject: Re: Missing firmware iwlwifi-2030-5.ucode
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 21 Aug 2012 08:46:02 +0200
In-Reply-To: <5033194A.6030308@lwfinger.net> (sfid-20120821_071459_049721_50621351)
References: <502D0C72.2050207@lwfinger.net>
	 <1345459509.4459.5.camel@jlt3.sipsolutions.net>
	 <50325D89.9080209@lwfinger.net>
	 <1345478494.4459.30.camel@jlt3.sipsolutions.net>
	 <CA+XFjiqyqAiZGcBZB6u13FquBbkgBLDbDFAMLnHRMiK6P0Heww@mail.gmail.com>
	 <5033194A.6030308@lwfinger.net> (sfid-20120821_071459_049721_50621351)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-08-21 at 00:14 -0500, Larry Finger wrote:

> >> Well, yes. That firmware, however, never was never available publicly.
> >> The fact that the driver was released anyway is due to us working on the
> >> driver upstream while working with the experimental internal firmware.

> > Perhaps we should add a Kconfig option to disable internal development
> > hardware - with that option unchecked, support for hardware that is
> > not on the market is disabled, with a printk warning to upgrade the
> > driver in case a user tries to use a driver with a card that it thinks
> > is internal-only. This way, users will get a meaningful error message,
> > rather than a misleading "missing firmware" one.
> > The Kconfig option should also come with a big warning of "Say N
> > unless you are an Intel employee". Maybe it should even be marked
> > BROKEN, like N-PHY was in b43 before it became usable.
> 
> Your suggestion would handle the case where hardware that is only supposed to be 
> available internally has somehow been leaked to the public. In the case of the 
> 2030, it is a device that was intended to be available to the public, and I 
> suspect that Windows and OS X drivers were available with built-in firmware.

Yes, that was likely the case. Except there are no OS X drivers at
all :-)

> My feeling is that the reviewers will need to watch the situation. I certainly 
> plan to monitor every Intel patch for a firmware change, and I will NACK every 
> instance for which that firmware file is not already in linux-firmware. John 
> might not honor my NACK; however, I will be on record.

You're free to, of course, but I don't think we've ever (intentionally)
changed the driver from working with a released firmware image to
working only with unreleased firmware images. In fact, this is the
reason we have firmware versions and try to load multiple versions, so
we can begin working on a newer version internally while the driver
continues to work with older, released versions.

The situation with 2030 devices was different: we worked on a driver and
submitted code into the kernel that given the right firmware could work
with the device. I don't remember, but we may even have thought at the
time that we'd release the -5 firmware version, but then had to use -6.
There was definitely a chance that we could release the right firmware
version and thereby make the previously submitted code work. As it turns
out, we couldn't or didn't (and that we've released a -6 one I can't
just release another one), but that wasn't necessarily something anyone
would have known at the time we submitted the code.

So I guess we could simply not submit the code before the firmware was
released, but it would really just have the same effect on users that
the released code has now -- their old kernel doesn't work with the
device. Today, it's because we ended up releasing the wrong firmware, if
we didn't release the code before the firmware it would be because they
didn't have any driver code at all. I don't see how that would help.


> At least Ben Hutchings 
> caught the attempt to delete the older version of the firmware for the 6205. His 
> diligence saved some users of older kernels from having to scramble to find 
> firmware not in the firmware repo.

Yes, that was indeed a mistake. I guess I got over-excited with the new
firmware being available :-) Different situation though.

johannes

