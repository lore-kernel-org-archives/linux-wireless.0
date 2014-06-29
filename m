Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64497 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaF2AT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 20:19:57 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so6621663wgg.5
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 17:19:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 28 Jun 2014 17:19:55 -0700
Message-ID: <CAH5Ym4iX=7TvPAajyb_PzrfsD7UmbsOYOvU9YqZk78zaDaQNGA@mail.gmail.com> (sfid-20140629_022036_969777_4033A7C4)
Subject: BUG: iwlwifi microcode errors on Intel 7260HMW
From: Sam Edwards <cfsworks@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I've been working for a week to track down the cause of this bug.
Sadly, I have no background in wireless development and no knowledge
of the Intel microcode format, so I've gotten stuck.

I'm trying to use an Intel 7260HMW with OpenWrt to act as an AP. I'm
using a recent snapshot ("Barrier Breaker") build of OpenWrt, on the
Linux 3.10.36 kernel. The iwlwifi driver is built from the Linux
driver backports package; a diff reveals that it is fully up-to-date
with the latest source in the upstream kernel repository.

When trying to run hostapd, my kernel log repeats output similar to
this: http://pastebin.com/1UuUuMMg
The problems are not limited to trying to use the device as an AP.
When trying to associate to an existing network, I am given similar
output: http://pastebin.com/qxwbdHyu

The wireless device is, however, capable of scanning for nearby APs,
but so far I have not been able to get it to do anything else.

I've been unable to get the non-backported (i.e. 3.10.36) version of
the driver to load correctly, and I cannot easily test this on the
latest kernel either. However, if I should try a different version,
please let me know.

Thanks,
Sam
