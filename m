Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51182 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1AFUHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 15:07:53 -0500
Received: by wwa36 with SMTP id 36so17785234wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 12:07:52 -0800 (PST)
Message-ID: <4D262109.20504@lwfinger.net>
Date: Thu, 06 Jan 2011 14:07:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Odd behavior of ssb, b43, b43legacy, and b44
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

On one of my boxes, I have installed two PCI-format BCM43xx cards for testing.
One is a BCM4306 Rev. 3, which uses b43. The other is a BCM4303, which uses
b43legacy. The output of lspci -nn for these devices is

01:09.0 Network controller [0280]: Broadcom Corporation BCM4306 802.11b/g
Wireless LAN Controller [14e4:4320] (rev 03)
01:0a.0 Network controller [0280]: Broadcom Corporation BCM4303 802.11b Wireless
LAN Controller [14e4:4301] (rev 02)

Upon booting, I noticed the following messages in the log:

 b44: b44.c:v2.0
 b44: Invalid MAC address found in EEPROM
 b44 ssb1:1: Problem fetching invariants of chip, aborting

 b44: probe of ssb1:1 failed with error -22

As this box does not have a b44 installed, I wondered why this was happening.
When I unloaded all the drivers and used modprobe to load ssb, I found that b43,
b43legacy and b44 were all loaded. The console output is

finger@pam:~> lsmod | grep b4             <== none loaded
finger@pam:~> sudo modprobe -v ssb        <== load ssb
insmod /lib/modules/2.6.37-wl+/kernel/drivers/ssb/ssb.ko

The above looks normal, but look at what is now resident!

finger@pam:~> lsmod | grep b4
b43legacy             115302  0
b44                    28767  0
b43                   174321  0
ssb                    38157  3 b43legacy,b44,b43
mac80211              266240  2 b43legacy,b43
cfg80211              161930  3 b43legacy,b43,mac80211

Any idea why loading ssb should silently load b43legacy AND b44? Any ideas on
where to look?

Thanks,

Larry
