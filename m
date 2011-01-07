Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50357 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab1AGQT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 11:19:28 -0500
Received: by fxm20 with SMTP id 20so17062346fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 08:19:27 -0800 (PST)
Message-ID: <4D273D16.7080008@lwfinger.net>
Date: Fri, 07 Jan 2011 10:19:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Damian Minkov <damencho@sip-communicator.org>
CC: sedat.dilek@gmail.com, linux-wireless@vger.kernel.org,
	chaoming_li <chaoming_li@realsil.com.cn>,
	'georgia' <georgia@realtek.com>
Subject: Re: Question about ep-n8508
References: <AANLkTimekYjYh7uZ3enOQ+zX2_dpA25Zy0aATCDzw521@mail.gmail.com> <AANLkTimYBb-hqWWtPpQVnVQ2ifemQbAvOBnKSUxM_jsJ@mail.gmail.com> <AANLkTik8nfAFF=OhG1EqzJYkYMh+ds1igRgngLArVswC@mail.gmail.com>
In-Reply-To: <AANLkTik8nfAFF=OhG1EqzJYkYMh+ds1igRgngLArVswC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 04:32 AM, Damian Minkov wrote:
> Hi,
> 
> On Fri, Jan 7, 2011 at 11:11 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> On Fri, Jan 7, 2011 at 9:06 AM, Damian Minkov
>> <damencho@sip-communicator.org> wrote:
>>> Hi,
>>>
>>> I recently bought the device EDUP ep-n8508 but I have problems running
>>> it under Ubuntu 10.10, kernel: 2.6.35-24-generic x86_64.
>>> I tried with the drivers provided on the CD coming with the device
>>> (rtl8192CU_linux_v2.0.939.20100726) have no problem compiling and
>>> installing. But after loading the module no network device appears and
>>> a lot of "usb write TimeOut!" in the messages.
>>> Then I tried with latest driver edition from realtek website -
>>> rtl8192CU_linux_v2.0.1212.20101208. Again with same result.
>>> Here is all the output: http://pastebin.com/7xhkzYNC.
>>> I saw there is a similar thread, with similar problems "Question about
>>> Edimax 7811Un", but as I'm new to the list didn't manage to continue
>>> that thread.
>>>
>>> Seems a problem with amd64 systems. Is there any workaround? Anything
>>> I can further test to help figuring this out?
>>>
>>> Thanks in advance
>>> damencho
>>
>> First of all, please do not refer to pastebin-URLs as they have a
>> limited life-cycle.
>> A full dmesg and an output of lspci is much more appreciated, so
>> interested people can look at it.
>>
>> - Sedat -
>>
> 
> sorry for the pastebin, here are lspci and dmesg prints:
> 
> # lspci
> 00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
> Controller Hub (rev 03)

The output of lspci is useless for a USB device. Use lsusb instead.

> [27549.583825] 8192cu: USB_SPEED_HIGH
> [27549.584814] Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.
> [27549.585468] EEPROM type is E-FUSE
> [27549.585473] ====> ReadAdapterInfo8192C
> [27549.585573] Boot from EFUSE, Autoload Success !
> [27549.592954] rtw_efuse_get_max_phy_size...eeprompriv.efuse_phy_max_size(504)
> [27550.006456] EEPROMVID = 0x0bda
> [27550.006463] EEPROMPID = 0x8176

As you found, the 64-bit version of the driver for the device with USB ID
0bda:8176 does not work. The 32-bit one is fine. I did some work on it and found
many of the problems; however, the driver still did not work. When I contacted
Realtek about the issue, I was told that they were working on a mac80211-based
driver that should be available soon. On that news, I stopped work on the old
driver. That was a few months ago, but so far I have not seen any new code. When
they are ready to release it, at least to me, I have an Edimax 7811Un ready for
testing.

Larry
