Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49594 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2LNOAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 09:00:44 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1952082eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 06:00:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Richard =?utf-8?q?R=C3=B6jfors?= <richard.rojfors@gmail.com>
Subject: Re: rtl8192cu in AP mode.
Date: Fri, 14 Dec 2012 15:00:16 +0100
Cc: linux-wireless@vger.kernel.org
References: <1355355956.2744.26.camel@asus> <201212131930.21029.chunkeey@googlemail.com> <1355476107.10239.55.camel@rorics.office.pelagicore.net>
In-Reply-To: <1355476107.10239.55.camel@rorics.office.pelagicore.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212141500.17643.chunkeey@googlemail.com> (sfid-20121214_150047_897392_8F985F1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 December 2012 10:08:27 Richard Röjfors wrote:
> On Thu, 2012-12-13 at 19:30 +0100, Christian Lamparter wrote:
> > On Thursday, December 13, 2012 12:45:56 AM Richard Röjfors wrote:
> > > I've been playing with an rtl8192 the last days, I want it to act as an
> > > access point. It's connected to an ARM9 box.
> > > 
> > > I'm using the latest compat-wireless, with some additional patches for
> > > beacon support.
> > > 
> > > My hostapd conf looks like this:
> > > interface=wlan0
> > > ssid=Test
> > > driver=nl80211
> > > hw_mode=b
> > > channel=6
> > > dtim_period=1
> > > 
> > > It almost works. Running hostapd and the networks shows up for my other
> > > machine, which can connect to the network.
> > > 
> > > I also get dhcp-requests through and corresponding dhcp responses. But
> > > then the oddness starts. ARP requests sent from the client is received
> > > on the AP side, the IP stack returns an ARP response, and I see it
> > > beeing sent by _rtl_submit_tx_urb and usb_submit_urb returns 0. But
> > > nothing is received on the other end.
> > > Sometimes, very rarely a response can get through, maybe 1 of 100 or so,
> > > or even less.
> > 
> > What's your client? Does it switch to power save mode after DHCP response
> > and is it an 11n client as well [same device? different device/driver -
> > yes I know you haven't enabled 11n, but still.]?
> 
> I have tested with two clients, my GNU/Linux laptop. It has a intel wlan
> chipset. How would I know if it switches to power save?
iw dev wlanX get power_save

if it says "Power save: off", then it will never switch into power-save
mode.

however, rtl8192cu doesn't generate any beacons
<http://comments.gmane.org/gmane.linux.kernel.wireless.general/96712>
so the AP mode isn't fully implemented anyway. So, it's a bit
pointless to debug the issue any further at this time.

> Btw I saw another difference on the 8192cu AP compared to other AP's
> nearby. Kismet say it had a beacon time of 0, while others had non-zero.
> I applied a patch I found on the list for some beacon handling.
Wait. Are you still talking about rtl8192cu (rtlwifi), or are you now
referring to 8192cu (the vendor driver)

Regards,
	Chr
