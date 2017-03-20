Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35993 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932093AbdCTQrD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 12:47:03 -0400
Received: by mail-oi0-f51.google.com with SMTP id r203so20957833oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 09:46:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20064021-fcca-4092-e6ec-5ce7f964a0c1@lwfinger.net>
References: <CADND2bqVLdSmmY=RG7m8r2maWyc7yGgvKUO4O4YGPLVnMx0pqg@mail.gmail.com>
 <34e317ae-a112-79bc-41ef-c18433e8cc49@lwfinger.net> <CADND2bprCVNThAWVp-De7W3uRvKNDxGrxEond2ANZ+=2akKB_Q@mail.gmail.com>
 <20064021-fcca-4092-e6ec-5ce7f964a0c1@lwfinger.net>
From: Fernanda Vejar <fvejar85@gmail.com>
Date: Mon, 20 Mar 2017 13:46:56 -0300
Message-ID: <CADND2br8jjW1jmuW3e4Jg4CxVaHCDEs2M4PHNtUuh9uMaC4BCQ@mail.gmail.com> (sfid-20170320_174735_336568_4FD59768)
Subject: Re: Wireless failed
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

thank you very much for your fast answer.

Buy running "modinfo iwlwifi":
filename:
/lib/modules/3.13.0-112-lowlatency/updates/drivers/net/wireless/iwlwifi/iwlwifi.ko
version:        iwlwifi-stack-public:release/LinuxCore5:3714:27076532
license:        GPL
author:         Copyright(c) 2003- 2014 Intel Corporation <ilw@linux.intel.com>
version:        in-tree:d
description:    Intel(R) Wireless WiFi driver for Linux
firmware:       iwlwifi-7265-8.ucode
firmware:       iwlwifi-3160-8.ucode
firmware:       iwlwifi-7260-8.ucode
firmware:       iwlwifi-8000-8.ucode
srcversion:     6E29C5B96E10698E38DC01F
....

According to the reference
(https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware) I
need  the iwlwifi-2030-6.ucode. I tried to install it previously as a
first step, but It didn't work. I don't understand what I did wrong.

Fernanda.

2017-03-20 12:50 GMT-03:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 03/20/2017 10:10 AM, Fernanda Vejar wrote:
>>
>> Hello Larry,
>>
>> thank you very much for your response.
>>
>> I'm using "Trisquel 7.0 LTS Belenos" since a few days.
>> My kernel version is acoording to "uname -r" : "3.13.0-112-lowlatency".
>> By "lspci --n"n I have found : "01:00.0 Network controller [0280]:
>> Intel Corporation Centrino Wireless-N 2230 [8086:0887] (rev c4)".
>> There is no evidence of iwlwifi by running" lsmod".
>> According to "dmesg | less", I've found: "Linux version
>> 3.13.0-112-lowlatency (pbuilder@devel.trisquel.info) (gcc version
>> 4.8.4 (Ubuntu 4.8.4-2ubuntu1~14.04.3) ) #159+7.0trisquel2 SMP PREEMPT
>> Mon Mar 13 13:58:08 UTC 2017 (Ubuntu
>> 3.13.0-112.159+7.0trisquel2-lowlatency 3.13.11-ckt39-gnu)", I think it
>> could clarify a little more. But I can't see more relevant issue given
>> by this command.
>>
>> I don't know if the problem is to be solved. Maybe I should try a new
>> distro.
>
>
> Kernel 3.13 is quite old; however according to
> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware, the
> driver for the 2230 has been in the kernel since version 3.2. That reference
> also tells you what firmware is needed.
>
> To resolve this, first check that the driver is available. If the command
> "modinfo iwlwifi" returns an ERROR, then your kernel configuration does not
> contain the driver. You will also need iwldvm to be configured.
>
> Larry
>
>
