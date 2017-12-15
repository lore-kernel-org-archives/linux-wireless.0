Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:40846 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756125AbdLOVId (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Dec 2017 16:08:33 -0500
Received: by mail-io0-f195.google.com with SMTP id v186so3994418iod.7
        for <linux-wireless@vger.kernel.org>; Fri, 15 Dec 2017 13:08:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <07a73398-fbc8-7c84-9512-edff9cbc5e89@lwfinger.net>
References: <CADBo=zzcMzFCOdbbskpPStJZdt4s7wdavPefqo9iHi_zVSzJTg@mail.gmail.com>
 <07a73398-fbc8-7c84-9512-edff9cbc5e89@lwfinger.net>
From: James Hemsing <jhemsing@gmail.com>
Date: Fri, 15 Dec 2017 16:08:32 -0500
Message-ID: <CADBo=zzrLC=yYyPrJ18RFU0OXN2nEnB6X1pH6GBZDnKC0kjo6Q@mail.gmail.com> (sfid-20171215_220847_772528_83F6BA32)
Subject: Re: rtl8723bu support on Complex 11t
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ha! I didn't realize those were two separate drivers. Blacklisting
rtl8xxxu made it work consistently. The throughput is still about 1/2
what it is in Windows 10, but at least it works! Thanks.

On Mon, Dec 11, 2017 at 9:21 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 12/11/2017 06:59 PM, James Hemsing wrote:
>>
>> Hello,
>>
>> I have a Complex 11t tablet with this wireless card on USB. The kernel
>> driver supports it, but even at its best, it doesn't work at full
>> speed and frequently loses connections, whereas Windows 10 doesn't
>> have any problems. I'd be happy to test and debug code, and provide
>> whatever help I can to improve the driver for this device. Here is
>> some system information. The kernel I'm currently using is version
>> 4.13.0 on Ubuntu 17.10.
>>
>> Thanks,
>> James
>>
>> [    4.031513] Bluetooth: hci0: rtl: examining hci_ver=06 hci_rev=000b
>> lmp_ver=06 lmp_subver=8723
>> [    4.031515] Bluetooth: hci0: rtl: loading rtl_bt/rtl8723b_config.bin
>> [    4.032132] bluetooth hci0: Direct firmware load for
>> rtl_bt/rtl8723b_config.bin failed with error -2
>> [    4.032136] Bluetooth: hci0: rtl: loading rtl_bt/rtl8723b_fw.bin
>> [    4.160515] usb 1-6: rtl8723bu_parse_efuse: dumping efuse (0x200
>> bytes):
>> [    4.160667] usb 1-6: RTL8723BU rev E (SMIC) 1T1R, TX queues 3,
>> WiFi=1, BT=1, GPS=0, HI PA=0
>> [    4.160670] usb 1-6: RTL8723BU MAC: 7c:c7:09:69:b6:3a
>> [    4.160674] usb 1-6: rtl8xxxu: Loading firmware
>> rtlwifi/rtl8723bu_nic.bin
>> [    5.038493] 8723bu: loading out-of-tree module taints kernel.
>> [    5.039092] 8723bu: module verification failed: signature and/or
>> required key missing - tainting kernel
>
>
> Why are you loading BOTH rtl8xxxu and 8723bu? The conflict between them will
> cause all kinds of problems.
>
> Larry
>
>
