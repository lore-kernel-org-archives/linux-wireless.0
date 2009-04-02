Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:41318 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZDBFAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 01:00:23 -0400
Message-ID: <49D44635.80306@lwfinger.net> (sfid-20090402_070027_645519_62BB6F09)
Date: Wed, 01 Apr 2009 23:59:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: How does rfkill work?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I'm having trouble getting the radio LED to work on b43legacy. When the LED's
are registered, I get LED index 0 registered with names of "b43legacy-phy0::tx"
and "b43legacy-phy0::rx", and LED index 1 with a name as of
"b43legacy-phy0::radio". I placed printk's at the entrance to
b43legacy_led_brightness_set(), which is the callback routine. I see a number of
calls to modify LED index 0, which I assume are due to RX/TX activity, but only
a single call for LED index 1 when the LED's are still being registered. There
are no such calls generated when the radio switch is moved.

I don't see where/how a particular LED is attached to the rfkill event. Could
you point me to some code that does that?

Thanks,

Larry
