Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37105 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757138AbZKDQQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 11:16:14 -0500
Date: Wed, 4 Nov 2009 11:16:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Frank Schaefer <schaefer.frank@gmx.net>
cc: USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
In-Reply-To: <4AF095C3.5020409@gmx.net>
Message-ID: <Pine.LNX.4.44L0.0911041036100.2968-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 3 Nov 2009, Frank Schaefer wrote:

> Basically, I have no problem to agree here.
> But what's the price we pay for this solution(s) in this case (and most
> other devices with windows-driver-disc-mode) ?
> You should not ignore the problems coming-up with the discussed
> userspace-solutions.
> This is not ONLY about technical aspects. We already discussed usability
> and maintanance. Think about the whole product, not only the kernel-part.
> Then, please, make a list of ALL pros and cons a make a pragmatic decision.

Here's my first attempt at considering all the pros and cons.  Has
anything important been left out?

First, let's consider the case where the relevant drivers/programs are 
already present when a switchable device is plugged in.  Then 
presumably it all works correctly and there's no problem.  :-)

So second, let's consider the case where the drivers/programs are not
already present.  The device does not get switched automatically.  In
order to do anything with it, the user must upgrade his system.

     1. If the mode-switch code is in the kernel: The user must install
	a new kernel.  This might mean downloading a new version from
	the distro or it might mean installing a patch and rebuilding
	manually.

     2. If the mode-switch code is in userspace: The user must update 
	the mode-switch program.  This might mean adding a line to a 
	udev script file, installing a new binary package, or 
	downloading new source code to usb_modeswitch and rebuilding 
	manually.

     3. If the policy is handled by a userspace program while the
	mechanism is handled by the kernel: The user will have to carry
	out 1 or 2 or possibly both.  Hence this case reduces to the
	earlier cases (plus the fact that the user somehow has to
	determine which steps are necessary).

Either way, once the upgrade has been done the device will work.  So 
the only question is which is easier for everybody, 1 or 2?

Clearly 1 puts more of a burden on the kernel/distro developers while 2
puts more of a burden on the userspace support teams.  But they
comprise a relatively small number of people compared to the total user
population.  For users, then, which is easier?

Downloading a new kernel package is roughly equivalent to downloading a 
new usb_modeswitch binary package.  It takes longer and there might be 
administrative issues (updating the kernel has more repercussions than 
updating a single program), but overall they are similar.

Clearly editing a udev script is very easy.  Downloading patches or 
source code and rebuilding by hand requires a certain amount of skill, 
and it is not something most people would care to do -- although if 
they had to, building a program is much easier than building a kernel.

Thus, in terms of the amount of work required of the user, I'd say that 
1 is worse than 2.  But there's more to consider.  How long does it 
take for new-device support to get disseminated?

User programs like usb_modeswitch can be updated very rapidly.  It's
merely a question of writing the new code and making it publicly
available in the appropriate repository.  Typically this might involve
a delay of a few days.  By contrast, new kernels appear roughly every
three months.  It's possible that new mode-switch code would be allowed
in a stable release (although this is far from certain).  If so, then
the delay could drop as low as a few weeks.

Thus, in terms of the delay time for new support, I'd say again that 1
is worse than 2.  Finally, let's consider adding support for a new 
device to an old system.

An old system is not readily upgradable.  But _some_ sort of upgrade is 
needed to support new devices.

	If all that is needed is a modification to a udev script,
	there is no problem.

	Installing a new version of a program might be difficult
	because of library dependencies that aren't up to date.

	Installing a new version of the kernel might be difficult
	because of incompatibilities with old userspace components.

Comparing the last two directly is hard; either could be a
show-stopper.  The ideal solution would be to provide a way to upgrade
a mode-switching program by modifying a text configuration or script
file rather than by changing the code.  For example, if usb_modeswitch
could parse a text file containing device IDs to match and packet
contents to send, then upgrades would be very easy.

In short, for users I don't see any advantage to putting the
mode-switching stuff in the kernel, whereas there may be considerable
advantages to putting it in userspace.

The only exception would be the case that Oliver is worried about,
where a device loses its mode setting during a reset or system sleep.  
In principle the kernel could put it back in the correct mode while
keeping the device's identity intact (although the code to do this
would be extremely ugly, and convincing people to allow it would be
hard).  Even then, I don't see how existing serial/phone connections
could be maintained across a reset, so there might not be any point.

Alan Stern

