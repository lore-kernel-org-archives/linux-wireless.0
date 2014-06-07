Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm14-vm5.bullet.mail.sg3.yahoo.com ([106.10.149.36]:21606 "EHLO
	nm14-vm5.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbaFGScW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 14:32:22 -0400
References: <1402159087.63238.YahooMailNeo@web193001.mail.sg3.yahoo.com> <53935133.5020303@lwfinger.net> <1402163980.67578.YahooMailNeo@web193003.mail.sg3.yahoo.com> <539356EA.1070004@lwfinger.net>
Message-ID: <1402165531.45127.YahooMailNeo@web193003.mail.sg3.yahoo.com> (sfid-20140607_203234_557700_88B721FC)
Date: Sun, 8 Jun 2014 02:25:31 +0800 (SGT)
From: Powerful Notageek <powerfulnotageek@yahoo.in>
Reply-To: Powerful Notageek <powerfulnotageek@yahoo.in>
Subject: Re: MT7630e availability in kernel by default
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <539356EA.1070004@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried them and here's the output: (verbose)

[root@localhost ~]# modprobe -v rt2800pci 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/lib/crc-ccitt.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/net/wireless/cfg80211.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/net/mac80211/mac80211.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/misc/eeprom/eeprom_93cx6.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00mmio.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2x00pci.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800lib.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800mmio.ko 
insmod /lib/modules/3.14.4-200.fc20.x86_64/kernel/drivers/net/wireless/rt2x00/rt2800pci.ko 
[root@localhost ~]# echo "14c3 7630" > /sys/bus/pci/drivers/rt2800pci/new_id
[root@localhost ~]# iwconfig 
p3p1      no wireless extensions.

lo        no wireless extensions.


Also lspci -v 

03:00.0 Network controller: MEDIATEK Corp. MT7630e 802.11bgn Wireless Network Adapter
 Subsystem: Foxconn International, Inc. Device e074
 Flags: fast devsel, IRQ 17
 Memory at f7900000 (32-bit, non-prefetchable) [size=1M]
 Capabilities: [40] Power Management version 3
 Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
 Capabilities: [70] Express Endpoint, MSI 00
 Capabilities: [100] Advanced Error Reporting
 Capabilities: [140] Device Serial Number 00-00-b1-93-a0-b6-5a-48
 Capabilities: [150] Latency Tolerance Reporting

[root@localhost ~]# uname -r 
3.14.4-200.fc20.x86_64

Thanks you. 




On Saturday, 7 June 2014 11:46 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
On 06/07/2014 12:59 PM, Powerful Notageek wrote:
> Here's lspci -nn
>
> 03:00.0 Network controller [0280]: MEDIATEK Corp. MT7630e 802.11bgn Wireless Network Adapter [14c3:7630]
>
> I have tried using the drivers available on RALink/Mediatek on a pretty recent kernel of Fedora20, didn't seem to work.
>
> Thanks

That PCI ID is not in the latest Ralink driver, which is essentially what will 
be in kernel 3.16.

Please try the following:

su -
modprobe -v rt2800pci
echo "14c3 7630" > /sys/bus/pci/drivers/rt2800pci/new_id

Does that yield a wireless lan device?




Larry
