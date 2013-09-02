Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56941 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919Ab3IBU7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 16:59:18 -0400
Received: by mail-wi0-f179.google.com with SMTP id hq12so2197354wib.12
        for <linux-wireless@vger.kernel.org>; Mon, 02 Sep 2013 13:59:17 -0700 (PDT)
Message-ID: <5224FC22.5040006@gmail.com> (sfid-20130902_225931_123432_BC4F6D5A)
Date: Mon, 02 Sep 2013 22:59:14 +0200
From: Yorick Peterse <yorickpeterse@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Hilarious 11n performance with iwlwifi and Thinkpad T520s
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey folks,

So first of yes, the title could probably be considered "link bait" but
honestly I'm fed up with iwlwifi and 11n networks that I consider this
the most friendly subject that I can come up with.

Anyway, lets get to the problem. I'm currently using a Thinkpad T520
running Arch Linux with kernel version 3.10.10-1. The particular
wireless chipset of this laptop is a Centrino Wireless-N 1000 (Condor
Peak). Ever since day 1 of using this laptop/chipset I've been having
issues with 802.11n (in combinatio with the iwlwifi driver).

Either I couldn't connect to a network at all (e.g. with my previous
router) or performance would be hilariously slow up to the point where
even 11b would be faster. Now that I have a new router (Asus RT-N66U, I
can recommend it to those that want a decent router) I can at least
connect, sadly the performance of my laptop is still anything but
decent.

What happens is that I can connect and use 11n fine for a bit. However,
as time progresses the amount of excessive retries (as reported by
`iwconfig`) fills up up to a point where the bitrate plummets to 1MB/sec
and my log files start filling up with iwlwifi errors such as the one
seen here: http://git.io/7JLTLw (links to gist.github.com).

When this happens download speed also drops to around 1MB/sec (due to
the bitrate) and response times go up. Before Linux 3.10 (Linux 3.9 for
example) I could work around this issue by either reconnecting to the
network or reloading the driver. With Linux 3.10.10 however it seems
this doesn't do anything. In this particular log entry you can see me
reconnecting to the network on Sep 02 21:41:21 with the same errors
popping up moments later.

This particular problem isn't exactly new either, similar (or maybe even
the same) issues have been reported before:

* https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1034740
* https://bugzilla.redhat.com/show_bug.cgi?id=804259
* http://bugs.centos.org/view.php?id=6305

This would suggest to me that the issue is an actual driver issue
instead of being some race condition that only occurs on specific
hardware configurations.

The common "fix" for this problem is to disable 11n on driver level.
This isn't exactly a fix however, it's simply sticking your head in the
sand and ignoring it. I suppose that for a lot of people this is good
enough since their internet speeds don't require 11n. In my case however
I'm using a fibre internet connection and I'd like to actually be able
to use the full 10 MB/sec via the wifi connection (it's 2013 after all).

To cut a long story short, what I'd like to know is the following:

1. Is this a known issue and if so, when can we expect a fix?
2. What can I do to help out with this? Actually writing kernel code is
   way over my head but I'd love to help out by testing patches as much
   as my schedule permits.

Some extra hardware/software information in case it helps:

uname output:

    Linux tuxbook 3.10.10-1-ARCH #1 SMP PREEMPT Fri Aug 30 11:30:06 CEST
2013 x86_64 GNU/Linux

The operating system is Arch Linux 64bit. The network management
software used is Network manager 0.9.8.2-1 which uses wpa_supplicant
1.4-2 and dhcpcd 6.0.5-1 under the hood.

In total there are about 29 networks (mine included) in my area, these
operate on channels 1, 3, 4, 5, 6, 7, 8, 11 (some networks operate on
the same channel). My own network is the only one that runs on channel
5, changing channels doesn't have any affect on the performance in any
noticable way.

If there's any more info that I could/should provide I'd be happy to do
so.

Yorick Peterse
