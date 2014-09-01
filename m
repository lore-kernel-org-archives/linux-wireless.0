Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ems.wolfvision.net ([213.33.91.163]:37896 "EHLO
	ems.wolfvision.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaIAHNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:13:45 -0400
From: Matthias Fend <Matthias.Fend@wolfvision.net>
To: Andreas Hartmann <andihartmann@freenet.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: AW: [rt2x00-users] rt2x00: Ralink RT5572 (TL-WDN3200) sporadic
 damages
Date: Mon, 1 Sep 2014 07:06:15 +0000
Message-ID: <CC2A85E271C1FB479D9C17305347F69A04D2A3CF@WOLFSERVER19.wolfvision-at.intra> (sfid-20140901_091348_458637_8424EA95)
References: <CC2A85E271C1FB479D9C17305347F69A04C60591@WOLFSERVER19.wolfvision-at.intra>
 <54036D77.6040708@maya.org>
In-Reply-To: <54036D77.6040708@maya.org>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> -----Ursprüngliche Nachricht-----
> Von: Andreas Hartmann [mailto:andihartmann@freenet.de]
> Gesendet: Sonntag, 31. August 2014 20:46
> An: Matthias Fend; linux-wireless@vger.kernel.org
> Cc: users@rt2x00.serialmonkey.com
> Betreff: Re: [rt2x00-users] rt2x00: Ralink RT5572 (TL-WDN3200) sporadic
> damages
> 
> Hello Matthias.
> 
> Matthias Fend wrote:
> > Hello,
> >
> > While continuing stability tests after fixing the high current peaks while
> sending uninitialized beacons [1] we still have occasional cases where
> suddenly a stick stops working and is getting very hot.
> > In this case very hot means that the plastic molding of the dongle shows
> very clear deformations and the stick won't work properly anymore.
> > One can see continuous vendor request failed message in case when a
> stick stops working or when a damaged stick is inserted.
> >
> > So far we always tested with our custom hardware. To rule out hardware
> topics we decided to build up a test farm with a more common platform.
> > For a test we setup 10 raspberry pi with this setup:
> > Kernel: https://github.com/raspberrypi/linux/tree/rpi-3.16.y
> > WLAN-Stick Firmware: V0.33
> > ap: hostapd 1.0
> > ap:config:
> > interface=wlan0
> > driver=nl80211
> > ieee80211n=1
> > wmm_enabled=1
> > ssid=MyPi1
> > channel=36
> > disassoc_low_ack=0
> > country_code=DE
> > ieee80211d=1
> > hw_mode=a
> > ht_capab=[HT40+][SHORT-GI-20][SHORT-GI-40]
> > wpa=2
> > wpa_passphrase=raspberry
> > wpa_key_mgmt=WPA-PSK
> > wpa_pairwise=TKIP CCMP
> >
> > Within the first 48 hours three of the ten setups failed with the mentioned
> problems. Since the broken sticks had been replaced the test is now running
> since five days without further problems.
> > At least this test helped to figure out that this issue does not depend on
> our hardware.
> > Unfortunately this bug is really rare and currently I have absolutely no idea
> what is triggering this damages.
> > Has anybody observed similar behavior or has some helpful hints?
> 
> 
> Your problem with hardware getting extremely hot is old and is not specific
> to your device. I wrote about this problem long ago. This is one more reason
> why I'm not using rt2800usb but the original Ralink drivers from
> manufacturer.

I always thought that the original vendor driver does not support ap mode??

> 
> The reason from my point of view is the different USB handling:
> rt2800usb uses a lot of small USB packages and therefore needs a lot of more
> interrupts compared to the original driver, which uses big USB packages.
> 
> See:
> http://news.gmane.org/find-
> root.php?group=gmane.linux.drivers.rt2x00.user&article=615

In my opinion there are two problematic things. One is the USB communication with the chipset and one is the register configuration itself.
Meanwhile the communication timing got tweaked in a way that it seems stable to me - at least for my setup.
The register configuration is somehow different than the one used by the original vendor driver for windows.
But it's very hard to find out the crucial difference or maybe the set of differences since there is no/very little reliable documentation about the register meanings.

Thanks,
 ~Matthias

> 
> 
> Regards,
> Andreas
