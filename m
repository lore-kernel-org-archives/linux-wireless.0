Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58748 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2EMEAG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 00:00:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1STPyV-0005kL-I9
	for linux-wireless@vger.kernel.org; Sun, 13 May 2012 06:00:03 +0200
Received: from pool-74-108-21-82.nycmny.fios.verizon.net ([74.108.21.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2012 06:00:03 +0200
Received: from Habstinat by pool-74-108-21-82.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2012 06:00:03 +0200
To: linux-wireless@vger.kernel.org
From: Harry <Habstinat@gmail.com>
Subject: carl9170 - Unable to see interface despite module being loaded
Date: Sun, 13 May 2012 03:59:01 +0000 (UTC)
Message-ID: <loom.20120513T054053-18@post.gmane.org> (sfid-20120513_060048_242543_79BD16B7)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I own a "Bus 001 Device 002: ID 0cf3:7015 Atheros Communications, Inc. TP-Link
TL-WN821N v3 802.11n [Atheros AR7010+AR9287]", according to lsusb. I'm
attempting to get the carl9170 (
http://linuxwireless.org/en/users/Drivers/carl9170 ) driver to work with it, as
should be possible according to h-node ( http://www.h-node.org/wifi/view/en/253/
) in Parabola GNU/Linux. 

Despite my valiant efforts however, I cannot seem to get a WiFi interface to
display via "ip link" (only my 'etho' and 'lo'). At this point, my dmesg tail
after rmmod'ing and modprobing carl9170 looked somewhat like this: (
http://www.pastie.org/pastes/3902525/text ). An anonymous peer managed to find a
forum thread ( https://bbs.archlinux.org/viewtopic.php?id=123851 ) that brought
up the issue of blacklisting. Prior to reading the thread, I had only
blacklisted arusb_lnx and ar9170usb, as per
https://wiki.archlinux.org/index.php/Wireless_Setup#carl9170 .
Post-thread-reading, I have created a larger blacklist file:
http://pastie.org/pastes/3903116/text . At this point, when subjected to similar
conditions as described above my dmesg tail looked a bit like this:
http://pastie.org/pastes/3903121/text . 

This was where circumstances got confusing, as according to the latter dmesg
tail, the device should be registered. But alas, after "ip link"ing again, only
eth0 and lo are to be found.

This problem originated on irc://irc.freenode.net/#parabola, so if reading
anonymized IRC logs is your thing you can go back to the roots of my dilemma
here: http://pastie.org/pastes/3903246/text

Much thanks is awarded to (s)he who can solve my misfortune.

