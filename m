Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:48226 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0LJShd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 13:37:33 -0500
Subject: Re: b43 N PHY status report
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=utf-8
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
In-Reply-To: <4CFFA112.7030800@lwfinger.net>
Date: Fri, 10 Dec 2010 19:30:57 +0100
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Message-Id: <885729A3-72D4-4EFC-AAFE-D2B573E00ED9@ing.unibs.it>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com> <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com> <4CFFA112.7030800@lwfinger.net>
To: Larry Finger <larry.finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 8, 2010, at 4:15 PM, Larry Finger wrote:

> Rafał,
> 
> The N PHY driver is remarkably stable. So far, my link has been up for nearly 16
> hours under normal conditions - I have not yet tried any stress tests. Other
> than the PHY errors that you noted, my link has only reported 2 other unusual
> events. I have had 3 "Deauthentication for reason 3" from which it recovered in
> one try. Also logged are 9 instances of "RX: Packet size underrun (2)/Packet
> dropped" events. Again, these caused no problems.
Hi Rafał,

I confirm Larry's feedbacks. I tried both on a 32bit and a 64bit architectures (the first is frodo), and it works. I too see only CCK packets. On 64bit arch (Atom) it works but when I try to unload the module I get this

[ 1117.516031] unregister_netdevice: waiting for wlan1 to become free. Usage count = 1

and the device is never release (by who?). I have to reboot.

I'm using two cards, one reports

[  311.439406] b43-phy0: Broadcom 4321 WLAN found (core revision 12)
[  311.480046] b43-phy0 debug: Found PHY: Analog 5, Type 4, Revision 2
[  311.480075] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2055, Revision 4

The other (an Apple original card) reports

[   82.726931] b43-phy0: Broadcom 4321 WLAN found (core revision 11)
[   82.768030] b43-phy0 debug: Found PHY: Analog 5, Type 4, Revision 1
[   82.768062] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2055, Revision 4

Thanks,
-Francesco


Informativa sulla privacy: http://help.ing.unibs.it/privacy.php


