Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpsrv03.uni-oldenburg.de ([134.106.87.11]:56171 "EHLO
	smtpsrv03.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161469AbXDRJAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 05:00:22 -0400
Message-ID: <4625DE1E.1040302@mail.uni-oldenburg.de>
Date: Wed, 18 Apr 2007 11:00:14 +0200
From: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
MIME-Version: 1.0
To: chunkeey@web.de
CC: linux-net@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: prism54: WPA/RSN support for fullmac cards
References: <462336B1.4090006@mail.uni-oldenburg.de> <1176732546.27418.9.camel@localhost.localdomain> <4625130F.4090104@mail.uni-oldenburg.de> <200704172123.30956.chunkeey@web.de>
In-Reply-To: <200704172123.30956.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But please, before you waste your time with _some_ fullmac anomalies,
> 
> get the last wireless-dev.git tree. 
> There is a SOFTMAC driver for all prism54 chips now! 

Thanks, I will try that SOFTMAC driver.
I thought about that before, because Netgear provides only one driver (a Softmac
driver) for both versions of the WG511 (Made in China and made in Taiwan)
(see here: http://de.gentoo-wiki.com/WG511)

> You only need a firmware:
> http://daemonizer.de/prism54/prism54-fw/fw-softmac/lmac_2.7.0.0.arm
> (rename it to "isl3886" and put it in the right place).

I did some further test with different firmware versions using Windows which I
reported in the prism54.org Forum, but the posting is gone (the Link doesn't
work anymore perhaps it was removed by an admin?)

I will try to summarize it here:
- first of all, I use the Netgear WG511 FULLMAC version (Made in Taiwan)

- The best encryption of the (Fullmac) firmware is WPA2 + TKIP. (1.0.4.3.arm)

- The windows driver on Netgear Homepage for WG511 contains a Softmac Firmware
(2.4.12.0.arm) included in WG511ICB.sys and supports only WPA + TKIP

- I tried to use the driver from MC2835WV2-V3_112WW.zip (2.13.1.0.arm) included
in 2835wc51.sys for my Netgear card successfully with WPA2 + AES using windows
or Linux with Ndiswrapper

- I found another firmware (2.13.8.0.arm) which is not listed on
http://daemonizer.de/prism54/prism54-fw/
If someone knows how to extract the firmware from the windows driver (named
wlanCIG.sys) you can get it here:
http://www.funkwerk-ec.com/portal/downloadcenter/dateien/FEC_W-Clients/FEC_W-Client_CB_PCI_mPCI_11g_v3320_1.zip
It works although fine with Netgear WG511 and WPA2 + AES encryption.

Conclusion:
It seems that Softmac firmware version greater than 2.13.x.x have WPA2 + AES
Support, perhaps this helps for further development or reverse engineering of
the firmware.
(I could although provide debug traces from wpa_supplicant when using WPA2 + AES
with ndiswrapper if that helps)

Regards Stefan

