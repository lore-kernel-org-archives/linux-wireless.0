Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34343 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdCEPMz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Mar 2017 10:12:55 -0500
Received: by mail-wr0-f171.google.com with SMTP id l37so101248408wrc.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Mar 2017 07:12:49 -0800 (PST)
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
 <0cd984fd-3d26-15b2-03ce-69cdb7c0e434@googlemail.com>
 <1488479939.23555.1.camel@sipsolutions.net>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <37f7bd69-9a0e-7e49-7035-9e6f2cfef260@googlemail.com> (sfid-20170305_161258_955452_A8911D49)
Date: Sun, 5 Mar 2017 16:12:41 +0100
MIME-Version: 1.0
In-Reply-To: <1488479939.23555.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 02.03.2017 um 09:55 schrieb Johannes Berg:
> Would you mind filing a bug on bugzilla.kernel.org (and adding linuxwif
> i@intel.com as the assignee or at least in Cc)? I think we really ought
> to sort out the issues with the RTPM stuff.
Done: 
https://bugzilla.kernel.org/show_bug.cgi?id=194791

Am 02.03.2017 um 19:38 schrieb Johannes Berg:
>> I have another laptop with the same iwlwifi card (but newer HW
>> revision), a comparable Gentoo 
>> installation but with an unlocked UEFI. 
>> I'll play with it on the weekend and report back in case I find
>> anything different there. 
> 
> Ok. I *have* gotten this to work on some (old) laptops, but not
> generally.
> 
Well, at least with that other laptop I get *some* different result. 
Again, things only work with the RTPM stuff disabled (as expected). 
However, I do not get the dreaded:
"Device was reset during suspend"
on that machine!
Also, the machine stays connected to the AP if WoWLAN is activated and I enter suspend. 

However, it does not wake... To get any feedback, I tried something more complex. 

With tcp-mode, and using the small testing code I found from you somewhere on the web:
https://bugs.chromium.org/p/chromium/issues/detail?id=361435#c21
indeed I get:
"new client!"
after the machine has suspended. 
It even seems to receive the "WAKEUPNOW" when I close the server,
since it does not make further reconnection attempts after. 

So in general, it seems the Intel card stays powered and does what it should. 
The only issue is that the machine does not wake at all... 

My kernel log says:
[ 2751.003805] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[ 2751.656632] ACPI : EC: event blocked
[ 2753.817464] PM: suspend of devices complete after 2822.876 msecs
[ 2753.829438] PM: late suspend of devices complete after 11.970 msecs
[ 2753.829818] ACPI : EC: interrupt blocked
[ 2753.830343] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[ 2753.830345] iwlwifi 0000:03:00.0: System wakeup enabled by ACPI
[ 2753.830348] pcieport 0000:00:1c.3: System wakeup enabled by ACPI
[ 2753.830484] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[ 2753.830502] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[ 2753.842577] PM: noirq suspend of devices complete after 13.136 msecs
[ 2753.842853] ACPI: Preparing to enter system sleep state S3
[ 2753.843922] ACPI : EC: EC stopped
[ 2753.843923] PM: Saving platform NVS memory
[ 2753.843928] Disabling non-boot CPUs ...

[snip]

[ 2753.982917] ACPI: Waking up from system sleep state S3
[ 2753.983883] acpi LNXPOWER:01: Turning OFF
[ 2753.984044] ACPI : EC: interrupt unblocked
[ 2753.985895] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[ 2753.985912] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[ 2753.985917] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[ 2753.996565] PM: noirq resume of devices complete after 12.652 msecs
[ 2753.997093] PM: early resume of devices complete after 0.507 msecs
[ 2753.997205] ACPI : EC: event unblocked
[ 2753.997355] iwlwifi 0000:03:00.0: System wakeup disabled by ACPI
[ 2753.997369] ACPI : button: The lid device is not compliant to SW_LID.
[ 2753.997733] pcieport 0000:00:1c.3: System wakeup disabled by ACPI
[ 2753.997753] sd 0:0:0:0: [sda] Starting disk
[ 2753.997754] sd 5:0:0:0: [sdb] Starting disk
[ 2753.997886] rtc_cmos 00:02: System wakeup disabled by ACPI
[ 2754.007327] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled

So nothing which looks bad as far as I can see. 

Maybe this UEFI firmware is broken in a different, albeit "more stupid" way: 
Discarding ACPI wakeup from PCI devices, even though it leaves them powered? 

Cheers, 
Oliver
