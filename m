Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59035 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878AbYLGX3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 18:29:08 -0500
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id E41BA1CF618
	for <linux-wireless@vger.kernel.org>; Sun,  7 Dec 2008 18:29:06 -0500 (EST)
Message-Id: <1228692546.8826.1288759933@webmail.messagingengine.com> (sfid-20081208_002919_244971_30E436F9)
From: "Dan E" <trg_info@mailhaven.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Subject: Userspace tools: Roadmap?
Date: Sun, 07 Dec 2008 18:29:06 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looking at some of the Linux Wireless website pages it appears as though
"iw" is meant to be the successor to the older pre-mac80211 userspace
tools.  In that category we have ifconfig, iproute2, iwconfig and
iwpriv.  For an AP there's also hostapd and wpa_supplicant.  Probably
some others I've missed, not to mention Network Manager.  I can see how
configuration and setup wouldn't necessarily be limited to "iw" using
nl/cfg80211, but in the short term is that the tool of choice for
migrating the functionality of the old tools to the new mac80211
infrastructure?

Here's my situation: I'm developing a driver for an old 80211 b/g
chipset.  It's ancient by modern standards.  It operates only in the 2.4
GHz band, it doesn't have any mesh capabilities, it has a "broken"
EEPROM, it supports only single RX and TX queues, and it's an ASIC
design that doesn't use firmware.  It has no "turbo" modes.  The company
that manufactured it went bust in 2005.  It was used in a wide array of
soho routers and access points several years ago but never caught on as
a very popular" chip.

I want to write, from scratch, a mac80211 driver for this chipset using
information I've gained over the last few years from specs and reverse
engineering the binary-only driver that shipped with it (with a Linux
2.4.18 kernel).  I have the framework of the driver set up and working. 
It loads, detects and initializes the hardware on the PCI bus, reads the
hardware MAC address, sets up the TX and RX queues, and registers with
the mac80211 stack.  I see devices wmaster0 and wlan0 when I modprobe
the driver.  So far, so good.  Eventually I want to support AP and
MONITOR modes, too, but STA mode seems to be in a more advanced state
right now so I am starting with that.

Userspace tools.  I want to proceed as if Wireless Extensions never
existed.  Is that even possible?  For instance, how do I command a
channel change from userspace?  iw doesn't have that.  Should it?  Or do
I need to drop back to iwconfig?  Is iw the preferred command-line way
to do everything the old tools did, but using nl/cfg80211 instead of
ioctls?  When we get to AP mode, will hostapd be re-written to speak
nl/cfg80211, or is a new config tool needed?  The same questions apply
to wpa_supplicant.

In general, what's the way forward for new userspace tools?  nl80211 and
cfg80211 are a given, I understand that, but what's the recommended
approach from the perspective of a developer looking to make a clean
break from Wireless Extensions with a new cleanroom driver written from
scratch with no pre-existing baggage to worry about?  Start making
additions to iw's capabilities?  Adapt some other existing tool to use
nl/cfg80211, or write something completely new?

I've been following linux wireless developments since the big Summit of
'06, but this is my first attempt at jumping in.  Getting a handle on
the "big picture view" of what everything is going to look like when
mac80211 is a mature implementation is a bit difficult.  I've noticed a
lot of recent changes to the Linux Wireless website.  All good stuff but
not very comprehensive in scope.  I realize nobody likes to write
documentation :)

If somone could answer only 1 question (okay, it's a two-parter) the one
I would most like answered is this:  How does one, from userspace, ask
the driver to switch to a specific channel, and what callback(s) from
mac80211 should my driver expect to receive as a result?  I think my
driver can handle the task of changing the channel on the hardware and
manage all the housekeeping that goes along with that; I just don't get
how to issue that command from userspace.

TIA for any help, advice, pointers, flames, etc.

--
Dan

-- 
http://www.fastmail.fm - Send your email first class

