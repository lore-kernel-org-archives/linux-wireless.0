Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:40132 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586AbXIRQ36 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 12:29:58 -0400
To: linux-wireless@vger.kernel.org
Subject: AR5006 - should it work?
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 18 Sep 2007 18:29:56 +0200
Message-ID: <m3odg0dji3.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to use AR5006* mini-PCI cards with no success - should
I expect them to work with madwifi ath5k branch and/or
linux/kernel/git/linville/wireless-dev.git ath5k branch on kernel.org?

AR5004X seems to work fine.

Don't work:
ENGENIUS EMP-8602(+) 400 mW a/b/g AR5413 rev 1.0 and 1.1
AR5006X PCI ID 168c:001b 168c:2063

SparkLAN WMIA-166AG a/b/g AR5414A
AR5006XS PCI ID 168c:001b 17f9:000d

Testing with:
# modprobe ath5k
# ifconfig wlan0 up
# iwlist wlan0 scan

wlan0     No scan results


madwifi.org ath5k dmesg (with 2.6.22 kernel, EMP-8602):
ath5k: MAC revision: 5413  (0xa4)
ath5k: PHY revision: SChip (0x63)
ath5k: EEPROM version: 5.2
wmaster0: Selected rate control algorithm 'simple'

John's git repository (2.6.23-current, EMP-8602):
wmaster0: Selected rate control algorithm 'simple'
ath_pci 0000:00:0d.0: AR5212 chip found: mac 10.10 phy 6.1

This is ARM-based system (Intel IXP425) but just tried with
AMD64 (madwifi ath5k only) - results are the same.


AR5004X based card shows few devices in the neighbourhood, max
signal ~ 20/127.

Any ideas?
-- 
Krzysztof Halasa
