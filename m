Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52784 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab0L2BEb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 20:04:31 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PXkSr-0000z4-Vr
	for linux-wireless@vger.kernel.org; Wed, 29 Dec 2010 02:04:29 +0100
Received: from warren.leverton.org ([217.155.219.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 02:04:29 +0100
Received: from nick by warren.leverton.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 02:04:29 +0100
To: linux-wireless@vger.kernel.org
From: Nick Leverton <nick@leverton.org>
Subject: Re: printk %pV compatibility in b43 and ath for compat-wireless
Date: Wed, 29 Dec 2010 01:04:13 +0000 (UTC)
Message-ID: <ife1ec$k3m$1@dough.gmane.org>
References: <loom.20101227T190514-850@post.gmane.org> <4D19118D.6040202@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In article <4D19118D.6040202@lwfinger.net>,
Larry Finger  <Larry.Finger@lwfinger.net> wrote:
>-=-=-=-=-=-
>
>On 12/27/2010 12:05 PM, Nick Leverton wrote:
>> 
>> Dec 23 21:10:46 nickl kernel: [688182.007780] Broadcom 43xx driver loaded [ 
>> Features: PMNLS, Firmware-ID: FW13 ]
>> Dec 23 21:10:50 nickl kernel: [688186.100195] b43-phy0: f535bb54
>> Dec 23 21:11:09 nickl kernel: [688205.048054] b43-phy0: f4a3bb54
>> Dec 23 21:11:31 nickl kernel: [688225.667842] b43-phy0 ERROR: f56a5f34
>
>These changes were in commit #5b736d42.
>
>I cannot fix them in compat-wireless, but I think I know the origin of those
>errors. At present, b43 is not setting up the transmit header correctly for N
>PHYs. Whenever, the rate-setting mechanism tries an OFDM rate, one of these
>errors will occur. We are working on modifications to the driver to fix this.
>Until we get that done, issue an 'iwconfig wlan0 rate 11M' to lock the interface
>at 11 Mb/s.
>
>The attached patch can be reverse-applied to fix the driver.

That's super, thankyou - fixed the message format, rate-limit then stops
the error reports and and also improved the stability !  I'll see if it
can keep an SSH session up overnight, but it's looking very good so far.
This is a 14e4:4328 device in a 32bit Dell Latitude.

Now reporting (must get around to adding DEBUG to the driver):

Dec 29 00:00:36 nickl kernel: [1127991.569823] b43-pci-bridge 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Dec 29 00:00:36 nickl kernel: [1127991.637758] ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0
Dec 29 00:00:36 nickl kernel: [1127991.662341] b43-phy0: Broadcom 4321 WLAN found (core revision 12)
Dec 29 00:00:36 nickl kernel: [1127991.732169] Registered led device: b43-phy0::tx
Dec 29 00:00:36 nickl kernel: [1127991.732213] Registered led device: b43-phy0::rx
Dec 29 00:00:36 nickl kernel: [1127991.732255] Registered led device: b43-phy0::radio
Dec 29 00:00:36 nickl kernel: [1127991.732292] Broadcom 43xx driver loaded [ Features: PMNLS, Firmware-ID: FW13 ]
Dec 29 00:00:41 nickl kernel: [1127996.256626] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
Dec 29 00:00:41 nickl kernel: [1127996.353560] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Dec 29 00:00:52 nickl kernel: [1128007.749755] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Dec 29 00:01:01 nickl kernel: [1128016.857337] b43-phy0 ERROR: PHY transmission error
Dec 29 00:02:08 nickl kernel: [1128083.486959] device wlan0 entered promiscuous mode
Dec 29 00:02:14 nickl kernel: [1128089.096688] b43-phy0 ERROR: PHY transmission error
Dec 29 00:02:26 nickl kernel: [1128101.280579] b43-phy0 ERROR: PHY transmission error


Nick
-- 
Serendipity: http://www.leverton.org/blosxom (last update 29th March 2010)
        "The Internet, a sort of ersatz counterfeit of real life"
                -- Janet Street-Porter, BBC2, 19th March 1996

