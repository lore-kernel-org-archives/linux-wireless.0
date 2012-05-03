Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33692 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab2ECLrE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 07:47:04 -0400
Message-ID: <4FA2702C.8060803@hauke-m.de> (sfid-20120503_134709_127378_6CD8D83E)
Date: Thu, 03 May 2012 13:46:52 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de> <4F9CF839.1040401@broadcom.com> <4FA0CF03.9060307@broadcom.com> <4FA1B66A.4060901@hauke-m.de> <4FA22325.2030104@broadcom.com>
In-Reply-To: <4FA22325.2030104@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 08:18 AM, Arend van Spriel wrote:
> On 05/03/2012 12:34 AM, Hauke Mehrtens wrote:
>>
>> Hi Arend,
>>
>> thanks for testing.
>>
>> Have you tried suspend/resume and hibernate/resume? I think some of the
>> workaround in drivers/bcma/driver_pci.c should be called in the resume
>> path and not only in the initialization path.
>>
>> Hauke
>>
> 
> Regarding using brcmsmac on bcm4718 soc, I think we cleaned up a bit too
> much during mainline process. There was some chip specific stuff in
> coreinit function and quite a few things in phy code, but those had to
> do with the write flush, I believe. However, the tx fifo size mismatch
> is detected before the chip specific setting in coreinit so I am not
> sure if it is going to help us. I will create a patch for you to try.
> 
> Gr. AvS
> 
Hi Arend,

I looked into the code of the initial brcm80211 commit to staging and it
contains some code which should only be executed on bcm4718 SoCs and not
on bcm43224 chips. I haven't seen any oblivious part which could trigger
the error I am getting, but I will try out the other parts. Did you
remove any significant code before the initial commit to staging?

I will also look what b43 does different from brcmsmac.

/*
 * FIFOSZ fixup
 * 1) core5-9 use ucode 5 to save space since the PSM is the same
 * 2) newer chips, driver wants to controls the fifo allocation
 */
/* For old ucode, txfifo sizes needs to be modified(increased) for
Corerev >= 9 */
These two comments from brcmsmac are looking interesting, but that
should not affect the bcm4718 as it is uses a rev 17 core.

Hauke
