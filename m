Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:57284 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaBQRhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 12:37:36 -0500
Message-ID: <530248DD.1050408@broadcom.com> (sfid-20140217_183741_439718_DAB9345D)
Date: Mon, 17 Feb 2014 18:37:33 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Bernd Wagener <Bernd.Wagener@Uni-Oldenburg.DE>
CC: Samuel Ortiz <sameo@linux.intel.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	<frankyl@broadcom.com>
Subject: Re: brcmfmac NVRAM files
References: <20140217150640.GJ18868@zurbaran> <20140217163315.GA22010@zurbaran> <53023E51.90202@Uni-Oldenburg.DE>
In-Reply-To: <53023E51.90202@Uni-Oldenburg.DE>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/14 17:52, Bernd Wagener wrote:
> Am 17.02.2014 17:33, schrieb Samuel Ortiz:
>> On Mon, Feb 17, 2014 at 04:06:40PM +0100, Samuel Ortiz wrote:
>>> Hi Arend,
>>>
>>> I'm trying to use a 43241 SDIO chip here, and it fails asking for the
>>> .txt file (brcmfmac43241b4-sdio.txt). This seems to be an NVRAM map
>>> file, but I could not find either a template on linux-firmware or any
>>> kind of documentation about it.
>>>
>>> How do distro handle that ? Are they expected to build their own, or is
>>> it completely OEM pecific ?
>> Adding Franky to the Cc list.
>>
>> Cheers,
>> Samuel.
>>
> Hi Samuel,
> I had the same proble with a wandboard here and I guess it's a bug. In
> /lib/firmware/brcm are all reqired *.bin files, but no *.txt file. On
> www.wandboard.or I found a SDK-Kit with brcmfmac4329-sdio.txt, copied
> the file and then the wlan was running.
> The *.txt are simply forgotten to copy to the firmware directory.
> No idea how to fix this.

Hi Bernd,

The hint to solve this is found on wireless.kernel.org [1] and the 
answer is as Samuel suspects. This file is very board specific so OEMs 
manufacturing/selling the board should provide it either upon request or 
through some distribution like a SDK. Because of the nature of the file 
we do not put it on linux-firmware although people like yourself can get 
lucky trying ;-)

Regards,
Arend
