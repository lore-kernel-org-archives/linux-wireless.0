Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:54927 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYDERoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 13:44:54 -0400
Received: by fg-out-1718.google.com with SMTP id l27so611380fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 05 Apr 2008 10:44:53 -0700 (PDT)
To: Bas Hulsken <bhulsken@hotmail.com>
Subject: Re: hostapd hangs on rt2500pci, leaving the nic in an unstable state
Date: Sat, 5 Apr 2008 19:46:23 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1207412527.6965.21.camel@Bas>
In-Reply-To: <1207412527.6965.21.camel@Bas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804051946.24100.IvDoorn@gmail.com> (sfid-20080405_184457_341275_89E6AA00)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> After hostapd outputs: 
> WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKCALCNEGOTIATING2
> WPA: 00:1b:77:a4:db:26 WPA_PTK entering state PTKINITNEGOTIATING
> it hangs, and wlan1 has received exactly one frame from the
> laptop (there's a message showing up in the logs at this time,
> complaining that wlan1 can't find any IPv6 routers). No further frames
> are sent from hostapd, although beacon frames are still being sent, and
> the interface still receives frames as well. The last frame rt2500pci
> receives, is the EAPOL key from the laptop. Only ctrl-c can kill
> hostapd, and after that the driver is in an unusable, and unstable
> state, even unloading rt2500pci, does not help, and eventually the
> entire system will become unstable, in particular under high I/O loads.
> After some time, a message shows up that the IRQ for the rt2500pci is
> being disabled ( ACPI: PCI interrupt for device 0000:05:01.0 disabled).
> If after that, I get a lot of I/O activity on devices sharing the same
> pci interrupt ( like recording some TV with an ivtv card) then a lot of
> shit happens, ivtv gives time outs, harddrive controllers give I/O
> errors, etc. As I've mentioned, this also happens after I unload+reload
> the rt2500pci module. So, apparently the hardware is left in a bad state
> after hostapd locks up.

This is all very strange behavior, I don't know what can cause the
ACPI to disable an interrupt for the device, but what is interesting to
see is that the BSSID in the register seems to have been cleared....

Could you create a debugfs dump of the time just before it breaks?
Because it is very odd to see the BSSID to be suddenly cleared, currently
is seems to occur with some people in managed mode as well and so
far I haven't been able to trace it.
Although now that it occurs in master mode as well it becomes
more worrying since mac80211 doesn't control the BSSID in that case
(rt2x00 just grabs the MAC address). So if this seems reproducable there
might be some sort of hardware register reset occuring that messes
things up badly.. :S

Ivo
