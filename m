Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:33921 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab2HIRIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 13:08:05 -0400
Received: from [72.40.65.195] (helo=192.168.1.10)
	by elasmtp-galgo.atl.sa.earthlink.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.67)
	(envelope-from <marco@tampabay.rr.com>)
	id 1SzW0H-0006uS-QQ
	for linux-wireless@vger.kernel.org; Thu, 09 Aug 2012 12:54:33 -0400
Date: Thu, 9 Aug 2012 12:54:34 -0400
From: Marco Fonseca <marco@tampabay.rr.com>
To: linux-wireless@vger.kernel.org
Subject: carl9170: Unintentional transmission in monitor mode?
Message-ID: <20120809165434.GA13409@192.168.1.10> (sfid-20120809_190810_334694_53BADD01)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

I've noticed unexpected transmissions from the AR9170 while in monitor mode
and using tcpdump (and sometimes without tcpdump running).  These
transmissions degrade (pretty significantly) performance of other STA/AP on
the channel (as seen by iperf going from 60mbit/s to almost nill).  As best I
can tell these transmissions never coalesces into an actual frame in the air
(at least not one I'm able to pick up with a second different adapter in
monitor mode).

Are there any known reasons/bugs on this?  Is there anyway to completely
silence the transmitter of the AR9170 while still allowing reception?




Some additional information that may give some context:
- This seems to happen over a wide range of releases of compat wireless I've
  tried, I've tested between compat wireless 2.6.39-rc6-1 and 2012-7-03,
  various drivers and firmware (the latest being driver 1.9.4 and firmware
  1.9.5).  I've also seen the problem across multiple AR9170 adapters, as well
  as different linux hosts.

- I've put a few printk's in the carl driver & stubbed out (somewhat blindly)
  some of the tx functions in wlan.c in the firmware to see if I could silence
  or get a clue on whats going on, with not much success.  The problem still
  occurred (No prink's told me the kernel wasn't actively generating any
  pkts).

- Seems like the transmissions only occur when monitoring 802.11n speeds.
  (That is if I manual configure the AP to 54mbit/s, I don't see the
  issue).  Happens in both 2.4 or 5ghz band.

- I was able to also observe this behavior with a single ping.  Only seemed to
  occur with larger ICMP pings (would occur with -s 2000 pings, but not a
  standard (56 byte) ping).

- Along with iperf degradation, I've verified transmissions with a spectrum
  analyzer.


Thank you,

Marco Fonseca
