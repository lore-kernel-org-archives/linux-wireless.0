Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail51.messagelabs.com ([216.82.241.99]:40214 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0FCX1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 19:27:46 -0400
From: "Gordon, Charles" <Charles.Gordon@digi.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 3 Jun 2010 18:27:38 -0500
Subject: Power save mode in 2.6.32-22
Message-ID: <8DCC153EAFE67A4B990A840E829F704B017C658D620C@mtk-sms-exch01.digi.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to get power save mode to work in a wireless driver on Linux
2.6.32.  What I'm seeing is that the wireless stack is sending null-data
frames with the power management bit on or off from time to time.  It does
this regardless of whether flags IEEE80211_HW_SUPPORTS_PS and
IEEE80211_HW_SUPPORTS_DYNAMIC_PS are set.  This is not how I would expect
it to work.  If IEEE80211_HW_SUPPORTS_PS is set, I would expect it to let
the driver handle the sending of these frames.  If IEEE80211_HW_SUPPORTS_PS
is not set, then this would indicate that the driver cannot power down, in
which case I still would not expect the stack to be sending these frames. 
The documentation for power save is very thin and it seems the
implementation has changed recently. 

Why is the stack sending these frames when the driver says the H/W does not
support powering down? 

Why is the stack sending these frames when it would seem that the driver
could better handle them? 

The reason why I think the driver can better handle them is that if the
stack sends a frame with the power-mgmt bit set, and then tells the driver
to power down, there will be a race condition where the interface could
receive a frame before the hardware is powered down.  The AP may send such
a frame after it receives the null-data frame because some could be in a
H/W queue.  I have seen this happen.  In this case, the interface H/W on
the station will send an ACK and since the H/W does not know that it is
about to be powered down, that ACK will be sent with the power-mgmt bit
clear, which may confuse the access point.  In short, sending these frames
is something the driver should do since it will know that it should adjust
the H/W so that any ACKs or other control frames will be sent with the
power mgmt bit correctly set until such time as the H/W is actually powered
down.

Anyway, that's my take on it.  As I said, the documentation on power save
doesn't say much and it is not clear to me how it is suppose to work. 
Perhaps someone can provide an explanation.

Thanks for any help you can provide.

