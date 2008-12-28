Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63599 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbYL1N1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 08:27:01 -0500
Received: by bwz14 with SMTP id 14so15332144bwz.13
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 05:26:58 -0800 (PST)
To: Claudio <der.claudio@aon.at>
Cc: linux-wireless@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: status of at76-usb driver
References: <1230411118.4956956ecb911@webmail.aon.at>
Date: Sun, 28 Dec 2008 15:26:55 +0200
In-Reply-To: <1230411118.4956956ecb911@webmail.aon.at> (Claudio's message of "Sat\, 27 Dec 2008 21\:51\:58 +0100 \(CET\)")
Message-ID: <87fxk8o2g0.fsf@litku.valot.fi> (sfid-20081228_142708_210834_36ECBF5C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Kalle Valo <kalle.valo@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Claudio <der.claudio@aon.at> writes:

> Hi!

Hello,

> Since my hardware stopped working properly due to a distro (ubuntu
> btw) upgrade and I was not able to quickly fix it

I'm sorry to hear this. Can you tell me what Ubuntu version and at76
hardware you have? I have Ubuntu running on one of my test laptops, I
could test it myself.

> I started investigating (again) in \"the case of at76-usb\" and read
> through this mailing-list, the wiki and had a look at the changes in
> the git tree. I am not sure if I understood everything correctly.
>
> Can anyone sum up what the current state for users of at76-usb devices
> is please?
>
> It seems like the working code has been removed from the kernel in
> order to rewrite it anywhere in the future and adapt it to this new
> mac80211 thing. Which means that currently users (like me) have to use
> an old version of linux (like 2.4.22) to make use of their devices.
> Hopefully I am wrong...

The current state is this:

A long time ago I started porting at76_usb to use mac80211, the IEEE
802.11 stack in Linux. It's still buggy, biggest problem is that for
some reason I have to replug the device constantly. I guess firmware
is crashing because of a driver bug, or something like that.
Unfortunately I haven't worked that much on the problem and haven't
been able to solve it yet. As soon as I get good enough stability I
will resubmit it to wireless-testing tree, but I'm not there quite
yet.

Fortunately Greg created staging tree some time ago and included the
original at76_usb driver to the tree:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=drivers/staging/at76_usb;hb=HEAD

So starting from 2.6.28 (please correct me if I'm wrong here) the
original (and working!) at76_usb driver should be included already in
the kernel, it's just up to the distributions to enable it.

Grep, I noticed that the TODO file in your tree doesn't mention
anything about my mac80211 port. I'll send you a patch fixing that.

Also I'm going to rename the mac80211 port to something else for just
to avoid the confusion with the original driver. Last thing I want to
see is having two in-tree drivers with identical names.

-- 
Kalle Valo
