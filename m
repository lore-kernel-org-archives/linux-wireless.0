Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4292 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbZGQVWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 17:22:24 -0400
Message-ID: <4A60E5EC.1080700@canonical.com>
Date: Fri, 17 Jul 2009 14:58:20 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Setting rfkill from user space
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Because the rfkill sysfs info moved around, I've been working on a
program for the Debian acpi-support package that can be used to perform
2 operations; 1) discover if there are any wireless devices powered on,
and 2) toggle the states of all wireless devices (at the same time).

git://kernel.ubuntu.com/rtg/rfkill

I'm a bit confused about what idx is in the event structure. Other then
ascending (though not monotonically), idx appears to have no real value
to user space. I see in the rfkill driver where its being assigned, and
it appears to be an rfkill instance number that describes a relationship
to a device. For example:

Here is the output before toggling and right after a boot:

rtg@xps1330:~$ ./rfkill
bluetooth 0 UNBLOCKED soft:0 hard:0
wlan 1 UNBLOCKED soft:0 hard:0
bluetooth 2 UNBLOCKED soft:0 hard:0
wlan 3 UNBLOCKED soft:0 hard:0
UNBLOCKED

After toggling to BLOCKED:

rtg@xps1330:~$ sudo ./rfkill 1
[sudo] password for rtg:
rtg@xps1330:~$ ./rfkill
wlan 1 SOFT_BLOCKED soft:1 hard:0
bluetooth 2 SOFT_BLOCKED soft:1 hard:0
wlan 3 HARD_BLOCKED soft:1 hard:1
BLOCKED

After toggling to UNBLOCKED:

rtg@xps1330:~$ sudo ./rfkill 0
rtg@xps1330:~$ ./rfkill
wlan 1 HARD_BLOCKED soft:0 hard:1
bluetooth 2 HARD_BLOCKED soft:0 hard:1
wlan 3 UNBLOCKED soft:0 hard:0
bluetooth 4 UNBLOCKED soft:0 hard:0
UNBLOCKED

This laptop only has one wlan and one bluetooth device. Why the extra
index values?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
