Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42759 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab2FGTbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 15:31:22 -0400
Received: by dady13 with SMTP id y13so1303518dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 12:31:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206071518.21171.chunkeey@googlemail.com>
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com>
	<201206071518.21171.chunkeey@googlemail.com>
Date: Thu, 7 Jun 2012 13:31:21 -0600
Message-ID: <CAFR4AqZvhnB3kD_t+817zvEiw16QvNsvMgTwbFxAiogYcSCXEg@mail.gmail.com> (sfid-20120607_213138_842806_EEA16E38)
Subject: Re: carl9170 issue
From: Sean Patrick Santos <quantheory@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the quick response, Christian,

>> Plus, I'm somewhat stuck with the situation,
>> since I don't have much control over how things are arranged in this
>> space, and because the other adapter I have on hand is even worse off,
>> both in terms of hardware and drivers.
> Fair enough. But what's the other adapter?

It's a Belkin N150 (http://www.wikidevi.com/wiki/Belkin_F9L1001),
which didn't seem to work for more that 30 seconds at a time, and had
low throughput even then. The driver may have improved, or be easier
to fix, since the last time I tried it, but the actual antenna on the
device is not suitable for this environment and so I haven't been
motivated to make it work. The "official" driver on Windows gave
halfway serviceable performance, emphasis firmly on the "halfway". I
may get around to re-testing/troubleshooting it if I want to use it
elsewhere or if I'm bored some time, but that's really a different
question.

> Your problems sound somewhat familiar to
> "Re: carl9170 driver - network connection breaks"
> <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/88223>
>
> So far no-one has been able to bisect the bug (last good was 3.1, so
> to breakage must have occurred between 3.1 and 3.2). I would have
> looked into it long ago, but I can't reproduce.

I may see if I can bisect it, since evidently I can reproduce the bug
quite easily. At the least I can find out if this really is the same
problem and not present in kernel 3.1. I'll let you know if I find
anything interesting.

> PS: If your kernel was compiled with CONFIG_MAC80211_DEBUGFS you can
> "restart" BA/aggregation sessions by
> echo "tx stop 0" > /sys/kernel/debug/ieee80211/phyX/netdev:wlanXY/stations/AP-MAC/agg_status
> echo "rx stop 0" > /sys/kernel/debug/ieee80211/phyX/netdev:wlanXY/stations/AP-MAC/agg_status
> alternatively: you can disable ht by loading the module with 'noht=1' parameter

Thanks for the suggestion; I'll try this. I should note that, although
I can't change the physical locations of anything here (at least for
another month or two), I do manage both the machine and the wireless
router.
