Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47606 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754110AbdKNXHc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 18:07:32 -0500
Date: Tue, 14 Nov 2017 23:07:24 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: AP mode with Broadcom 4330
Message-ID: <20171114230723.GB31757@n2100.armlinux.org.uk> (sfid-20171115_000738_403216_B0982FCE)
References: <20170728141503.GU31807@n2100.armlinux.org.uk>
 <20170728174930.GA3313@n2100.armlinux.org.uk>
 <2c5d4ef0-9b87-0084-c032-c5614275dd56@broadcom.com>
 <20170731125902.GW31807@n2100.armlinux.org.uk>
 <6f701504-0315-a49a-58d9-5cc9292d7d77@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6f701504-0315-a49a-58d9-5cc9292d7d77@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend,

Did this bug ever get fixed, or are 4330's still ending up advertising
BCRM_TEST_SSID when they're put into AP mode with mainline kernels?

It would be good to know whether I can drop my patch for this from my
kernel tree and still have working AP mode.

Thanks.

On Mon, Jul 31, 2017 at 10:28:50PM +0200, Arend van Spriel wrote:
> On 31-07-17 14:59, Russell King - ARM Linux wrote:
> > On Fri, Jul 28, 2017 at 09:50:21PM +0200, Arend van Spriel wrote:
> >> I was going to agree with you, but having second thoughts. There are
> >> actually two use-cases that need to be handled properly. The regular AP
> >> case and the MBSS case. In case of MBSS the initial AP interface will
> >> have mbss set to false and subsequent AP interfaces will have mbss set
> >> to true, but in firmware this has to be configured inverted. That is
> >> what the code above is doing. However, this indeed breaks the regular AP
> >> case for firmwares that abuse that setting for testing purposes (no idea
> >> why that is in a released firmware).
> > 
> > Maybe detect the BCRM_TEST_SSID string in the firmware file (as it's
> > broken up amongst other data, it's not trivial) and disable mbss for
> > such firmware?  Alternatively, maybe blacklist mbss for some firmware
> > versions?
> 
> Well. It seem 43362 chip also had this and we disabled mbss for that
> chipset. So we may do that for 4330 as well.
> 
> > Do the firmware versions that include this "abuse" actually have
> > functional mbss?
> 
> Digging through our internal bug database I found a remark that
> BRCM_TEST_SSID showing up means mbss is not functional.
> 
> > There's also the obvious question: which firmware is recommended for
> > the 4330?
> 
> We tend to rely on what is released to AOSP as our team does not have
> the bandwidth to go through the release process. I checked and it is
> still the same so matches what is in linux-firmware.
> 
> Regards,
> Arend

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
