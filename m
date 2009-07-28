Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx44.mail.ru ([94.100.176.58]:54251 "EHLO mx44.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbZG1M46 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 08:56:58 -0400
Received: from mx74.mail.ru (mx74.mail.ru [94.100.176.89])
	by mx44.mail.ru (mPOP.Fallback_MX) with ESMTP id F12D2266CD4
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 16:37:17 +0400 (MSD)
Received: from [62.176.9.130] (port=55064 helo=[192.168.1.199])
	by mx74.mail.ru with asmtp
	id 1MVlvB-00067s-00
	for linux-wireless@vger.kernel.org; Tue, 28 Jul 2009 16:36:45 +0400
Subject: rt2x00: rt73usb doesn't receive PS Poll frames in the AP mode
From: Igor Perminov <igor.perminov@inbox.ru>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 28 Jul 2009 16:36:43 +0400
Message-Id: <1248784603.29068.44.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear colleagues,

I've discovered that a rt73 usb wi-fi stick in the AP mode doesn't
receive PS Poll frames from a station. The station sends a PS Poll
frame, but the mac80211 stack doesn't see it.
More details can be found here:
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5486&start=10,
issue #1.

I've found that the FIF_CONTROL flag isn't passed to the rt2x00's
configure_filter function (namely rt2x00mac_configure_filter) by the
mac80211 stack even if the device is configured as an access point.
So, the hardware is configured by the driver to filter out control
frames according to the flags given.

And here is my question: what would be the correct behaviour?
A) The mac80211 stack should pass the FIF_CONTROL flag to the driver
when the device is configured in the AP mode.
B) The driver should configure the hardware to receive PS Poll frames by
itself when the device is configured in the AP mode, even if the
FIF_CONTROL flag isn't passed by the mac80211 stack.

Best regards,
Igor Perminov


