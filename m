Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:43219 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbbHUJod (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 05:44:33 -0400
Received: from tsrv.tls.msk.ru (tsrv.tls.msk.ru [192.168.177.2])
	by isrv.corpit.ru (Postfix) with ESMTP id 2008D41C67
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2015 12:35:24 +0300 (MSK)
Message-ID: <55D6F0DB.5050505@msgid.tls.msk.ru> (sfid-20150821_114437_353307_BC6FA2E1)
Date: Fri, 21 Aug 2015 12:35:23 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: linux-only "freshness" auth problem??
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

I'm facing quite an interesting issue here.

Hotel wifi, with psk auth. All devices works fine, including
various models of cell phones, various laptops.  But one laptop
does not work, the network refuses to authenticate, NetworkManager
re-asks for the password.  The same laptop, when rebooted into
windows, with the same password, connects to wifi network instantly.
Reboot into linux - and NetworkManager asks for the password again
(psk stored in /etc/NetworkManager/system-connections/<Netname> is
the right one).

Reboot the access point, and linux also assotiates instantly.  Now
everything works.

But after some time (within one day so far), after next attempt to
use this wifi network, linux again asks for a password endlessly.
Rebooting AP helps, as is rebooting this laptop into windows.  But
rebooting into linux does not help, the AP refuses to authenticate
linux.

There's another hotel nearby, they run another wifi network.  I
tried to use their network (our hotel staff know their password).
And the behavour is exactly the same -- only this my laptop, when
booted into linux, is not authenticated by the AP, this laptop
when booted into windows connects instantly, as are other devices
like cell phones or laptops.

So the thing is definitely this laptop.  However, I never had any
probs with its wifi support so far, it always worked fine before
this story.

So I really wonder what the problem is, what's the difference
between linux and windows for a "non-fresh" AP, why it refuses
to auth linux, and finally fix the problem so it wont appear
again... ;)

I'm running linux kernel 3.16 on debian jessie.  The NIC is this
one:

  03:00.0 Network controller:
   Intel Corporation Centrino Advanced-N 6235 (rev 24)

Here's how a typical auth attempt looks like:

Aug 21 11:31:49 x200la wpa_supplicant[1546]: wlan0: SME: Trying to authenticate with c0:4a:00:49:1b:f2 (SSID='Prada' freq=2437 MHz)
Aug 21 11:31:49 x200la kernel: wlan0: authenticate with c0:4a:00:49:1b:f2
Aug 21 11:31:49 x200la kernel: wlan0: send auth to c0:4a:00:49:1b:f2 (try 1/3)
Aug 21 11:31:49 x200la wpa_supplicant[1546]: wlan0: Trying to associate with c0:4a:00:49:1b:f2 (SSID='Prada' freq=2437 MHz)
Aug 21 11:31:49 x200la kernel: wlan0: authenticated
Aug 21 11:31:49 x200la kernel: wlan0: waiting for beacon from c0:4a:00:49:1b:f2
Aug 21 11:31:49 x200la NetworkManager[1337]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Aug 21 11:31:49 x200la NetworkManager[1337]: <info> (wlan0): supplicant interface state: authenticating -> associating
Aug 21 11:31:49 x200la wpa_supplicant[1546]: wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="Prada" auth_failures=1 duration=10 reason=CONN_FAILED
Aug 21 11:31:49 x200la NetworkManager[1337]: <info> (wlan0): supplicant interface state: associating -> disconnected
Aug 21 11:31:54 x200la NetworkManager[1337]: <info> (wlan0): supplicant interface state: disconnected -> scanning

Any hints please? :)

Thank you!

/mjt
