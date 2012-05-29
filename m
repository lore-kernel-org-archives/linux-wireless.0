Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49979 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2E2W5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:57:14 -0400
Message-ID: <4FC55443.4020003@candelatech.com> (sfid-20120530_005717_622117_3E439248)
Date: Tue, 29 May 2012 15:57:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Ath9k performance testing results (AR9380)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, so thanks for all the suggestions and numbers that
folks have posted in the 'wifi throughput tests' thread.

Short answer:  352Mbps download, 270Mbps upload (not concurrent).


We set up two systems, both with WPEA-127N NICs  (AR9380).

The Station machine is dual-core Atom, 3.3.7+ 32-bit kernel, with
Felix's recent optimizations and a bunch of other patches.

The AP is a core-2 DUO system running the same software.  The
AP is set up to route.

Open air connection.  Channel 149, HT-40.  I can post hostapd
and supplicant config files if anyone wants to see them.  AP
and STA machine are about 5 feet apart, turned so that antenna
face each other.  With antennas on positioned so that they are
away from each other, performance was much worse.

The STAtion is sending to/from a wired port to/from the
station interface, so it is sending to itself.

Using ~64k UDP frames, these systems can sustain about 352Mbps
of traffic received on station interface and sent from the wired port (through
the AP).  Our traffic generator cannot push 350Mbps to self when using
small-sized UDP frames on this hardware.

The traffic generator is our proprietary tool, since iperf can't easily
send to self, but I see no reason why iperf would be any slower if set up
properly with a third machine to act as the upstream iperf server.

When sending from STA to Wired, it maxes out at about 270Mbps.

I am not sure why there is such a big difference, but possibly
sending wifi is harder than receiving it, and the Atom processor
just can't keep up.

TCP is a lot slower than UDP..around 235Mbps download.  I haven't
tried tuning things yet..maybe window sizes need some stretching.

We'll do some more tests with our i7 machines when we get
a chance...

Thanks!
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

