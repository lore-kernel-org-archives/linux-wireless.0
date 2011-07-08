Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:40804 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1GHSui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 14:50:38 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
	by out02.mta.xmission.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <bdeakin@cardaccess-inc.com>)
	id 1QfG8L-0000A2-B4
	for linux-wireless@vger.kernel.org; Fri, 08 Jul 2011 12:50:37 -0600
Received: from dev.cardaccess-inc.com ([64.55.41.84] helo=[172.22.0.57])
	by in01.mta.xmission.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <bdeakin@cardaccess-inc.com>)
	id 1QfG8K-0007tt-Rc
	for linux-wireless@vger.kernel.org; Fri, 08 Jul 2011 12:50:37 -0600
From: Brandt Deakin <bdeakin@cardaccess-inc.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 12:50:34 -0600
Message-ID: <1310151034.2152.8.camel@bdeakin-x200> (sfid-20110708_205041_712234_50B0167C)
Mime-Version: 1.0
Subject: CARL9170/hostapd startup failures
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm attempting to use carl9170 in AP mode and I'm seeing some
interesting errors.  When calling hostapd to initialize the AP, 10-50%
of the attempts will be unsuccessful and report the following:


Could not set interface wlan0 flags: Connection ieee80211 phy1: lost 7
command responses/traps! w:9 g:0
usb 1-1: restart device (8)
timed out
nl80211: Could not set interface 'wlan0' UP
nl80211 driver initialization failed.
rmdir[ctrl_interface]: No such file or directory
usb 1-1: firmware upload failed (-110).
usb 1-1: Failed to restart device  (-110).
usb 1-1: reset high speed USB device number 2 using ehci-omap
usb 1-1: reset high speed USB device number 2 using ehci-omap
usb 1-1: driver   API: 1.9.2 2011-01-22 [1-1]
usb 1-1: firmware API: 1.9.2 2010-12-25
usb 1-1: Atheros AR9170 is registered as 'phy2'

I'm seeing this error on the Beagleboard xM (Ubuntu 11.04 2.6.38) as
well as on a Lenovo x200 PC (Ubuntu 11.04 2.6.38).  I've reproduced it
with 2.6.39 on the Beagleboard (not xM) as well.  When initializing the
normal client mode, I've never seen a failure to "upload" the firmware
like this.  It seems to be particular to the AP mode.  Suggestions for
resolution are appreciated.  I'm going to open up the carl9170 firmware
source and start trying to determine a possible cause there.

Thanks,
Brandt


-- 
Brandt Deakin
Card Access, Inc.
11778 S. Election Rd. Ste 260
Salt Lake City, UT 84020
801-748-4900 x23
801-748-4901 fax
bdeakin@cardaccess-inc.com
www.cardaccess-inc.com


