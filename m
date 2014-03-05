Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:46554 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaCEJEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 04:04:30 -0500
Message-ID: <5316E88D.7010605@broadcom.com> (sfid-20140305_100445_093112_3E5A7EE9)
Date: Wed, 5 Mar 2014 10:04:13 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Bernd Wagener <Bernd.Wagener@Uni-Oldenburg.DE>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac NVRAM files
References: <20140217150640.GJ18868@zurbaran> <20140217163315.GA22010@zurbaran> <53023E51.90202@Uni-Oldenburg.DE> <530248DD.1050408@broadcom.com> <20140217180033.GM18868@zurbaran> <53032EAB.5070905@broadcom.com> <20140305023151.GG17664@zurbaran>
In-Reply-To: <20140305023151.GG17664@zurbaran>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2014 03:31 AM, Samuel Ortiz wrote:
> Hi Arend,
> 
> On Tue, Feb 18, 2014 at 10:58:03AM +0100, Arend van Spriel wrote:
>> I certainly hope you misread that. Before 3.13 the driver always look
>> for brcmfmac-sdio.bin and brcmfmac-sdio.txt regardless the device being
>> used. That has changed so the firmware file now includes the chip id and
>> for some even the revision, eg. brcmfmac43241b4-sdio.bin and
>> brcmfmac43241b4-sdio.txt. The nvram file has a totally different format
>> as the bin file so copying will fail for sure.
> So I finally found this NVRAM file, hidden somewhere in an EFI variable
> (Thanks for the hint).

That is actually the first occurrence of EFI I have come across in the
wild, but I mentioned it as I caught up that this was considered for
Win8(.1).
> I have 2 questions for you:
> 
> - How can I tell if the target properly loaded this NVRAM file ? Is
>   checking for wlan0's MAC to match the NVRAM MAC a good way to verify
>   that ?

Actually, the MAC address in NVRAM should be a backup value. The device
should have a MAC address programmed in OTP on the device itself. The
driver itself reads back the NVRAM to assure it is properly loaded.

> - I'm running this on an Asus T100 (x86 tablet). This is a BCM94324A1
>   over SDIO and I run wireless-next there (With your very latest
>   brcmfmac changes). I see the driver is quite unreliable, for example
>   scan times out most of the time as the driver puts the target to sleep
>   while it's in the middle of receiving partial scan results. I had to
>   increase BRCMF_WD_POLL_MS to 100ms to actually get scan results. Then
>   the driver seems to be having a hard time joining the couple of WPA
>   APs that I tested it against.
>   Am I missing something or are those instabilities to be expected with
>   the latest brcmfmac code ? Please let me know if you need debug logs,
>   I'll happily provide them.

Great. Please send me a log with module parameter 'debug=0x31416' of the
driver probe sequence.

I also have 2 question for you ;-)

- what mmc host controller is used?
- do you have CONFIG_RUNTIME_PM enabled?

Gr. AvS

