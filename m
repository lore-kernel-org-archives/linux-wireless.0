Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57795 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab2ENUJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 16:09:36 -0400
Received: by qcro28 with SMTP id o28so3676928qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 13:09:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4FB15995.80205@fold.natur.cuni.cz>
References: <4FA7E041.1070108@fold.natur.cuni.cz>
	<4FA821F5.8090203@fold.natur.cuni.cz>
	<CA+icZUWwy6A5y8EM0b=xEwzP2gqo4mY_bUdUAG8NOVajAHzYvg@mail.gmail.com>
	<4FA835F0.2050003@fold.natur.cuni.cz>
	<4FB15995.80205@fold.natur.cuni.cz>
Date: Mon, 14 May 2012 22:09:34 +0200
Message-ID: <CA+icZUVKZCNjjyX7+YgoRmPHwU=UL+d6ddy-VbrQ04u5JnG_zA@mail.gmail.com> (sfid-20120514_220944_166069_A67C44D3)
Subject: Re: 3.4-rc5: Oops in run_timer_softirq()
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2012 at 9:14 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> Hi Sedat,
>  I still get the Oops with 3.4-rc7 when repeatedly turning on and off wifi device
> (Fn+F2). I did download the v6 firmware and placed it manually.
>

Dunno if I have a key-combination to turn wifi on/off :-)

> [   13.119591] iwlwifi 0000:09:00.0: loaded firmware version 18.168.6.1

Same fw-version used here on 6230,

>
>  I did not download the patches. Are they not in 3.4-rc7 yet? And do I need them
> if I have the v6 firmware files in /lib/firmware/?

Both patches landed in -rc7.

- Sedat -

> Thanks,
> Martin
>
> Martin Mokrejs wrote:
>> Sedat Dilek wrote:
>>> On Mon, May 7, 2012 at 9:26 PM, Martin Mokrejs
>>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>> Hmm, linux-3.4-rc6 tells me some news about my v5 firmware. Will try to upgrade. The ACPI message
>>>> is not new.
>>>>
>>>> [   11.008565] ACPI Warning: 0x000000000000f040-0x000000000000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
>>>> [   11.008571] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>>> [   11.936175] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
>>>> [   11.936177] Copyright(c) 2003-2012 Intel Corporation
>>>> [   11.936364] iwlwifi 0000:09:00.0: pci_resource_len = 0x00002000
>>>> [   11.936366] iwlwifi 0000:09:00.0: pci_resource_base = ffffc90006684000
>>>> [   11.936368] iwlwifi 0000:09:00.0: HW Revision ID = 0x34
>>>> [   11.936462] iwlwifi 0000:09:00.0: irq 53 for MSI/MSI-X
>>>> [   12.058300] iwlwifi 0000:09:00.0: request for firmware file 'iwlwifi-6000g2b-6.ucode' failed.
>>>> [   12.137737] usb 1-1.5: usb auto-suspend, wakeup 0
>>>> [   12.158653] iwlwifi 0000:09:00.0: Firmware has old API version, expected v6, got v5.
>>>> [   12.158655] iwlwifi 0000:09:00.0: New firmware can be obtained from http://www.intellinuxwireless.org/.
>>>> [   12.158657] iwlwifi 0000:09:00.0: loaded firmware version 17.168.5.2 build 35905
>>>> [   12.158759] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEBUG enabled
>>>> [   12.158761] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
>>>> [   12.158763] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
>>>> [   12.158764] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
>>>> [   12.158766] iwlwifi 0000:09:00.0: CONFIG_IWLWIFI_P2P disabled
>>>> [   12.158768] iwlwifi 0000:09:00.0: Detected Intel(R) Centrino(R) Wireless-N 1030 BGN, REV=0xB0
>>>> [   12.158816] iwlwifi 0000:09:00.0: L1 Disabled; Enabling L0S
>>>> [   12.175752] iwlwifi 0000:09:00.0: device EEPROM VER=0x71a, CALIB=0x6
>>>> [   12.175754] iwlwifi 0000:09:00.0: Device SKU: 0x150
>>>> [   12.175756] iwlwifi 0000:09:00.0: Valid Tx ant: 0x1, Valid Rx ant: 0x3
>>>> [   12.175768] iwlwifi 0000:09:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
>>>>
>>>> Martin
>>>>
>>>
>>> What about a new subject :-)?
>>
>> Well, I just thought that maybe it is related to the v5 firmware, but no, it is not.
>> I did not want to report the v5 vs. v6 line. This is really about the Oops. ;)
>>
>>> Known issue - Check for these patches (pending in
>>> (net.git|wireless.git)#master):
>>>
>>>       iwlwifi: use correct released ucode version
>>>       iwlwifi: use 6000G2B for 6030 device series
>>
>> So when I already updated the firmware manually I do not these two patches, right?
>>
>> Martin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
