Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34601 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2HYWEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2012 18:04:23 -0400
Received: by ghrr11 with SMTP id r11so678151ghr.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2012 15:04:22 -0700 (PDT)
Message-ID: <50394BE4.3000508@wybc.com> (sfid-20120826_000504_743944_E7FF1370)
Date: Sat, 25 Aug 2012 18:04:20 -0400
From: Sherwin Soltani <sherwin@wybc.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k: AR9462 btcoex doesn't appear to work
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have an Acer Aspire V5-571 which contains the AR9462 chipset (PCI ID 
168c:0034), supported by the ath9k driver. This chipset claims to 
support Bluetooth coexistence. However, after booting up, my kernel does 
not register any Bluetooth devices.

I am using kernel version 3.6.0-999-generic (apw@gomeisa) (gcc version 
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)). I also tried 3.4 and 3.2 kernels 
without success. Additionally, I can try to do

rmmod ath9k && modprobe ath9k btcoex_enable=1

In the message log, I can see this:

[ 1204.643120] ath9k: ath9k: Driver unloaded
[ 1214.203099] ath: phy1: Disabling ASPM since BTCOEX is enabled
[ 1214.203105] ath: EEPROM regdomain: 0x6a
[ 1214.203106] ath: EEPROM indicates we should expect a direct regpair map
[ 1214.203108] ath: Country alpha2 being used: 00
[ 1214.203109] ath: Regpair used: 0x6a

However 'hcitool dev' shows no devices after this operation.

Looking back through the ath9k-devel list, I can see that there was some 
discussion on this chipset, but it seems that Bluetooth functionality 
wasn't tested with it. Is this a known problem? Is there any information 
I can supply to help fix it?

Aside from the Bluetooth problems, there are also problems with 
frequently dropping signals (even when I am very close to the access 
point), but right now that's a secondary concern to Bluetooth for me.

Thanks,

Sherwin Soltani
