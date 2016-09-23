Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34987 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757839AbcIWM2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 08:28:03 -0400
Received: by mail-wm0-f48.google.com with SMTP id l132so28698081wmf.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2016 05:28:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHdg3xYyEVAYEQimkjsPEUTcLD57KjcFYnkwbaPS0hHDmTZXbA@mail.gmail.com>
References: <CAF3cwD2jkXTbZAw7YPE2mDyZKgEUCdWOXDAqkt6zLbXLV6uT9g@mail.gmail.com>
 <CA+BoTQk91bgNVB0MA2TGuDhSr-fXtggysP+wTm9-V1XO6J314A@mail.gmail.com>
 <CAHdg3xa4Z0=WVMDtHv2KLtzAgB8fyiuefEodKZwUb=jjmNyppg@mail.gmail.com> <CAHdg3xYyEVAYEQimkjsPEUTcLD57KjcFYnkwbaPS0hHDmTZXbA@mail.gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 23 Sep 2016 14:28:01 +0200
Message-ID: <CA+BoTQm4fZdXLHAN4Lhv_OKLT1bo=B7=E8B-3scnZC1SL8C9iw@mail.gmail.com> (sfid-20160923_142812_834630_8AA7F1FD)
Subject: Re: ath10k mesh mode issue
To: Matteo Grandi <iu5bdp@gmail.com>
Cc: Matteo Grandi <grn.matteo@gmail.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 September 2016 at 18:27, Matteo Grandi <iu5bdp@gmail.com> wrote:
> Hi Michal,
> thanks for the reply:
> I've already loaded the ath10k_core with the rowmode parameters, this
> is the modinfo result:
> root@Tam:~# modinfo ath10k_core
> filename:
> /lib/modules/3.14.48-g408ccb9/kernel/drivers/net/wireless/ath/ath10k/ath1=
0k_core.ko
> license:        Dual BSD/GPL
> description:    Core module for QCA988X PCIe devices.
> author:         Qualcomm Atheros
> srcversion:     407804E6D5A63597F137E9B
> depends:        mac80211,cfg80211,compat,ath
> vermagic:       3.14.48-g408ccb9 SMP mod_unload modversions ARMv7 p2v8
> parm:           debug_mask:Debugging mask (uint)
> parm:           uart_print:Uart target debugging (bool)
> parm:           skip_otp:Skip otp failure for calibration in testmode (bo=
ol)
> parm:           cryptmode:Crypto mode: 0-hardware, 1-software (uint)
> parm:           rawmode:Use raw 802.11 frame datapath (bool)
[...]
> I've loaded adding the line ath10k_core rawmode=3D1 to the file etc/modul=
es

Hmm... are you sure the module is actually loaded with the parameter?

You can check it with:

 grep . /sys/module/ath10k*/parameters/*


Micha=C5=82
