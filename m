Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms4.Sony.CO.JP ([211.125.136.198]:55465 "EHLO ms4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014AbYDYEyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 00:54:10 -0400
Received: from mta8.sony.co.jp (mta8.Sony.CO.JP [137.153.71.15])
 by ms4.sony.co.jp (R8/Sony) with ESMTP id m3P4s01s002062
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 13:54:00 +0900 (JST)
Received: from mta8.sony.co.jp (localhost [127.0.0.1])
 by mta8.sony.co.jp (R8/Sony) with ESMTP id m3P4s2CO010764
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 13:54:02 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta8.sony.co.jp (R8/Sony) with ESMTP id m3P4s2hO010761
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 13:54:02 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.4.141.32]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id m3P4s1P15978 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 13:54:01 +0900 (JST)
Received: from [43.4.146.40] (bluenote.sm.sony.co.jp [43.4.146.40])
	by imail.sm.sony.co.jp (8.12.11/3.7W) with ESMTP id m3P4s0sa005115
	for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 13:54:00 +0900 (JST)
Date: Fri, 25 Apr 2008 13:51:59 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] RFC: Add support for passing PMK to WEXT
Message-Id: <20080424204950.03DD.40F06B3A@sm.sony.co.jp> (sfid-20080425_065439_493690_DC304A3E)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

I'd like to add support for passing PMK and capability flags to WEXT for
the drivers which want to do 4-way handshake in the driver/firmware.

Prior to 2.6.25, none of the mainlined wireless drivers had been designed
to do 4-way handshakes in the driver/firmware, thus WEXT does not define
the way to do that. 

The PS3 wireless device is such kind of device.  The current gelic
driver included in 2.6.25 uses private WEXT ioctls to get the PSK
because of the lack of a standard way in WEXT.

With this patch we would be able to:

  - define the standard way to pass the PMK to the driver
  - let user space programs figure out whether the driver will do 4-way
    handshakes
  - eliminate the use of private ioctls from the gelic driver

#1	Add support for passing PMK and capability flags to WEXT
#2	Use the new PMK interface in the gelic driver
#3	Deprecate the private ioctls in the gelic driver


#1 adds the flags to WEXT, #2 and #3 let the gelic driver conform.

Please review!

-- 
Masakazu Mokuno

