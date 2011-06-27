Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46786 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab1F0KeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 06:34:02 -0400
Received: by gxk21 with SMTP id 21so1825462gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 03:34:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110224200203.GB17412@elie>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
Date: Mon, 27 Jun 2011 18:33:59 +0800
Message-ID: <BANLkTincVgqqQ4mb7idV=r19n+6kjQBahg@mail.gmail.com> (sfid-20110627_124538_278213_69E7481D)
Subject: Re: ath9k causes lockups since kernel 2.6.35
From: Adrian Chadd <adrian@freebsd.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <vnatarajan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

This article just popped up, wrt Linux APSM handling changes and some
rather negative effects..

http://www.phoronix.com/scan.php?page=article&item=linux_2638_aspm&num=2

The commit is: 2f671e2dbff6eb5ef4e2600adbec550c13b8fe72

>From the article:

"Evidently, some BIOSes have their ASPM support misconfigured and thus
problems can arise if the PCI-E link power mode is dropped on an
unsupported device. There are a few mentions of hangs and other issues
under Linux associated with this power management feature. It's not
really a surprise though that the BIOSes would be misconfigured given
all of the other BIOS-related problems under Linux and the once very
poor suspend-and-resume support due to all of the workarounds and
hacks that BIOS/hardware vendors have done to cater towards Microsoft
Windows power management. In this case, it seems a large number of
mobile systems are supporting ASPM but not properly advertising the
support via the standard BIOS ACPI FADT (Fixed ACPI Description
Table). Some Linux drivers even forcibly disable ASPM on Linux (e.g.
this kernel patch)."

Would someone please take charge of testing an unmodified ath9k (ie,
without my APSM disable fix) and try reverting this kernel patch?

Thanks,


Adrian

On 25 February 2011 04:02, Jonathan Nieder <jrnieder@gmail.com> wrote:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
