Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44295 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2E3DXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 23:23:16 -0400
Received: by pbbrp8 with SMTP id rp8so6837180pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 20:23:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 May 2012 23:23:15 -0400
Message-ID: <CA+7oygf50aro8VrHekWFJvSb3hhOsZUP9ybUeUE1WaYzx2MNHA@mail.gmail.com> (sfid-20120530_052319_601816_5516D5CF)
Subject: convinced bug in RSSI reporting for AR9280/ath9k_htc/htc_7010.fw
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org,
	Sujith Manoharan <m.sujith@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Long story short:  I am convinced that the AR9280, ath9k_htc, or
htc_7010.hw firmware always reports the RSSI value of the access point
in all packets, and not the actual transmitter of the packet (yes,
weird).

I posted on the list a while ago about how the RSSI reporting by the
AR9280 seemed to be incorrect.
http://www.spinics.net/lists/linux-wireless/index.html#90423

Well, I did another test and I'm convinced there is a bug in the RSSI
reporting for the AR9280.

Setup:  I place my iPhone on top of my laptop.  The iPhone is the
transmitter and I monitoring RSSI values of packets  _from the iPhone
only_  at an AR9280 (USB) and BCM4322 (internal to MacBook Air).  I
keep the distance of the iPhone (transmitter) to these monitors the
same.  The iPhone always sit on top of the laptop with the same
distance to both:

http://www.flickr.com/photos/gnychis/7299338578/in/photostream/lightbox/

Now, what I do is hold the laptop and walk towards my access point.
The signal strength from the iPhone should *stay the same.*  The
distance of the iPhone to the monitors doesn't change, it's
independent of how close I am to my access point.

However, the results show that the AR9280 signal strength grows as I
walk closer to the AP whereas the BCM4322 acts as expected and stays
stable (again, distance to transmitter doesn't change):

http://www.flickr.com/photos/gnychis/7299342404/lightbox/

I am 100% certain I am only taking the RSSI values reported for
packets from my iPhone (wlan.sa==my:iphone:mac:addr).  I literally use
the exact same tshark command line for the BCM4322 and AR9280.  I have
quadruple checked this.

This would explain why in my other thread that the RSSI values for
beacons for my AP acted as expected and all other RSSI values did not
follow as expected.

I would greatly appreciate it if someone could chime in here.  Sujith?

Thanks!
George
