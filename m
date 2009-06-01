Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59072 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbZFAM2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:28:52 -0400
Date: Mon, 1 Jun 2009 09:28:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090601122839.GB11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local> <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com> <1243763887.19302.29.camel@johannes.local> <1243796509.6570.35.camel@localhost.localdomain> <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A238EA2.4040106@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 01 Jun 2009, Alan Jenkins wrote:
>> See, Henrique says that the use case is Thinkpads which store the
>> previous state in the BIOS. But that matters to you only if you use a
>> mixture of operation systems, which we don't have to support.

Well, if you do all in userspace, how do you propose to avoid the usual race
conditions of the sort "radio starts on, but it should have started off",
etc?  You'd have to kick the radios off on rfkill module load for safety,
and that will also cause nastyness (it kicks my built-in wlan
(eeepcargh)/bluetooth(most)/wwan(most) off bus, then hotplugs it again!).

That is just nasty for no good reason.  Just have this thing be read/write.
You will have to sync states at every device open otherwise, in the end it
is just plain more useful to have it read/write to begin with.

> "Other OS's" also includes the BIOS.  My BIOS setup screen has an option  
> to toggle the wireless state.  It's great to have this just work, and  
> annoying to have regressions.

Well, thinkpads don't let you toggle anything on BIOS.  They allow you to
outright lock down things in BIOS, and in that case, the radio becomes
hardware-locked and cannot be turned on no matter what you do, or just plain
doesn't show up anywhere...

>> On the other hand, people on machines that don't store the rfkill state
>> in the BIOS might care about having their machine boot up with the same
>> rfkill state(s) as they shut down with, so the sane thing to do would be

Supporting this kind of hardware is fine.  Lowering the bar to support them,
isn't.

>> to have rfkilld store the state persistently, and then recover it at
>> boot. At which point the BIOS state becomes irrelevant and a detail we

And have the lights flicker?  Not nice.

Just give us the full interface.  Don't do things half-way, it is much worse
on the long road.  And it is a LOT easier on the users of your subsystem as
well.

>> actually end up not even _wanting_ to support because it means we need
>> to be aware of machine differences in userspace.

Expect resistence down this path.  I, for one, won't agree with that.
Others might not as well.  I am open to ideas on how to make functionality
generic, and I am not even putting much of a fuss over the total disregard
of the stable ABI rules shown here, but I will _not_ stand for reduced
functionality.

> I like one of the solutions Marcels suggested, that /dev/rfkill should  
> report the "global default values" only when they have been set - either  
> by userspace or by a platform driver.

It can have default values just fine.  And you can't wait for userspace or
platform drivers to register a default, it just doesn't work, you cannot
expect that all relevant drivers are loaded before "rfkilld".

Just don't expose a rfkill type until the first rfkill structure of that
type gets registered.  THAT closes all holes in a sensible,
principle-of-least-suprise way.  The current code (including the rewrite)
already deals with defaults and firmware-backed state storage just fine in
that case.   All you need is a full interface that deals with global state
hotplug (which ain't difficult, that's one or two more notifications only).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
