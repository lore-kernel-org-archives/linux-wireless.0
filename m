Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:50619 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbaHaSto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2014 14:49:44 -0400
Message-ID: <54036D77.6040708@maya.org> (sfid-20140831_205014_153363_46DC3176)
Date: Sun, 31 Aug 2014 20:46:15 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: Matthias Fend <Matthias.Fend@wolfvision.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] rt2x00: Ralink RT5572 (TL-WDN3200) sporadic damages
References: <CC2A85E271C1FB479D9C17305347F69A04C60591@WOLFSERVER19.wolfvision-at.intra>
In-Reply-To: <CC2A85E271C1FB479D9C17305347F69A04C60591@WOLFSERVER19.wolfvision-at.intra>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Matthias.

Matthias Fend wrote:
> Hello,
> 
> While continuing stability tests after fixing the high current peaks while sending uninitialized beacons [1] we still have occasional cases where suddenly a stick stops working and is getting very hot.
> In this case very hot means that the plastic molding of the dongle shows very clear deformations and the stick won't work properly anymore.
> One can see continuous vendor request failed message in case when a stick stops working or when a damaged stick is inserted.
> 
> So far we always tested with our custom hardware. To rule out hardware topics we decided to build up a test farm with a more common platform.
> For a test we setup 10 raspberry pi with this setup:
> Kernel: https://github.com/raspberrypi/linux/tree/rpi-3.16.y
> WLAN-Stick Firmware: V0.33
> ap: hostapd 1.0
> ap:config:
> interface=wlan0
> driver=nl80211
> ieee80211n=1
> wmm_enabled=1
> ssid=MyPi1
> channel=36
> disassoc_low_ack=0
> country_code=DE
> ieee80211d=1
> hw_mode=a
> ht_capab=[HT40+][SHORT-GI-20][SHORT-GI-40]
> wpa=2
> wpa_passphrase=raspberry
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP CCMP
> 
> Within the first 48 hours three of the ten setups failed with the mentioned problems. Since the broken sticks had been replaced the test is now running since five days without further problems.
> At least this test helped to figure out that this issue does not depend on our hardware.
> Unfortunately this bug is really rare and currently I have absolutely no idea what is triggering this damages.
> Has anybody observed similar behavior or has some helpful hints?


Your problem with hardware getting extremely hot is old and is not
specific to your device. I wrote about this problem long ago. This is
one more reason why I'm not using rt2800usb but the original Ralink
drivers from manufacturer.

The reason from my point of view is the different USB handling:
rt2800usb uses a lot of small USB packages and therefore needs a lot of
more interrupts compared to the original driver, which uses big USB
packages.

See:
http://news.gmane.org/find-root.php?group=gmane.linux.drivers.rt2x00.user&article=615


Regards,
Andreas
