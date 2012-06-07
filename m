Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2FGGxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 02:53:32 -0400
Received: by dady13 with SMTP id y13so442304dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 23:53:32 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Jun 2012 00:53:32 -0600
Message-ID: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com> (sfid-20120607_085336_733742_267EC859)
Subject: 
From: Sean Patrick Santos <quantheory@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I have had a couple of problems with an adapter using carl9170 (the
device is an X.USB from AirLive). This is with the in-kernel version
from 3.4, and having build the git version of the firmware (although I
switched to an older binary at some point and saw no difference; I
can't date it though).

The first "problem", which is actually mild enough that I wouldn't
bother writing in about it if it was the only issue, is that I get a
lot of messages like these:

[13215.559590] ieee80211 phy2: channel change: 2432 -> 2437 failed (2).
[13215.844041] ieee80211 phy2: channel change: -1 -> 2437 failed (2).
[13215.844044] usb 3-1.2: restart device (7)
[13216.983593] usb 3-1.2: device restarted successfully.
[13216.988414] ieee80211 phy2: Hardware restart was requested

Also occasional blocks like these:

[13548.136457] ieee80211 phy2: invalid plcp cck rate (0).
[13597.224429] ieee80211 phy2: invalid plcp cck rate (0).
[13601.512838] ieee80211 phy2: invalid plcp cck rate (0).

I gather from a previous post on this mailing list that these are
signs of interference in the area, which doesn't surprise me. I have a
draft-N router that can only use the 2.4Ghz range, and there are three
cordless phones, a wall, a microwave, and several other wireless
devices between the adapter and the router. This doesn't bother me
that much, because when the above messages are being printed
performance is usually still OK, and when a restart does happen the
device recovers rapidly. Plus, I'm somewhat stuck with the situation,
since I don't have much control over how things are arranged in this
space, and because the other adapter I have on hand is even worse off,
both in terms of hardware and drivers.

The second, more troubling problem is that I seem to get a "silent"
failure (at least I can't find any errors) if I start a large download
or set of downloads that take more than 10 seconds to a minute (in
particular, trying to clone large directories using mercurial is
impossible, because it will always trigger this problem, though for
some reason git and subversion work most, but not all, of the time).
What I mean by "failure" is that one of these two things will happen:

1. The device will simply fail to receive anything (or trickle out to
a rate of 500 bytes/min), at which point it will remain in that state
for hours, occasionally registering minuscule amounts of activity,
unless it is dis/reconnected to the wireless network (toggling power
to the device or reloading the module also work, but do neither better
nor worse than just reassociating). Upon reconnecting it immediately
works fine, as long as I don't trigger the same problem again.

2. Less often, the device will fail as above, but then suddenly start
working again another minute or so later, allowing the process that
had been overworking it (mercurial, wget, firefox, whatever) to
continue what it was doing for another 10-50 seconds, at which point
the connection trickles out again. This cycle keeps happening until
the process either completes successfully, errors and dies, hangs, or
is killed, at which point everything seems fine again. (Killing the
process does not solve the problem, it just prevents the same process
from causing the problem *again* in the event that the device
spontaneously recovers within a minute or two).

I know that it's physically possible to get a stable connection here,
because the Windows installation on the same machine can almost always
get fairly good speeds with the same device in the same place on the
same network at the same time of day (~25Mbps, lose connection maybe
once per 40 hours of use). I also know this because I can always fix
the problem manually on Linux by reconnecting the device. What I'm not
sure about is what the problem is with carl9170, or how to convince it
to be more fault-tolerant. (Is this behavior an overreaction to the
noise level? Is it hanging while waiting for some event that may never
happen?) I'm afraid I'm not even sure how to diagnose the problem
further; wireless adapters are not familiar territory for me.

-Sean
