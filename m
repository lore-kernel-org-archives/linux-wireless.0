Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:57448 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab2IQRh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 13:37:56 -0400
Message-ID: <50575FF1.7070602@wwwdotorg.org> (sfid-20120917_193803_938126_846A89A4)
Date: Mon, 17 Sep 2012 11:37:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>, Wei Ni <wni@nvidia.com>
Subject: Re: [PATCH 07/10] brcmfmac: clear status for in-band interrupt in
 brcmf_sdbrcm_isr
References: <1347563526-12513-1-git-send-email-arend@broadcom.com> <1347563526-12513-8-git-send-email-arend@broadcom.com> <5053A74D.6080200@wwwdotorg.org> <50544830.4020804@broadcom.com> <5054B6EB.3010608@wwwdotorg.org>
In-Reply-To: <5054B6EB.3010608@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2012 11:12 AM, Stephen Warren wrote:
> On 09/15/2012 03:19 AM, Arend van Spriel wrote:
>> On 09/14/2012 11:53 PM, Stephen Warren wrote:
>>> On 09/13/2012 01:12 PM, Arend van Spriel wrote:
>>>> From: Franky Lin <frankyl@broadcom.com>
>>>>
>>>> SDIO in-band interrupt is level sensitive according to SDIO standard.
>>>> When the register interrupt handler gets called by SDIO stack it is
>>>> running in non interrupt context and expected to clear the interrupt
>>>> from the dongle. Therefore in-band and out-of-band interrupt need to
>>>> be handled differently.
>>>
>>> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
>>>
>>> For reference, I took next-20120914, applied this patch series, applied
>>> a few patches from Wei Ni to set up the SDIO HW on Tegra correctly, and
>>> tested. The last time I tried this without any patches to the brcmfmac,
>>> this test caused some system instability issues. This time around, I
>>> observed no instability. I tested WPA PSK, ping (or flood ping) plus
>>> playing audio through ALSA.
>>>
>>> Is this series likely to make 3.7?
>>>
>>
>> Thanks, Stephen
>>
>> Good to hear. I suspect we are close to the 3.7 merge window, but we do
>> hope this will make it mainly for the tegra sdio issue that Wei Ni
>> raised. In general the series should resolve issues when used on
>> sdhci/mmc framework with in-band interrupt.
>>
>> Do you still need the patches from Wei Ni and are they SDIO or brcmfmac
>> related?
> 
> Some patches are needed, but they're all for Tegra-specific code to
> configure the pinmux, GPIO, etc. on the Tegra SoC in order to correctly
> communicate with the SDIO port, and to enable the controller. No patches
> are required to the brcmfmac driver.

Just to be explicit here:

If this patch series (the one at the start of this email thread) makes
it into 3.7, I'll apply the Tegra patches to enable brcmfmac on Tegra
for 3.8, and everything will work out nicely.

If this patch series doesn't make it into 3.7, but gets into 3.8
instead, I'd still like to apply the Tegra patches for 3.8 as well.
However, I can't apply the Tegra patches to any branch that doesn't
include this patch series, or it'll cause system instability on Tegra.
To that end, if this patch series doesn't make 3.7, I'd like to request
that it be applied to a separate topic branch in the wireless tree, so
that it can be both merged into the wireless tree for any required
future work there, /and/ merged into the Tegra tree so that I can use it
as a baseline to enable wireless on Tegra.

Thanks!
