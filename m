Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx34.mail.ru ([94.100.176.48]:16540 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZG1PiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 11:38:07 -0400
Received: from [62.176.9.130] (port=32925 helo=[192.168.1.199])
	by mx34.mail.ru with asmtp
	id 1MVokg-000Pae-00
	for linux-wireless@vger.kernel.org; Tue, 28 Jul 2009 19:38:06 +0400
Subject: A station can't reconnect after it wakes up
From: Igor Perminov <igor.perminov@inbox.ru>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 28 Jul 2009 19:38:05 +0400
Message-Id: <1248795485.29068.144.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear colleagues,

I have an issue related to handling power-saving stations in mac80211
(AP mode) or may be to hostapd. A station can't reconnect after it wakes
up (see the link to the rt2x00 forum below, issue #4).

AP: Linux box with D-Link DWA-110 USB Wi-Fi stick (rt73usb kernel
driver), kernel 2.6.30 with some patches, hostapd 0.6.9.
Station: Toshiba G900 PDA under Windows Mobile 6.0.

The environment is described in details here:
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5486&start=10

Consider the following step-by-step:
1. A station authenticates and associates with the AP and exchanges
traffic.
2. The station indicates to the AP that it is going to sleep.
3. The station device goes to the stand-by mode (not only its wi-fi
card, but the device itself).
4. The station device wakes up and begins authentication with an
Authentication management frame.
This is the behavior of my PDA.

The problem is the mac80211 stack remembers that the station has gone to
sleep. So, the response frames from hostapd are buffered by mac80211.
The station indicates in the Authentication frame that it isn't sleeping
anymore. But the mac80211 stack analyzes sleep/wake transitions in
_data_ frames only, but not in management ones. See
ieee80211_rx_h_sta_process in net/mac80211/rx.c. A comment there notes:
"Ignore doze->wake transitions that are indicated by non-data frames,
the standard is unclear here".
As the result, the station never receives the authentication response
from the AP.

The wireless-testing kernel seems to have this problem too.

As a workaround I've added a code in hostapd, which forces the mac80211
stack to "forget" the station just after receiving an authentication
frame. After this change the station can reconnect successfully.

And may be it would be better to analyze not only data frames, but also
some of management ones in ieee80211_rx_h_sta_process?
What does the standard tell here?

Best regards,
Igor Perminov


