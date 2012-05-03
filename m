Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1609 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2ECGSX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 02:18:23 -0400
Message-ID: <4FA22325.2030104@broadcom.com> (sfid-20120503_081826_773312_3BAF1FB0)
Date: Thu, 3 May 2012 08:18:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
 <4F9CF839.1040401@broadcom.com> <4FA0CF03.9060307@broadcom.com>
 <4FA1B66A.4060901@hauke-m.de>
In-Reply-To: <4FA1B66A.4060901@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 12:34 AM, Hauke Mehrtens wrote:
> 
> Hi Arend,
> 
> thanks for testing.
> 
> Have you tried suspend/resume and hibernate/resume? I think some of the
> workaround in drivers/bcma/driver_pci.c should be called in the resume
> path and not only in the initialization path.
> 
> Hauke
> 

Regarding using brcmsmac on bcm4718 soc, I think we cleaned up a bit too
much during mainline process. There was some chip specific stuff in
coreinit function and quite a few things in phy code, but those had to
do with the write flush, I believe. However, the tx fifo size mismatch
is detected before the chip specific setting in coreinit so I am not
sure if it is going to help us. I will create a patch for you to try.

Gr. AvS

