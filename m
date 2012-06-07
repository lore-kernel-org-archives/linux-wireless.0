Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35361 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759881Ab2FGNS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:18:27 -0400
Received: by bkcji2 with SMTP id ji2so550310bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 06:18:25 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sean Patrick Santos <quantheory@gmail.com>
Subject: Re: carl9170 issue
Date: Thu, 7 Jun 2012 15:18:20 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com>
In-Reply-To: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206071518.21171.chunkeey@googlemail.com> (sfid-20120607_151832_084430_C6021478)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 June 2012 08:53:32 Sean Patrick Santos wrote:
> The first "problem", which is actually mild enough that I wouldn't
> bother writing in about it if it was the only issue, is that I get a
> lot of messages like these:
> 
> [13215.559590] ieee80211 phy2: channel change: 2432 -> 2437 failed (2).
> [13215.844041] ieee80211 phy2: channel change: -1 -> 2437 failed (2).
> [13215.844044] usb 3-1.2: restart device (7)
> [13216.983593] usb 3-1.2: device restarted successfully.
> [13216.988414] ieee80211 phy2: Hardware restart was requested
> 
> Also occasional blocks like these:
> 
> [13548.136457] ieee80211 phy2: invalid plcp cck rate (0).
> [13597.224429] ieee80211 phy2: invalid plcp cck rate (0).
> [13601.512838] ieee80211 phy2: invalid plcp cck rate (0).
> 
> I gather from a previous post on this mailing list that these are
> signs of interference in the area, which doesn't surprise me. I have a
> draft-N router that can only use the 2.4Ghz range, and there are three
> cordless phones, a wall, a microwave, and several other wireless
> devices between the adapter and the router. This doesn't bother me
> that much, because when the above messages are being printed
> performance is usually still OK, and when a restart does happen the
> device recovers rapidly. Plus, I'm somewhat stuck with the situation,
> since I don't have much control over how things are arranged in this
> space, and because the other adapter I have on hand is even worse off,
> both in terms of hardware and drivers.
Fair enough. But what's the other adapter?
 
> The second, more troubling problem is that I seem to get a "silent"
> failure (at least I can't find any errors) if I start a large download
> or set of downloads that take more than 10 seconds to a minute (in
> particular, trying to clone large directories using mercurial is
> impossible, because it will always trigger this problem, though for
> some reason git and subversion work most, but not all, of the time).
> What I mean by "failure" is that one of these two things will happen:
> 
> 1. The device will simply fail to receive anything (or trickle out to
> a rate of 500 bytes/min), at which point it will remain in that state
> for hours, occasionally registering minuscule amounts of activity,
> unless it is dis/reconnected to the wireless network (toggling power
> to the device or reloading the module also work, but do neither better
> nor worse than just reassociating). Upon reconnecting it immediately
> works fine, as long as I don't trigger the same problem again.
> 
> 2. Less often, the device will fail as above, but then suddenly start
> working again another minute or so later, allowing the process that
> had been overworking it (mercurial, wget, firefox, whatever) to
> continue what it was doing for another 10-50 seconds, at which point
> the connection trickles out again. This cycle keeps happening until
> the process either completes successfully, errors and dies, hangs, or
> is killed, at which point everything seems fine again. (Killing the
> process does not solve the problem, it just prevents the same process
> from causing the problem *again* in the event that the device
> spontaneously recovers within a minute or two).
> 
> I know that it's physically possible to get a stable connection here,
> because the Windows installation on the same machine can almost always
> get fairly good speeds with the same device in the same place on the
> same network at the same time of day (~25Mbps, lose connection maybe
> once per 40 hours of use). I also know this because I can always fix
> the problem manually on Linux by reconnecting the device. What I'm not
> sure about is what the problem is with carl9170, or how to convince it
> to be more fault-tolerant. (Is this behavior an overreaction to the
> noise level? Is it hanging while waiting for some event that may never
> happen?) I'm afraid I'm not even sure how to diagnose the problem
> further; wireless adapters are not familiar territory for me.
Thanks for your extensive report on this.

Your problems sound somewhat familiar to
"Re: carl9170 driver - network connection breaks"
<http://permalink.gmane.org/gmane.linux.kernel.wireless.general/88223>

So far no-one has been able to bisect the bug (last good was 3.1, so
to breakage must have occurred between 3.1 and 3.2). I would have
looked into it long ago, but I can't reproduce.

Regards,
	Christian 

PS: If your kernel was compiled with CONFIG_MAC80211_DEBUGFS you can
"restart" BA/aggregation sessions by
echo "tx stop 0" > /sys/kernel/debug/ieee80211/phyX/netdev:wlanXY/stations/AP-MAC/agg_status
echo "rx stop 0" > /sys/kernel/debug/ieee80211/phyX/netdev:wlanXY/stations/AP-MAC/agg_status
alternatively: you can disable ht by loading the module with 'noht=1' parameter
