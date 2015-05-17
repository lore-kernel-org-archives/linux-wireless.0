Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:42254 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbEQKXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 06:23:06 -0400
Message-ID: <55586C06.8050803@broadcom.com> (sfid-20150517_123322_859729_54E36F8E)
Date: Sun, 17 May 2015 12:23:02 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Schmirr Wurst <schmirrwurst@gmail.com>
CC: Arend van Spriel <aspriel@gmail.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: lspci not working
References: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>	<5557556C.2080107@lwfinger.net>	<CACna6rwCapwThrMGt2HV_YyPQtZ+xRPJdBcapRqs2mkvGPdmSQ@mail.gmail.com>	<5557B396.9080300@gmail.com> <CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com>
In-Reply-To: <CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/15 02:21, Schmirr Wurst wrote:
> Thank you all, for your answers...
>
> In fact I'm trying to help a friend with that, and I must say I never
> hard such a complicated device...

Well, it depends what aspect you find complicated. It is pretty 
straightforward device that just needs a driver to work.

> I tried as suggested to had a look at
> /sys/bus/sdio/devices, but the only devices around there a 3
> mmc1:0001:1 to :3, I guess it is something else...
>
> I already try to install brcmfmac_sdio , with some tutorial from the
> internet, but it didn't work...
> actually, I see under /sys/bus/sdio/drivers brcmfmac_sdio ...
>
> In that directory, I see a directory mmc1:0001:2
> under device I have 0xa94d
>
> I completly lost, maybe you understand that information, sorry..

I do. The fact that you see a subdirectory mmc1:0001:2 in 
/sys/bus/sdio/drivers/brcmfmac_sdio means that the driver was probed for 
this device. Now would be a good time to share your (friends') kernel 
log, but my guess is you are either missing firmware or nvram data or 
both for this device.

And could you try to answer inline instead of top-posting.

Regards,
Arend

> 2015-05-16 23:16 GMT+02:00 Arend van Spriel<aspriel@gmail.com>:
>>
>>
>> On 16-05-15 16:58, Rafał Miłecki wrote:
>>>
>>> On 16 May 2015 at 16:34, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>>>
>>>> On 05/16/2015 04:12 AM, Schmirr Wurst wrote:
>>>>>
>>>>>
>>>>> I've already posted the message once, but as it was my first, I'm not
>>>>> sure, if it worked...
>>>>>
>>>>> Actually I'm trying to get read of a t100af from asus, that has a nice
>>>>> broadcom wifi chipset, but I'm wondering that I don't see anything
>>>>> with lspci, do that mean, that the chipset is broken ?
>>>>> (I though lspci is one level deeper than driver, and I should see
>>>>> something, even if I have driver problems) ?
>>>>>
>>>>> Could just somebody tell me if I'm right or wrong ?
>>>>
>>>>
>>>>
>>>> On Intel Bay Trail tablets, the wifi device is frequently attached using
>>>> an
>>>> SDIO bus, not a PCI connection. Accordingly, lspci will probably not show
>>>> the device.
>>>
>>>
>>> But you should be able to browse  /sys/bus/sdio/devices/ I guess
>>> (assuming bus host driver is working).
>>
>>
>> Indeed. The broadcom device would have a modalias starting 'sdio:c00v02D0d'.
>> The Asus T100 series use 43241 if I am not mistaken. It should be supported
>> by the brcmfmac driver.
>>
>> Regards,
>> Arend
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

