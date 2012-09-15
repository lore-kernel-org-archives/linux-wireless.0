Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4209 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab2IOJUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2012 05:20:06 -0400
Message-ID: <50544830.4020804@broadcom.com> (sfid-20120915_112101_610212_BC0E5EA3)
Date: Sat, 15 Sep 2012 11:19:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stephen Warren" <swarren@wwwdotorg.org>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>, "Wei Ni" <wni@nvidia.com>
Subject: Re: [PATCH 07/10] brcmfmac: clear status for in-band interrupt
 in brcmf_sdbrcm_isr
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
 <1347563526-12513-8-git-send-email-arend@broadcom.com>
 <5053A74D.6080200@wwwdotorg.org>
In-Reply-To: <5053A74D.6080200@wwwdotorg.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2012 11:53 PM, Stephen Warren wrote:
> On 09/13/2012 01:12 PM, Arend van Spriel wrote:
>> From: Franky Lin <frankyl@broadcom.com>
>>
>> SDIO in-band interrupt is level sensitive according to SDIO standard.
>> When the register interrupt handler gets called by SDIO stack it is
>> running in non interrupt context and expected to clear the interrupt
>> from the dongle. Therefore in-band and out-of-band interrupt need to
>> be handled differently.
>
> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
>
> For reference, I took next-20120914, applied this patch series, applied
> a few patches from Wei Ni to set up the SDIO HW on Tegra correctly, and
> tested. The last time I tried this without any patches to the brcmfmac,
> this test caused some system instability issues. This time around, I
> observed no instability. I tested WPA PSK, ping (or flood ping) plus
> playing audio through ALSA.
>
> Is this series likely to make 3.7?
>

Thanks, Stephen

Good to hear. I suspect we are close to the 3.7 merge window, but we do 
hope this will make it mainly for the tegra sdio issue that Wei Ni 
raised. In general the series should resolve issues when used on 
sdhci/mmc framework with in-band interrupt.

Do you still need the patches from Wei Ni and are they SDIO or brcmfmac 
related?

Gr. AvS

