Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59014 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbYGMMWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2008 08:22:55 -0400
Date: Sun, 13 Jul 2008 09:22:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Some questions about missing rfkill details
Message-ID: <20080713122247.GA6963@khazad-dum.debian.net> (sfid-20080713_142322_768802_8FAC085E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was a little burned out from rfkill work, and started looking at a certain
non-mac80211 wireless driver to see how it could be converted to use rfkill
(we already have many examples for mac80211).

The following doubts sprang to mind, I feel the answers to them should be
documented, but I am not sure I have the right answers, so I am asking the
wireless network experts ;-)

1. For wireless network devices, the rfkill class should have as its parent
   the main struct net_device for that wireless network device.  For
   platform device drivers, it should have the platform device as its
   parent.

   Correct? Incorrect?

2. We will probably benefit long-term from a guideline for naming the rfkill
   switches.  Currently it is supposed to be a system-wide name, but that's
   about all of it.
   
   Thus, what we have may not result on very user-friendly (or useful) names
   at all.

   It really needs a local part so that drivers that have more than one
   rfkill class attached to them (typically, multi-radio devices or platform
   devices) can differentiate them.  But that means names like "<platform
   device name>_bluetooth_sw", "<platform_device_name>_wwan_sw" for platform
   drivers, and something else for wireless network devices.

   Any ideas of what we should be using, that will actually be useful for
   userspace?
   
   Userspace IS supposed to be able to use sysfs to find out what the parent
   device is, regardless of the rfkill class name.  If it cannot, that
   pretty much would make sysfs useless for device configuration through
   classes.

   If we use the EEPROM MAC, should we document that userspace is to mostly
   ignore the name and use the sysfs hierarchy to tie switches to their
   parent devices?  And MACs can be changed, what should we do, then?

   Could we, instead of the MAC, use the main network interface name (and
   rename the rfkill class if that name changes? How?), appending to it an
   (optional?) small suffix for network devices with more than one
   transmitter?  What should we use as the suffix?

   IMHO, we should also write down if we are to use names like "Mango Bango
   Wireless Switch" or "mangobango_sw", etc.  I.e. a full naming guideline.

   I am not the right person to come up with answers and guidelines for the
   above, so I am asking for comments and help.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
