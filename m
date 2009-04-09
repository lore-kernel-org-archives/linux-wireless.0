Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:51279 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499AbZDIViX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 17:38:23 -0400
Message-ID: <49DE6ABE.30207@lwfinger.net> (sfid-20090409_233826_906941_B29E1A2A)
Date: Thu, 09 Apr 2009 16:38:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: b43 rfkill LED broken in 2.6.30-rc1 from wireless-testing
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Boy is the rfkill subsystem fragile.

After all our debugging of the control of the b43 LED with the rfkill switch, it
is broken again with 2.6.30-rc1.

I put a test print at the start of b43_led_brightness_set(). It gets called lots
of times for the TX/RX LED (which I do not have), but only gets called for the
radio LED when the driver is loaded or unloaded. Changing the rfkill switch
causes the "radio hardware status" messages to be output, but nothing happens
with the LED.

Now, led_trigger_event() once again is only called indirectly through
rfkill_led_trigger() from rfkill_led_trigger_activate(), but
rfkill_led_trigger() is never called. I have no idea who is calling
b43_led_brightness at start-up/shut-down. It must be some part of the LED system.

Some things are working. The contents of /sys/class/rfkill/rfkill3/state change
from 0 to 1 when the switch is turned on; however, I have not been able to
locate what code is doing the change. Routine rfkill_uevent() is never entered.

Larry
