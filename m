Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm17-vm1.bullet.mail.ird.yahoo.com ([77.238.189.206]:36668 "HELO
	nm17-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751105Ab3HTUuP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 16:50:15 -0400
Message-ID: <1377031813.65033.YahooMailBasic@web171402.mail.ir2.yahoo.com> (sfid-20130820_225020_851069_89314DE1)
Date: Tue, 20 Aug 2013 21:50:13 +0100 (BST)
From: Phillip Moss <phillipmoss12@yahoo.es>
Subject: Re: Signal loss rtl8723ae wifi driver
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <520AFD5C.3010905@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,
Sorry for taking so long to reply.
I am using Arch Linux  3.10.7-1-ARCH  x86_64 with KDE and Network-Manager.
wlp3s0 is the name of my wireless interface: https://wiki.archlinux.org/index.php/Network_Configuration#Network_Interfaces
I have renamed the interface to the default wlan0 we all know and love with: ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

To measure signal strength I am using "Link Quality", "Signal Level" from iwconfig and signal strength from network manager.

When I am right next to my router I get between: -36  and -42dbm.
Link quality is between 68/70 and 70/70.
Network Manager reports signal at 84%.

When a signal loss period ocurrs Link quality drops to 14/70 (In some cases 12-13) and then quickly jumps back up to 40 then up to 68-70.
While this happens Signal level bounces up to between +2 and +10dbm then backdown to around -90dbm and then stabalizes again at -36 -42.
Network Manager reports signal around 32%

If I step a few meters away signal level is stable around -52 and -64 dbm. Link Quality is around 56/70.
During a Signal loss period Link Quality jumps down to about 12-13/70 and Signal Level to around 14dbm with occasional spikes up to 99.
These spikes only sometimes result in the interface dropping the connection to the AP when at this distance, but never when I am very close to the router.

I am not sure if this is pure paranoia but it seems that the card gets “stuck” and then keeps on receiving/transmitting. To see if this was true I tried airodump and it does seem as if the card stops receiving beacons at irregular intervals.

I have recompiled backports with the proposed patch and I am still experiencing the same problem.
Thank you very much for all your help,
Phillip

--------------------------------------------
El mié, 14/8/13, Larry Finger <Larry.Finger@lwfinger.net> escribió:

 Asunto: Re: Signal loss rtl8723ae wifi driver
 Para: "Phillip Moss" <phillipmoss12@yahoo.es>
 CC: linux-wireless@vger.kernel.org
 Fecha: miércoles, 14 de agosto, 2013 05:45
 
 On 08/13/2013 11:23 AM, Phillip Moss
 wrote:
 > Hi all,
 > I have a rtl8723ae wifi card on my laptop. When
 connecting to any wifi Access Point
 > the wifi signal fluctuates from full strength to very
 low.  In order to connect and
 > stay connected I must be no farther than two meters
 from my router otherwise I get
 > disconnected. I have tried the kernel driver on
 multiple distros as well as the
 > vendor drivers for older kernel versions. All seem to
 have the same problem. The card
 > works ok on Windows 7 with vendor drivers. I have also
 tried compiling
 > backports-3.10-rc1-2 with no luck. During a signal loss
 period I get no logs but if I
 > take the laptop too far from the AP dmesg reports:
 
 Philip,
 
 Could you try the attached patch?
 
 Larry
 
 
