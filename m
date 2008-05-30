Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:65318 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYE3Hlz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 03:41:55 -0400
Received: from mta5.sony.co.jp (mta5.Sony.CO.JP [137.153.71.6])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m4U7fqYl001327
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:41:52 +0900 (JST)
Received: from mta5.sony.co.jp (localhost [127.0.0.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4U7fqFA012737
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:41:52 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4U7fpx9012726
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:41:52 +0900 (JST)
Date: Fri, 30 May 2008 16:41:46 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] wireless: Add support for passing PMK to WEXT
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Message-Id: <20080530163019.4741.40F06B3A@sm.sony.co.jp> (sfid-20080530_094159_357049_487D1D2B)
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

With this patch set we would be able to:

  - define the standard way to pass the PMK to the driver
  - let user space programs figure out whether the driver will do 4-way
    handshakes
  - eliminate the use of private ioctls from the gelic driver

#1	Add support for passing PMK and capability flags to WEXT
#2	Use the new PMK interface in the gelic driver
#3	Deprecate the private ioctls in the gelic driver


#1 adds the flags to WEXT, #2 and #3 let the gelic driver conform.

This patch set is identical to my previous RFC post on Apr 25 in
functionality.

Best regards.

-- 
Masakazu Mokuno

