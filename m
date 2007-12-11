Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s12.bay0.hotmail.com ([65.54.246.212]:7922 "EHLO
	bay0-omc3-s12.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbXLKUT0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 15:19:26 -0500
Message-ID: <BAY134-W251B269AE3F727106D931FD4640@phx.gbl> (sfid-20071211_201929_818410_029A9D4F)
From: Joachim Frieben <jfrieben@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Misleading PCI id information on chipsets supported by ath5k
Date: Tue, 11 Dec 2007 20:19:25 +0000
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


There is some misleading information on the chipsets supported by the ath5k driver at
 
  http://www.linuxwireless.org/en/users/Drivers/ath5k#supportedchips .

In particular, the following entry is incorrect:

Vendor:device   Type       Basic-testing
168c:0013      AR5212   OK

I have a D-Link DWL-G520 Rev. B4 card, and its [chipset's] PCI id is exactly the one indicated above. However, it's based upon an AR5212 802.11 (b/g) chipset, and ath_info reports:

   -==Device Information==-
  MAC Version:  5213A (0x70)
  MAC Revision: 5213A (0x79)
  PHY Revision: 2112a (0x56)
   -==EEPROM Information==-
  EEPROM Version:     5.1
  EEPROM Size:        16K
  Regulatory Domain:  0x30
   -==== Capabilities ====-
  |  802.11a Support: no   |
  |  802.11b Support: yes  |
  |  802.11g Support: yes  |
  |  RFKill  Support: no   |
  |  32KHz   Crystal: no   |
   ========================
  GPIO registers: CR 00000000 DO 00000000 DI 00000010

which is consistent with the information given on the retail box stating that it is a (b/g) device. Thus, 802.11a is not supported, and according to the next section on the support page called "Notes on supported devices", the whole card is not supported by ath5k because

"Please note that 001c is an 802.11bg device. As you can see from above the current driver design is for 802.11a, 802.11ab, or 802.11abg. We'll probably need a new device type in the driver for this device to pass only bg initial register writes and baseband gain settings."

Strange enough, 001c is cited as an [unsupported] (b/g) device whereas 0013 should be an (a/b/g) device which is apparently wrong. So, either the PCI id is not an appropriate way to label whether a device is supported or not, or the support page is wrong. Needless to say that the DWL-G520 does not work with ath5k. Right now, it does not even scan access points at all. Could some authorized person have a look into this and make the necessary corrections on the web page?

Thanks,

~jf
_________________________________________________________________
Importieren Sie ganz einfach Ihre E-Mail Adressen in den Messenger!
http://messenger.live.de/community/neuekontakte_adressimport.html