Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm29.bullet.mail.sg3.yahoo.com ([106.10.151.24]:46407 "EHLO
	nm29.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbaFGTNq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 15:13:46 -0400
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com> <53935133.5020303@lwfinger.net> <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com> <539356EA.1070004@lwfinger.net> <1402165531.45127.YahooMailNeo@web193003.mail.sg3.yahoo.com> <53935FFE.10708@lwfinger.net>
Message-ID: <1402168424.40608.YahooMailNeo@web193005.mail.sg3.yahoo.com> (sfid-20140607_211414_235896_51F26AB1)
Date: Sun, 8 Jun 2014 03:13:44 +0800 (SGT)
From: Powerful Notageek <powerfulnotageek@yahoo.in>
Reply-To: Powerful Notageek <powerfulnotageek@yahoo.in>
Subject: Re: MT7630e availability in kernel by default
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <53935FFE.10708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dmesg says nothing and there's probably no firmware for the device (although linux-firmware is installed) 

These are the firmwares available to me: 

[root@localhost ~]# ll /usr/lib/firmware/rt2*
-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2561.bin
-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2561s.bin
-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2661.bin
-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2860.bin
-rw-r--r--. 1 root root 8192 Mar 18 00:08 /usr/lib/firmware/rt2870.bin

Thank you. 



On Sunday, 8 June 2014 12:24 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
On 06/07/2014 01:25 PM, Powerful Notageek wrote:
> I tried them and here's the output: (verbose)
>
> [root@localhost ~]# modprobe -v rt2800pci
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/lib/crc-ccitt.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/net/wireless/cfg80211.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/net/mac80211/mac80211.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/misc/eeprom/eeprom_93cx6.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00mmio.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00pci.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800lib.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800mmio.ko
> insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800pci.ko
> [root@localhost ~]# echo "14c3 7630" > /sys/bus/pci/drivers/rt2800pci/new_id
> [root@localhost ~]# iwconfig
> p3p1      no wireless extensions.
>
> lo        no wireless extensions.

When you do the above, what ends up in the dmesg output? In particular, is the 
firmware available?




Larry
