Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50462 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab0KQWAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 17:00:17 -0500
Received: by qwi2 with SMTP id 2so107037qwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 14:00:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101117211035.GA2442@kroah.com>
References: <20101116200420.GA10793@kroah.com>
	<1289980726-28706-1-git-send-email-mike.rapoport@gmail.com>
	<20101117211035.GA2442@kroah.com>
Date: Thu, 18 Nov 2010 00:00:16 +0200
Message-ID: <AANLkTi=p_iH32zads+9RwQGY+m7JK+FTmhBTth_x9ouK@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO
 controller binding
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 11:10 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Nov 17, 2010 at 09:58:46AM +0200, Mike Rapoport wrote:
>> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
>> ---
>>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  229 ---------------------
>>  1 files changed, 0 insertions(+), 229 deletions(-)
>
> Wait, is this really ok code to be removing from the driver?
>
> Brett and Henry, any objections to this?
>
> Mike, why do you think this is ok to remove?  Is it because no one is
> ever calling this even for both types of config for this driver?

There's a lot of code in the brcmfmac part of the driver that tries to
re-implement SDIO stack. In particular, the code removed by this patch
registers a pci_driver for SDIO controller and then the brcmfmac
driver accesses the WiFi device attached to that SDIO controller by
means of custom re-implementation of SDHC.

> thanks,
>
> greg k-h
>



-- 
    Sincerely Yours,
        Mike.
