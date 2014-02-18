Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2122 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbaBRJ6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 04:58:08 -0500
Message-ID: <53032EAB.5070905@broadcom.com> (sfid-20140218_105815_092977_BD23A63A)
Date: Tue, 18 Feb 2014 10:58:03 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Bernd Wagener <Bernd.Wagener@Uni-Oldenburg.DE>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	<frankyl@broadcom.com>
Subject: Re: brcmfmac NVRAM files
References: <20140217150640.GJ18868@zurbaran> <20140217163315.GA22010@zurbaran> <53023E51.90202@Uni-Oldenburg.DE> <530248DD.1050408@broadcom.com> <20140217180033.GM18868@zurbaran>
In-Reply-To: <20140217180033.GM18868@zurbaran>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2014 07:00 PM, Samuel Ortiz wrote:
> Hi Arend,
> 
> On Mon, Feb 17, 2014 at 06:37:33PM +0100, Arend van Spriel wrote:
>> Hi Bernd,
>>
>> The hint to solve this is found on wireless.kernel.org [1] and the
>> answer is as Samuel suspects. This file is very board specific so
>> OEMs manufacturing/selling the board should provide it either upon
>> request or through some distribution like a SDK.
> There are several Win8 2-in-1 devices that do run the SDIO Full MAC
> chipsets and obviously there is no SDK for those. Which means no distro
> will ever be able to run out of the box on those.
> I may be completely off the mark here, but isn't there a sensible
> template for those guys ? Nothing optimised, but just something that
> would at least make things work...

Last time I got the question I extracted the nvram from the windows
driver installer archive. However, it may end up in (U)EFI variable
space. Guess that could be accessed from Linux as well. Anyway, it may
be an area where we can and maybe should improve. I will discuss this
with Franky and the rest of the team over here.

> Also, the hint for pre 3.13 kernel is to copy the .bin into a .txt. Is
> that still the case for post 3.13 ?

I certainly hope you misread that. Before 3.13 the driver always look
for brcmfmac-sdio.bin and brcmfmac-sdio.txt regardless the device being
used. That has changed so the firmware file now includes the chip id and
for some even the revision, eg. brcmfmac43241b4-sdio.bin and
brcmfmac43241b4-sdio.txt. The nvram file has a totally different format
as the bin file so copying will fail for sure.

Regards,
Arend
