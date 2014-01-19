Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61872 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaASK5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 05:57:35 -0500
Received: by mail-qa0-f46.google.com with SMTP id ii20so4751515qab.33
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jan 2014 02:57:34 -0800 (PST)
References: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com> <20140117100613.GD1425@redhat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20140117100613.GD1425@redhat.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com> (sfid-20140119_115739_340523_675C8ADF)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
From: Sergei Antonov <saproj@gmail.com>
Subject: Re: USB rt2x00 driver regression
Date: Sun, 19 Jan 2014 11:57:32 +0100
To: Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Am 17.01.2014 um 11:06 schrieb Stanislaw Gruszka <sgruszka@redhat.com>:
> 
>> On Tue, Jan 14, 2014 at 07:28:39PM +0100, Sergei Antonov wrote:
>> Hello!
>> I use a USB Wi-Fi adapter identified as follows.
>> 
>> usb 2-4: new high-speed USB device number 5 using ehci-pci
>> usb 2-4: New USB device found, idVendor=148f, idProduct=5370
>> usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> usb 2-4: Product: 802.11 n WLAN
>> usb 2-4: Manufacturer: Ralink
>> usb 2-4: SerialNumber: 1.0
>> usb 2-4: reset high-speed USB device number 5 using ehci-pci
>> ieee80211 phy3: rt2x00_set_rt: Info - RT chipset 5390, rev 0502 detected
>> ieee80211 phy3: rt2x00_set_rf: Info - RF chipset 5370 detected
>> 
>> It worked well with older kernels and does not with newer kernels.
>> Specifically it fails to find any AP when scanning.
>> The first bad commit is:
>> 
>> commit 76773f301f2210dcc20c466aebda7118062673eb
>> Author: Gabor Juhos <juhosg@openwrt.org>
>> Date:   Sat Aug 17 14:09:30 2013 +0200
>> 
>>    rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices
>> 
>>    According to the Ralink driver, there is an MCU
>>    command which can be used to send the frequency
>>    offset value directly to the USB device without
>>    going through the RFCSR writing sequence.
>> 
>>    Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
>>    driver.
>> 
>>    Reference:
>>      RTMPAdjustFrequencyOffset function in common/rt_rf.c
>> 
>>    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> 
>> After I removed this special USB handling (see the patch) the adapter
>> works again.
> 
> Thanks for bisecting! Could you check if following patch fixes the
> issue?

It does not fix the issue. The same broken behavior remains.