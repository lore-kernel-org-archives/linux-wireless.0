Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63850 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0KRHjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 02:39:48 -0500
Received: by qwf7 with SMTP id 7so259726qwf.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 23:39:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101117221127.GB3851@suse.de>
References: <20101116200420.GA10793@kroah.com>
	<1289980726-28706-1-git-send-email-mike.rapoport@gmail.com>
	<20101117211035.GA2442@kroah.com>
	<AANLkTi=p_iH32zads+9RwQGY+m7JK+FTmhBTth_x9ouK@mail.gmail.com>
	<20101117221127.GB3851@suse.de>
Date: Thu, 18 Nov 2010 09:39:47 +0200
Message-ID: <AANLkTimcEZfzJAaR4NEVGrs7xT0QxhuCa8ZgcCzknbF6@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
 controller binding
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 12:11 AM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Nov 18, 2010 at 12:00:16AM +0200, Mike Rapoport wrote:
>> On Wed, Nov 17, 2010 at 11:10 PM, Greg KH <greg@kroah.com> wrote:
>> > On Wed, Nov 17, 2010 at 09:58:46AM +0200, Mike Rapoport wrote:
>> >> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
>> >> ---
>> >>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  229 ---------------------
>> >>  1 files changed, 0 insertions(+), 229 deletions(-)
>> >
>> > Wait, is this really ok code to be removing from the driver?
>> >
>> > Brett and Henry, any objections to this?
>> >
>> > Mike, why do you think this is ok to remove?  Is it because no one is
>> > ever calling this even for both types of config for this driver?
>>
>> There's a lot of code in the brcmfmac part of the driver that tries to
>> re-implement SDIO stack. In particular, the code removed by this patch
>> registers a pci_driver for SDIO controller and then the brcmfmac
>> driver accesses the WiFi device attached to that SDIO controller by
>> means of custom re-implementation of SDHC.
>
> Ok, so even with this patch, it will still work properly in the SDIO
> mode?

The driver binds to the device and it is able to download firmware and
initialize the network interface.

> Have you been able to test this?

I was never able to have the radio working properly with this driver,
both before and after my patches. However, the patches do not affect
the driver initialization and firmware download.

> Brett, Henry, I would like to get your ack on this before applying it.
>
> thanks,
>
> greg k-h
>



-- 
    Sincerely Yours,
        Mike.
