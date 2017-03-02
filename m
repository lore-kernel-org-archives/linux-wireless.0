Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36286 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752299AbdCBSus (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 13:50:48 -0500
Received: by mail-wm0-f66.google.com with SMTP id v190so7970929wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Mar 2017 10:50:29 -0800 (PST)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
 <1487938277.2540.13.camel@sipsolutions.net>
 <5d69cf9b-1113-835a-8423-3796586eae20@googlemail.com>
 <1487965047.30601.2.camel@sipsolutions.net>
 <6337fa40-adcc-b889-1842-16e0f316ea3e@googlemail.com>
 <1488444909.8390.11.camel@sipsolutions.net>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <0cd984fd-3d26-15b2-03ce-69cdb7c0e434@googlemail.com> (sfid-20170302_195134_914413_D4035B62)
Date: Thu, 2 Mar 2017 19:20:37 +0100
MIME-Version: 1.0
In-Reply-To: <1488444909.8390.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 02.03.2017 um 09:55 schrieb Johannes Berg:
>> The problem is that it seems I cannot actually wake the machine
>> anymore afterwards... 
>> While in the suspend procedure, I see:
>> [12385.893568] iwlwifi 0000:0a:00.0: System wakeup enabled by ACPI
>> as expected, I could neither get it to make a tcp connection in tcp-
>> connection mode,
>> nor could I wake the machine via magic packet in magic-packet mode. 
>>
>> Could that be some hardware / system firmware limitation, e.g. if my
>> UEFI does not support actually powering
>> the WiFi hardware if I am in S3?
> 
> Yes. Does it print something to that effect at resume time? I think it
> should.
Oh yes - I totally missed that since it came quite late in the resume cycle:

[12386.085899] iwlwifi 0000:0a:00.0: System wakeup disabled by ACPI
[12386.088449] iwlwifi 0000:0a:00.0: Device was reset during suspend

I guess the "Device was reset during suspend" means my firmware did something uncool
like cutting the power to it (it's a laptop, but I suspended with power supply staying connected). 
UEFI options are very limited, so I guess I'm just out of luck with this hardware. 

I have another laptop with the same iwlwifi card (but newer HW revision), a comparable Gentoo 
installation but with an unlocked UEFI. 
I'll play with it on the weekend and report back in case I find anything different there. 

>> At least, the suspend problem seems to be clearly related to some
>> path only used if CONFIG_IWLWIFI_PCIE_RTPM is on. 
> 
> Would you mind filing a bug on bugzilla.kernel.org (and adding linuxwif
> i@intel.com as the assignee or at least in Cc)? I think we really ought
> to sort out the issues with the RTPM stuff.
Good idea, I'll do that over the weekend. 

Thanks a lot for the support! 
	Oliver

> 
> johannes
> 
