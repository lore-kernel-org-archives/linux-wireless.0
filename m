Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:57311 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab1ATSpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 13:45:47 -0500
Message-ID: <4D3882D5.2080902@lockie.ca>
Date: Thu, 20 Jan 2011 13:45:41 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k problem with kernel 2.6.37
References: <4D37E2A9.6010209@lockie.ca> <AANLkTikhpK09=wyq=g6kHbsgd-C13A4Vc1TrA29utd5k@mail.gmail.com>
In-Reply-To: <AANLkTikhpK09=wyq=g6kHbsgd-C13A4Vc1TrA29utd5k@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/11 03:35, Mohammed Shafi wrote:
> On Thu, Jan 20, 2011 at 12:52 PM, James <bjlockie@lockie.ca> wrote:
>> phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
>> mem=0xffffc90001880000, irq=17
>>
>> I get few or no results when I do
>> iwlist wlan1 scan with kernel 2.6.37
>>
> We will check it out
>
>> but it is consistently good with kernel 2.6.36.2
>>
>> Is there a way to compare the kernel configs to make sure I didn't
>> change anything?
> Please try with latest compat wireless, which might be helpful
I got:
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

I can't compile it:
/usr/src/compat-wireless-2011-01-19 $ sudo make 
/usr/src/compat-wireless-2011-01-19/config.mk:202: "WARNING:
CONFIG_CFG80211_WEXT will be deactivated or not working because kernel
was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like
iwconfig will not work. To activate it build your kernel e.g. with
CONFIG_LIBIPW=m."
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.37/build M=/usr/src/compat-wireless-2011-01-19
modules
make[1]: Entering directory `/usr/src/linux-2.6.37'
  CC [M]  /usr/src/compat-wireless-2011-01-19/compat/main.o
  CC [M]  /usr/src/compat-wireless-2011-01-19/compat/compat-2.6.38.o
  LD [M]  /usr/src/compat-wireless-2011-01-19/compat/compat.o
  CC [M]  /usr/src/compat-wireless-2011-01-19/drivers/bluetooth/hci_vhci.o
  CC [M]  /usr/src/compat-wireless-2011-01-19/drivers/bluetooth/bcm203x.o
  CC [M]  /usr/src/compat-wireless-2011-01-19/drivers/bluetooth/bpa10x.o
  CC [M]  /usr/src/compat-wireless-2011-01-19/drivers/bluetooth/bfusb.o
  CC [M]  /usr/src/compat-wireless-2011-01-19/drivers/bluetooth/btusb.o
  CC [M]  /usr/src/compat-wireless-2011-01-19/drivers/bluetooth/ath3k.o
  CC [M] 
/usr/src/compat-wireless-2011-01-19/drivers/bluetooth/btmrvl_main.o
  LD [M]  /usr/src/compat-wireless-2011-01-19/drivers/bluetooth/btmrvl.o
  CC [M] 
/usr/src/compat-wireless-2011-01-19/drivers/misc/eeprom/eeprom_93cx6.o
  CC [M]  /usr/src/compat-wireless-2011-01-19/drivers/net/b44.o
/usr/src/compat-wireless-2011-01-19/drivers/net/b44.c:13:1: warning:
"pr_fmt" redefined
In file included from include/linux/kernel.h:20,
                 from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:125,
                 from include/linux/netdevice.h:29,
                 from
/usr/src/compat-wireless-2011-01-19/include/linux/compat-2.6.29.h:5,
                 from
/usr/src/compat-wireless-2011-01-19/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/linux/printk.h:161:1: warning: this is the location of the
previous definition
/usr/src/compat-wireless-2011-01-19/drivers/net/b44.c: In function
'b44_pci_init':
/usr/src/compat-wireless-2011-01-19/drivers/net/b44.c:2345: error:
implicit declaration of function 'ssb_pcihost_register'
make[3]: *** [/usr/src/compat-wireless-2011-01-19/drivers/net/b44.o] Error 1
make[2]: *** [/usr/src/compat-wireless-2011-01-19/drivers/net] Error 2
make[1]: *** [_module_/usr/src/compat-wireless-2011-01-19] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.37'
make: *** [modules] Error 2

Do I understand it correctly that it is just newer and will be in the
kernel eventually?

How can I see what version of the driver I am using?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

