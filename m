Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:40408 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbZGKU4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2009 16:56:06 -0400
Received: by ewy26 with SMTP id 26so1820289ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2009 13:56:03 -0700 (PDT)
Message-ID: <4A58FC5C.8060204@gmail.com>
Date: Sat, 11 Jul 2009 21:55:56 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: orinoco-devel@lists.sourceforge.net
CC: David Gerard <dgerard@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] orinoco-usb in 2.6.31?
References: <fbad4e140907081555w3a98c570y54d904272094008@mail.gmail.com> <4A577DA9.9000205@gmail.com> <4A57DC26.4090708@gmail.com>
In-Reply-To: <4A57DC26.4090708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave wrote:
> Dave wrote:
>> David Gerard wrote:
>>> I'm trying to get the infamous Compaq W200 wifi adapter working in
>>> Ubuntu Karmic Koala (9.10), which uses kernel 2.6.31. Unfortunately,
>>> the latest version of orinoco_usb (svn rev 1300) doesn't compile with
>>> this kernel, even with the patch that got the driver working in
>>> 2.6.27/28 (Ubuntu 8.10/9.04).
 >
> I've set up a git repo* containing the recent usb patches, and dropped
> some simple history into it. At some point I'll see if I can rebase the
> usb branch to recent mainline.
> 
> * <http://repo.or.cz/w/orinoco_usb.git>

The rebasing was a little painful due to all the changes that have been
happening on orinoco. However I think I'm done.

What can you do? If you have one of these USB sticks and a kernel after
.27, please test (because I can't). Testing with 2.6.30 is most useful,
but I'll be happy with anything.

Kernel		Please test baseline
v2.6.27		usb-no-wpa-v2.6.27
v2.6.28		usb-no-move-v2.6.28
v2.6.29		usb-no-refactor-v2.6.29
v2.6.30		usb-no-cfg80211-v2.6.30
v2.6.31-rc	usb-no-cfg80211-v2.6.30

If the above baseline doesn't work for you, it's possible that there's
another baseline you can try - see below for a description of what's in
the repo.

At the very bottom of this email there's a quick note on building the
driver.

I'll try to update this repo for the next few kernel releases. But
hopefully I can have look at merging this to mainline after orinocos
cfg80211 support is done.


Enjoy,

Dave.

---
What's in the repository?

The master branch in the above repository is unchanged - it holds the
sources from svn based on 2.6.18 with build fixes for later kernels.

There are 4 other branches based off of 2.6.27/28/29/30 which have
rebased versions of the driver from master, broken down into the primary
conceptual changes. The branches are the version numbers with a -usb
suffix. If you need the firmware tools, stick with master.

At the end of each branch I've included the build fixes that allow the
branch to build with a more recent kernel.

Basically you want to try the branch for your kernel first. If it
doesn't work, go back to the previous branch. On a given branch use the
latest baseline with a lower (or equal) kernel version in the baseline name.

v2.6.27 is the last release before things really started changing. This
branch has the best chance of working, and just ensures we've picked up
all the fixes that have come in. It does include a change in scanning
which might break USB.

v2.6.28 introduced firmware download and WPA on the Agere devices. I've
explicitly disabled firmware download for the Agere USB devices -
someones going to have to figure out how to actually do that. If you
happen to have a 9.42 Agere firmware on your USB stick the driver will
attempt to do WPAish things. This is highly unlikely to work, but I
don't expect any sticks to have that firmware.

v2.6.29 didn't contain too many functional changes from .28. I think
there might be an oops fix. However code moved directories here, so it
made sense to rebase on top of this release.

v2.6.30 contained a refactorring of orinoco.c. A lot of the merging had
to be done manually here, so it's possible I've broken something.

---
Some notes on building:

If you're building from master, build from the directory containing the
source:

cd drivers/net/wireless
make KERNEL_PATH=xxx


On the branches I've kept the makefiles in that directory exactly the
same as mainline, so build at the root of the tree.

cd drivers/net/wireless/../../..
make KERNEL_PATH=xxx
