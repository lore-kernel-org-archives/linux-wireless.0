Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42268 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbXLRNPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:15:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Operation "wpa_driver_wext_set_countermeasures" not supported
Date: Tue, 18 Dec 2007 14:13:29 +0100
Cc: Robert Allerstorfer <linux-ra@anet.at>,
	linux-wireless@vger.kernel.org
References: <1942722038.20071212234810@anet.at> <200712171514.48013.mb@bu3sch.de> <345588434.20071218123602@anet.at>
In-Reply-To: <345588434.20071218123602@anet.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712181413.29569.mb@bu3sch.de> (sfid-20071218_131547_730164_1C2D4792)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 December 2007 12:36:02 Robert Allerstorfer wrote:
> On Mon, 17 Dec 2007, 15:14 GMT+01 Michael Buesch wrote:
> 
> > Please test what I suggested.
> 
> done. I have recompiled and replaced the original b43.ko from
> 'kernel-2.6.23.9-90.fc8.src.rpm', with the modified 'phy.c' ["if
> (B43_DEBUG)" changed to "if (0)" on line 741]. Using Fedora's build
> mechanism, I had to built the entire (baseonly) kernel which took over
> 2 hours. 
> 
> Of course, there is now no more "Disabling TX power adjustment"
> warning in dmesg, but I can't see any other different behavior. I
> still can't connect to the WPA2 access point. dmesg still says
> 
> wlan0: RX ReassocResp from 00:11:22:33:44:55 (capab=0x431 status=0 aid=1)
> wlan0: associated
> wlan0: switched to short barker preamble (BSSID=00:11:22:33:44:55)
> wlan0: disassociate(reason=3) 

Uhm, that seems to be some mac80211 problem.
The driver is obviously able to transmit and receive data properly.
Otherwise it would not be able to associate.

> 
> and the debug output of wpa_supplicant still contains
> 
> wpa_driver_wext_set_countermeasures
> ioctl[SIOCSIWAUTH]: Operation not supported
> 
> What can I do to get it working one day?
> 
> rob.

-- 
Greetings Michael.
