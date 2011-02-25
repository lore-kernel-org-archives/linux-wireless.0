Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53793 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1BYHve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 02:51:34 -0500
Received: by pzk35 with SMTP id 35so212243pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 23:51:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110224200203.GB17412@elie>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
Date: Fri, 25 Feb 2011 13:21:32 +0530
Message-ID: <AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
From: Mohammed Shafi <shafi.ath9k@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>, Tony Houghton <h@realh.co.uk>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 25, 2011 at 1:32 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> (just cc-ing some people listed in MAINTAINERS)
> Hi,
>
> Tony Houghton wrote:
>
>> With 2.6.37 I can not use suspend on my Compaq/HP 311c (Intel Atom
>> N270/NVidia Ion LE). Originally the machine just kept locking up without
>> even blanking the display when I tried to suspend (using the GNOME menu
>> or by shutting the lid). I upgraded upower and gnome-power-manager etc
>> to experimental and after that the machine suspended OK but could not
>> resume. The backlight came on but the screen stayed blank and I could
>> not get to a console or anything with Alt+Fn.
> [...]
>> I tried replacing network-manager with wicd but that crashed the system
>> when it connected instead of when disconnected.
> [...]
>> While testing different kernels I found it would crash at different
>> times, usually before the screen turned off for suspending, but
>> sometimes it would crash on resuming and occasionally it locked up while
>> booting, but it's always a complete lock-up ie the keyboard is
>> completely responsive, including caps lock, the mouse won't move if the
>> display is still on, and the only way out is to hold down the power
>> button.
> [...]
>> I haven't tried looking in logs because the crashes are so severe I
>> don't think they'd be able to record anything useful. But using git
>> bisect I think I have tracked down the change that started causing this
>> problem:
>>
>> 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f is the first bad commit
>> commit 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f
>> Author: Vivek Natarajan <vnatarajan@atheros.com>
>> Date:   Mon Apr 5 14:48:04 2010 +0530
>>
>>     ath9k: Add support for newer AR9285 chipsets.
>>
>>     This patch adds support for a modified newer version of AR9285
>>     chipsets.
>>
>>     Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> The adaptor is an AR9285[1].
>
> That commit is based against v2.6.33 and was merged in v2.6.35-rc1
>
> $ git describe 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f
> v2.6.33-3523-g53bc7aa
> $ git name-rev --tags 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f
> 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f tags/v2.6.35-rc1~473^2~167^2~346
>
> Any ideas for tracking this down?

is this issue still reproducible ?
Apart from this reporting I have not seen any other  issues for AR9285.

>
> Thanks,
> Jonathan
>
> [1]
>> 84: udi = '/org/freedesktop/Hal/devices/pci_168c_2b'
>>   pci.device_protocol = 0  (0x0)  (int)
>>   pci.vendor = 'Atheros Communications Inc.'  (string)
>>   info.vendor = 'Atheros Communications Inc.'  (string)
>>   pci.product = 'AR9285 Wireless Network Adapter
>> (PCI-Express)'  (string) linux.sysfs_path =
>> '/sys/devices/pci0000:00/0000:00:15.0/0000:03:00.0'  (strin g)
>>   info.parent = '/org/freedesktop/Hal/devices/pci_10de_ac6'  (string)
>>   info.linux.driver = 'ath9k'  (string)
>>   pci.subsys_vendor = 'Hewlett-Packard Company'  (string)
>>   linux.hotplug_type = 2  (0x2)  (int)
>>   linux.subsystem = 'pci'  (string)
>>   info.subsystem = 'pci'  (string)
>>   info.product = 'AR9285 Wireless Network Adapter
>> (PCI-Express)'  (string) info.udi =
>> '/org/freedesktop/Hal/devices/pci_168c_2b'  (string)
>> pci.linux.sysfs_path =
>> '/sys/devices/pci0000:00/0000:00:15.0/0000:03:00.0'  (string)
>> pci.product_id = 43  (0x2b)  (int) pci.vendor_id = 5772  (0x168c)
>> (int) pci.subsys_product_id = 12352  (0x3040)  (int)
>> pci.subsys_vendor_id = 4156  (0x103c)  (int) pci.device_class = 2
>> (0x2)  (int) pci.device_subclass = 128  (0x80)  (int)
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
