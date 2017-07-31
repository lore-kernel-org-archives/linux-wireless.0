Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38363 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbdGaU2x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 16:28:53 -0400
Received: by mail-wm0-f51.google.com with SMTP id m85so487497wma.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2017 13:28:53 -0700 (PDT)
Subject: Re: AP mode with Broadcom 4330
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20170728141503.GU31807@n2100.armlinux.org.uk>
 <20170728174930.GA3313@n2100.armlinux.org.uk>
 <2c5d4ef0-9b87-0084-c032-c5614275dd56@broadcom.com>
 <20170731125902.GW31807@n2100.armlinux.org.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6f701504-0315-a49a-58d9-5cc9292d7d77@broadcom.com> (sfid-20170731_222857_045074_6AA64AB3)
Date: Mon, 31 Jul 2017 22:28:50 +0200
MIME-Version: 1.0
In-Reply-To: <20170731125902.GW31807@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31-07-17 14:59, Russell King - ARM Linux wrote:
> On Fri, Jul 28, 2017 at 09:50:21PM +0200, Arend van Spriel wrote:
>> I was going to agree with you, but having second thoughts. There are
>> actually two use-cases that need to be handled properly. The regular AP
>> case and the MBSS case. In case of MBSS the initial AP interface will
>> have mbss set to false and subsequent AP interfaces will have mbss set
>> to true, but in firmware this has to be configured inverted. That is
>> what the code above is doing. However, this indeed breaks the regular AP
>> case for firmwares that abuse that setting for testing purposes (no idea
>> why that is in a released firmware).
> 
> Maybe detect the BCRM_TEST_SSID string in the firmware file (as it's
> broken up amongst other data, it's not trivial) and disable mbss for
> such firmware?  Alternatively, maybe blacklist mbss for some firmware
> versions?

Well. It seem 43362 chip also had this and we disabled mbss for that
chipset. So we may do that for 4330 as well.

> Do the firmware versions that include this "abuse" actually have
> functional mbss?

Digging through our internal bug database I found a remark that
BRCM_TEST_SSID showing up means mbss is not functional.

> There's also the obvious question: which firmware is recommended for
> the 4330?

We tend to rely on what is released to AOSP as our team does not have
the bandwidth to go through the release process. I checked and it is
still the same so matches what is in linux-firmware.

Regards,
Arend
