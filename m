Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61302 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaHHPTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 11:19:34 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so1188484wiv.7
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 08:19:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1535534.mOj91phO2K@blech>
References: <CAMKDnrkHOsLqXz5p8ZjLRL26N14ZByyM5XQ9b=6a0cB5pPmfqw@mail.gmail.com>
	<1535534.mOj91phO2K@blech>
Date: Fri, 8 Aug 2014 11:19:32 -0400
Message-ID: <CAMKDnrnZweYxca6UxKhTa9B-kMfFmea2EN=qSypkdA+8mX=n-A@mail.gmail.com> (sfid-20140808_171955_072254_CB232093)
Subject: Re: Carl9170fw loading error
From: Chris C <chris.a.cremer@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 7 August 2014 14:08, Christian Lamparter <chunkeey@googlemail.com> wrote:
> Hi,
>
> On Thursday, August 07, 2014 11:28:38 AM Chris C wrote:
>> I am working on a project where I need to be able to modify a wireless
>> adapter's firmware. I'm trying to use the Netgear WN111v2 with the
>> carl9170 driver and firmware. Depending on the configurations I set
>> when building the firmware, I get one of two errors when I try using
>> the device: 1)failed to parse or 2)tainted. See below.
>>
>> Here are the errors:
>>
>> 1) If I select 'no' to all options during the autogen configuration,
>> this is the error I get when inserting the device:
>>
>> [505796.810127] usb 1-1.4: driver   API: 1.9.4 2011-08-15 [1-1]
>> [505796.810132] usb 1-1.4: firmware API: 1.9.9 2013-10-25
>> [505796.810135] usb 1-1.4: Unprotected firmware image.
>> [505796.810138] usb 1-1.4: firmware does support mandatory features.
>> [505796.810141] usb 1-1.4: failed to parse firmware (-125).
>
> It's possible to build the firmware without support for
> the radio chip (The radio support is quite big and not
> needed for firmwares which (load) test the usb phy, ...).
> So, this is expected (as the driver can not initialize the
> radio).
>
>> 2) If I select 'yes' to all options except the experimental
>> extensions, this is the error I get when inserting the device:
>> [...]
>> [504006.523276] ------------[ cut here ]------------
>> [504006.523286] WARNING: at
>> /build/buildd/linux-3.2.0/net/wireless/core.c:436
>> wiphy_verify_combinations+0x213/0x240 [cfg80211]()
>> [504006.523289] Hardware name: OptiPlex 790
>> [504006.523291] Modules linked in: carl9170(O) ... mei(C)
>> [504006.523338] Pid: 30107, comm: firmware/carl91 Tainted: G        WC
>> O 3.2.0-67-generic #101-Ubuntu
>> [504006.523434] ---[ end trace df0f0cb5a9397534 ]---
>
> This has been fixed by: "carl9170: Only specify interface combinations if
> more than one interface is possible". The patch is dated 2012-12-17, your
> driver is from 2011-08-15. If you are interested (not necessary), you can
> use the latest wireless-drivers as part of the Linux kernel backports
> project [0].
>
> The "Crap" flag is set by mei module.
>
>> Also, the adapter works when I use the firmware from here:
>> http://wireless.kernel.org/en/users/Drivers/carl9170#Firmware_binary
>
> You didn't specify what you are working on, But if you are just
> interested in the default options (which were used to build the
> wiki firmware) you can just hit <Enter> instead of answering
> the Y/N prompt for every option.
>
> [Note: You have to delete the .config in the project's root
> directory first. Otherwise the configuration utility will pick
> the previous option instead of starting over].


Success! It works. Thank you!
I deleted .config then ran autogen.sh and hit enter for each prompt
and now it works.


>
>> Please let me know if there is more useful information I should post.
>
> Regards
>
> Christian
>
> [0] https://backports.wiki.kernel.org/index.php/Documentation
>
> BTW: Thanks, I updated the firmware's README to include a sentence
> about that. The "default" option is not that obvious.


Now for some follow up questions.

I am trying to very quickly stop/interrupt the transmission of packets
then be able to restart the transmission.
By 'very quickly' I mean faster then the time it takes to transmit a
packet. So if a packet is being transmitted, the transmission should
be interrupted before the packet is finished transmitting.
I have tried setting the AR9170_PHY_REG_ACTIVE register to 0 then back
to 1. Is there a better way?

I am also trying to establish communications between the firmware and
the driver so that the firmware can output some timing information.
I have tried passing information through the registers. From the
driver I use the functions carl9170_read_reg and carl9170_write_reg.
>From the firmware I use the functions get and set.
The problem is that reading and writing to registers often crashes the computer.
What's the better way of doing this?


Best,
Chris
