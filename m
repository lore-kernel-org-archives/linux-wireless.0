Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:35178 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbEHKTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 06:19:05 -0400
Message-ID: <554C8D96.9030205@broadcom.com> (sfid-20150508_121910_204408_53928B4D)
Date: Fri, 8 May 2015 12:19:02 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RFC:rxctl wait timed out] brcmfmac: add BCM43526 USB support
References: <1431030535-11083-1-git-send-email-zajec5@gmail.com>	<554C81D2.8080602@broadcom.com> <CACna6rxV_sR1WhrHRwtM8cjengsCbm_iUWzy0n_+fLYmxypmMw@mail.gmail.com>
In-Reply-To: <CACna6rxV_sR1WhrHRwtM8cjengsCbm_iUWzy0n_+fLYmxypmMw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/15 11:53, Rafał Miłecki wrote:
> On 8 May 2015 at 11:28, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 05/07/15 22:28, Rafał Miłecki wrote:
>>> I'm trying to add BCM43526 support. This chipset can be found in:
>>> 1) Some USB dongles, e.g. Tenda W900U uses revision 2
>>> 2) Some routers, e.g. Asus RT-AC53U uses revision 3+
>>>
>>> Unfortunately attached patch doesn't seem to be enough, brcmfmac doesn't
>>> work with my Tenda W900U. I keep getting following error:
>>>>
>>>> brcmfmac: brcmf_usb_recv_ctl Enter
>>>> brcmf_usb_rx_ctlpkt: rxctl wait timed out
>>>> brcmfmac: brcmf_fil_cmd_data Failed: -5
>>>
>>>
>>> It seems that:
>>> 1) driver sends TX URB and gets completion callback called
>>> 2) driver sents RX URB but it never gets completed
>>
>> Unfortunately this device is a BMAC device. You can tell by the 'high' word
>> in the windows driver name. So there is no chance whatsoever to get this
>> device going with brcmfmac.
>
> Oh damn, I was sure Broadcom dropped this design back in BCM43236
> times, I didn't even suspect newer chipsets may be still using it :(
> Shit.

Apparently this design is still in demand by our customers against all 
hopes.

> Do you have any idea about BCM43526 rev 3+? The chipsets using 43526b
> instead of 43526a. Any chance BCM43526 rev 3+ is normal FullMAC device
> just like BCM43236 rev 3+?

I don't know. Main thing needed for that is more on-chip memory, which 
makes it a bit more expensive. This may be a deal breaker for existing 
43526 customers unless they like the fullmac advantages they get for 
their money.

Regards,
Arend
