Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:27063 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZHaPtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 11:49:52 -0400
Received: by fg-out-1718.google.com with SMTP id 22so502621fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 08:49:53 -0700 (PDT)
Message-ID: <4A9BF11D.1060205@lwfinger.net>
Date: Mon, 31 Aug 2009 10:49:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tobias Schlemmer <keinstein_junior@gmx.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187b Problem with tx level
References: <h7eo7q$7ks$1@ger.gmane.org> <4A9B0479.209@lwfinger.net> <h7g6rd$dvb$1@ger.gmane.org>
In-Reply-To: <h7g6rd$dvb$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Schlemmer wrote:
> Hi,
> 
> thank you for your quick answer.
> 
> Larry Finger schrieb:
>> Tobias Schlemmer wrote:
>>> Interestingly iwconfig always reports TX power of 20dBm, regardless of
>>> the actual tx power, but always a TX rate of 1M. Setting the latter to a
>>> higher value results in packet loss.
>>
>> Where are you located? Your log says you are using the EU regulatory
>> domain; however, that is no longer valid. You should add a line like
>>
>> options cfg80211 ieee80211_regdom=XX
>>
>> to /etc/modprobe.conf.local. From your name, I would guess the XX
>> should be DE.
> 
> I guess, too. For some reason it is not corrected in some tutorials.
> 
>> It is likely that the 20 dBm is set by mac80211 as the maximum allowed
>> by your local regulations. That value is in fact correct for most
>> locations in the EU.
> 
> As far as I know, Germany has a maximum of 100mW, which should be 20dBm,
> if I'm right. This means the driver reports full power though the device
> actually seems to send with much less power. The power gets lost
> somewhere between this display and the antenna. Since there exists a
> working driver, I can hardly expect it on the hardware side.
> 
> I've attached the output of iwconfig for the two drivers. The
> proprietary works, the compat-wireless one even failed to authenticate
> (auth timeout) today. I don't know which tx power the proprietary driver
> uses. If you can tell me how to find out, I'll try that.
> 
> Some additional information: The automatic rate setting seems to work
> somehow. Last night it grow to 11M for a short time (reporting signal
> stregth of -3dBm).
> 
> Maybe, the tx power gets only reduced, but never increased. That's what
> the AP sees.
> 
>> My rtl8187b runs at a full 54 Mbs and operates at at least 15 m from
>> my AP. I don't run AP firmware that lets me see the signal strength
>> from the STA.
> 
> That dosn't surprise me. The archives don't talk about similar problems.

While you are still available, please provide the dmesg output for the
r8187 (vendor) driver beginning at the point that the USB device is
recognized. With rtl8187, it looks like:

[  346.940054] usb 1-1: new high speed USB device using ehci_hcd and
address 4
[  347.086851] usb 1-1: configuration #1 chosen from 1 choice
[  347.418280] cfg80211: Calling CRDA for country: EU
[  348.348579] phy0: Selected rate control algorithm 'minstrel'
[  348.349108] phy0: hwaddr e3c7a080, RTL8187BvE V0 + rtl8225z2
[  348.349131] usbcore: registered new interface driver rtl8187

There may be additional info following this.

In looking at my copy of the r8187 driver code, I see some branches
that may not be in our driver, but I need to see what ID info their
driver sees.

Have a good vacation.

Larry

