Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60453 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaHGSJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 14:09:00 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so11164615wib.16
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 11:08:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chris C <chris.a.cremer@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Carl9170fw loading error
Date: Thu, 07 Aug 2014 20:08:50 +0200
Message-ID: <1535534.mOj91phO2K@blech> (sfid-20140807_200905_413319_5DC5FD20)
In-Reply-To: <CAMKDnrkHOsLqXz5p8ZjLRL26N14ZByyM5XQ9b=6a0cB5pPmfqw@mail.gmail.com>
References: <CAMKDnrkHOsLqXz5p8ZjLRL26N14ZByyM5XQ9b=6a0cB5pPmfqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thursday, August 07, 2014 11:28:38 AM Chris C wrote:
> I am working on a project where I need to be able to modify a wireless
> adapter's firmware. I'm trying to use the Netgear WN111v2 with the
> carl9170 driver and firmware. Depending on the configurations I set
> when building the firmware, I get one of two errors when I try using
> the device: 1)failed to parse or 2)tainted. See below.
> 
> Here are the errors:
> 
> 1) If I select 'no' to all options during the autogen configuration,
> this is the error I get when inserting the device:
> 
> [505796.810127] usb 1-1.4: driver   API: 1.9.4 2011-08-15 [1-1]
> [505796.810132] usb 1-1.4: firmware API: 1.9.9 2013-10-25
> [505796.810135] usb 1-1.4: Unprotected firmware image.
> [505796.810138] usb 1-1.4: firmware does support mandatory features.
> [505796.810141] usb 1-1.4: failed to parse firmware (-125).

It's possible to build the firmware without support for
the radio chip (The radio support is quite big and not 
needed for firmwares which (load) test the usb phy, ...).
So, this is expected (as the driver can not initialize the
radio).
 
> 2) If I select 'yes' to all options except the experimental
> extensions, this is the error I get when inserting the device:
> [...]
> [504006.523276] ------------[ cut here ]------------
> [504006.523286] WARNING: at
> /build/buildd/linux-3.2.0/net/wireless/core.c:436
> wiphy_verify_combinations+0x213/0x240 [cfg80211]()
> [504006.523289] Hardware name: OptiPlex 790
> [504006.523291] Modules linked in: carl9170(O) ... mei(C)
> [504006.523338] Pid: 30107, comm: firmware/carl91 Tainted: G        WC
> O 3.2.0-67-generic #101-Ubuntu
> [504006.523434] ---[ end trace df0f0cb5a9397534 ]---

This has been fixed by: "carl9170: Only specify interface combinations if
more than one interface is possible". The patch is dated 2012-12-17, your
driver is from 2011-08-15. If you are interested (not necessary), you can
use the latest wireless-drivers as part of the Linux kernel backports
project [0].

The "Crap" flag is set by mei module.
 
> Also, the adapter works when I use the firmware from here:
> http://wireless.kernel.org/en/users/Drivers/carl9170#Firmware_binary

You didn't specify what you are working on, But if you are just 
interested in the default options (which were used to build the
wiki firmware) you can just hit <Enter> instead of answering
the Y/N prompt for every option.

[Note: You have to delete the .config in the project's root
directory first. Otherwise the configuration utility will pick
the previous option instead of starting over].

> Please let me know if there is more useful information I should post.

Regards

Christian

[0] https://backports.wiki.kernel.org/index.php/Documentation

BTW: Thanks, I updated the firmware's README to include a sentence
about that. The "default" option is not that obvious.
