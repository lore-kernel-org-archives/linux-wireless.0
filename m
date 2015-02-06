Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from milliways.jots.org ([198.204.250.45]:42863 "EHLO
	milliways.jots.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbBFF5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 00:57:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 06 Feb 2015 00:57:01 -0500
From: Ken D'Ambrosio <ken@jots.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@gmail.com>
Subject: Re: rtl8192ee (Thinkpad T440s)
In-Reply-To: <54D430E1.6030904@lwfinger.net>
References: <10a90ab7a6c186362f339481b531832f@webmail.jots.org>
 <54D00FA4.2060907@lwfinger.net>
 <8f26bf9461a88199ef8d8c86f7ee98f9@webmail.jots.org>
 <54D430E1.6030904@lwfinger.net>
Message-ID: <de7f2cdbf497b402a9083ee5748cad3c@webmail.jots.org> (sfid-20150206_065712_465311_32B6C92F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-02-05 22:11, Larry Finger wrote:
> On 02/05/2015 12:56 AM, Ken D'Ambrosio wrote:
> 
> Did the update to the troy branch of the rtlwifi_new repo fix the 
> problem?

Sadly, no.  Exact same errors.  So I looked at your previous e-mail, 
which I've pasted (and commented about), below:

> Do any ACPI warning messages appear in the early boot log?
> I found some mention of a module named thinkpad_acpi. Is it loaded?

There's a bunch of ACPI stuff, some of which seems related:

[    8.548934] thinkpad_acpi: Unsupported brightness interface, please 
contact ibm-acpi-devel@lists.sourceforge.net
[    8.549028] thinkpad_acpi: radio switch found; radios are enabled
[    8.549135] thinkpad_acpi: This ThinkPad has standard ACPI backlight 
brightness control, supported by the ACPI video driver
[    8.549137] thinkpad_acpi: Disabling thinkpad-acpi brightness events 
by default...
[    8.550374] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio 
is unblocked
[    8.551069] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is 
unblocked

The lack of an "rfkill switch" for WiFi might be disconcerting at first, 
until you read the corresponding kernel doc, 
/usr/src/linux/Documentation/laptops/thinkpad-acpi.txt:
0x1005  0x04    FN+F5           Radio.  Enables/disables
                                 the internal Bluetooth hardware
                                 and W-WAN card if left in control
                                 of the firmware.  Does not affect
                                 the WLAN card.
                                 Should be used to turn on/off all
                                 radios (Bluetooth+W-WAN+WLAN),
                                 really.
Additionally:
         hotkey_radio_sw:
                 If the ThinkPad has a hardware radio switch, this
                 attribute will read 0 if the switch is in the "radios
                 disabled" position, and 1 if the switch is in the
                 "radios enabled" position.

A quick visit to /sys/devices/platform/thinkpad_acpi/hotkey_radio_sw 
shows it with a value of "1", so, as far as I can tell, ACPI is not 
blocking the WiFi radio.

>  Sometimes this can be caused by some state left by Windows. Do you 
> dual boot?

Perish the thought.  While I haven't booted Windows, neither have I 
blown away the partition; if you'd like me to boot into it and 
initialize the card, I'd be willing to give that a try.

Lastly, however, is something weird that makes me think that the extreme 
step of using Windows may not be required: the USB WiFi I use because my 
internal WiFi isn't working is an RTL8188SU.  If I leave both of them in 
when I initialize, SOMETIMES I can get the 8192EE to work -- even after 
I remove the 8188SU.  But I haven't once gotten the 8192EE to work 
without the 8188SU also inserted.  And I can't reproduce this 
functionality reliably.

-Ken
