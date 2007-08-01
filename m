Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:24195 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbXHARkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 13:40:02 -0400
Received: by nf-out-0910.google.com with SMTP id g13so72031nfb
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2007 10:40:01 -0700 (PDT)
Message-ID: <46B0C559.6030704@googlemail.com>
Date: Wed, 01 Aug 2007 19:39:37 +0200
From: Gabriel C <nix.or.die@googlemail.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
References: <20070731230932.a9459617.akpm@linux-foundation.org>	<46B066C9.9030100@googlemail.com> <20070801102615.c8f7d1b9.akpm@linux-foundation.org>
In-Reply-To: <20070801102615.c8f7d1b9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton wrote:
> On Wed, 01 Aug 2007 12:56:09 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> Andrew Morton wrote:
>> ...
>>> - git-wireless is back.  It is still a >3MB diff, and appears to compile.
>>>
>> ...
>>
>> allmodconfig on UML 
>>
>> ...
>>
>>
>> In file included from drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:48:
>> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_pio.h: In function 'bcm43xx_pio_write':
>> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_pio.h:97: error: implicit declaration of function 'mmiowb'
>> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c: In function 'bcm43xx_init':
>> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4051: warning: label 'err_dfs_exit' defined but not used
>> make[4]: *** [drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.o] Error 1
>> make[3]: *** [drivers/net/wireless/bcm43xx-mac80211] Error 2
>> make[2]: *** [drivers/net/wireless] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>> make: *** Waiting for unfinished jobs....
>>
> 
> (cc linux-wireless)
> 
> Probably Kconfig troubles again.
> 

Maybe something from SSB ?

...

scripts/kconfig/conf -s arch/um/Kconfig
net/bluetooth/hidp/Kconfig:4:warning: 'select' used by config symbol 'BT_HIDP' refers to undefined symbol 'HID'
drivers/net/Kconfig:1456:warning: 'select' used by config symbol 'B44_PCI' refers to undefined symbol 'SSB_PCIHOST'
drivers/net/Kconfig:1457:warning: 'select' used by config symbol 'B44_PCI' refers to undefined symbol 'SSB_DRIVER_PCICORE'
drivers/net/Kconfig:1437:warning: 'select' used by config symbol 'B44' refers to undefined symbol 'SSB'
drivers/net/Kconfig:2112:warning: 'select' used by config symbol 'R8169' refers to undefined symbol 'EEPROM_93CX6'
drivers/net/wireless/Kconfig:552:warning: 'select' used by config symbol 'RTL8187' refers to undefined symbol 'EEPROM_93CX6'
drivers/net/wireless/Kconfig:637:warning: 'select' used by config symbol 'RT2X00_LIB_RFKILL' refers to undefined symbol 'INPUT_POLLDEV'
drivers/net/wireless/Kconfig:643:warning: 'select' used by config symbol 'RT2400PCI' refers to undefined symbol 'EEPROM_93CX6'
drivers/net/wireless/Kconfig:662:warning: 'select' used by config symbol 'RT2500PCI' refers to undefined symbol 'EEPROM_93CX6'
drivers/net/wireless/Kconfig:682:warning: 'select' used by config symbol 'RT61PCI' refers to undefined symbol 'EEPROM_93CX6'
drivers/net/wireless/bcm43xx-mac80211/Kconfig:14:warning: 'select' used by config symbol 'BCM43XX_MAC80211_PCI' refers to undefined symbol 'SSB_PCIHOST'
drivers/net/wireless/bcm43xx-mac80211/Kconfig:15:warning: 'select' used by config symbol 'BCM43XX_MAC80211_PCI' refers to undefined symbol 'SSB_DRIVER_PCICORE'
drivers/net/wireless/bcm43xx-mac80211/Kconfig:28:warning: 'select' used by config symbol 'BCM43XX_MAC80211_PCMCIA' refers to undefined symbol 'SSB_PCMCIAHOST'
drivers/net/wireless/bcm43xx-mac80211/Kconfig:48:warning: 'select' used by config symbol 'BCM43XX_MAC80211_DEBUG' refers to undefined symbol 'SSB_DEBUG'
drivers/net/wireless/bcm43xx-mac80211/Kconfig:5:warning: 'select' used by config symbol 'BCM43XX_MAC80211' refers to undefined symbol 'SSB'
lib/Kconfig.kgdb:71:warning: 'select' used by config symbol 'KGDB_8250_NOMODULE' refers to undefined symbol 'SERIAL_8250'

...
