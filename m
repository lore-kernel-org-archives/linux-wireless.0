Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:34962 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3EKAw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 20:52:57 -0400
Received: by mail-qc0-f169.google.com with SMTP id z10so2573941qcx.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 May 2013 17:52:57 -0700 (PDT)
MIME-Version: 1.0
From: JoSH Lehan <krellan@gmail.com>
Date: Fri, 10 May 2013 17:52:36 -0700
Message-ID: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com> (sfid-20130511_025300_120352_28E055AC)
Subject: Using compat-drivers conflicts with kernel mac80211 and cfg80211
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there.  I have an embedded system with the 2.6.32 kernel (I
agree that this is rather old, but it's stable on this board, and I'm
hesitant to change it as it's undergone and passed many tests).

The kernel works fine, the drivers included with the kernel work fine,
some additional drivers that I've added work fine (they are out of
kernel, but build against the built kernel).

The problem is with compat-drivers.  I need to get some new wireless
drivers for newly supported hardware, however, compat-drivers insists
on compiling its own mac80211 and cfg80211 drivers, as it compiles the
stack of drivers.  These clash with the mac80211 and cfg80211 drivers
that were compiled along with the kernel.  The module sizes are very
different, it's clear they're not compatible, it's not a small change.
 I couldn't find a way to disable this, and tell compat-drivers to use
mac80211/cfg80211 from my kernel instead of trying to compile its own.

if I load the mac80211 and cfg80211 from compat-drivers, and then load
a driver that was compiled against the kernel, there's no missing
symbols, but it crashes with an oops when it tries to register itself
with the mac80211/cfg80211 stack.

The vice versa also happens.  If I load mac80211/cfg80211 from the
kernel, then load a driver from compat-drivers, I get an oops during
initialization.

It seems I can choose to use the mac80211/cfg80211 that came with the
kernel, *or*, the mac80211/cfg80211 that come with compat-drivers.  Is
this correct?  I'll have to maintain these two mac80211/cfg80211
drivers in separate directories, since they have the same name, and it
will complicate my detection/loading script, but if there's no other
way, then this is what needs to be done.

Could it be because I cross-compile compat-drivers?  Looking at the
installation scripts, it's clearly intended to be ran by the end user
to replace the drivers in their distribution with updated drivers, and
it could be that I missed something when tweaking it to cross-compile
the drivers and not install them locally.

Has anybody else tried to use compat-drivers to build for an embedded
system?  If so, what's the recommended solution?  How to solve the
mac80211/cfg80211 problem, where the kernel-compiled mac80211/cfg80211
modules conflict with their equivalent compat-drivers modules?

Thanks!  Any help would be appreciated.

Josh Lehan
