Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36224 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbbEQAV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 20:21:59 -0400
Received: by pabts4 with SMTP id ts4so87195812pab.3
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 17:21:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5557B396.9080300@gmail.com>
References: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>
	<5557556C.2080107@lwfinger.net>
	<CACna6rwCapwThrMGt2HV_YyPQtZ+xRPJdBcapRqs2mkvGPdmSQ@mail.gmail.com>
	<5557B396.9080300@gmail.com>
Date: Sun, 17 May 2015 02:21:59 +0200
Message-ID: <CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com> (sfid-20150517_022205_018831_783893DB)
Subject: Re: lspci not working
From: Schmirr Wurst <schmirrwurst@gmail.com>
To: Arend van Spriel <aspriel@gmail.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you all, for your answers...

In fact I'm trying to help a friend with that, and I must say I never
hard such a complicated device...

I tried as suggested to had a look at
/sys/bus/sdio/devices, but the only devices around there a 3
mmc1:0001:1 to :3, I guess it is something else...

I already try to install brcmfmac_sdio , with some tutorial from the
internet, but it didn't work...
actually, I see under /sys/bus/sdio/drivers brcmfmac_sdio ...

In that directory, I see a directory mmc1:0001:2
under device I have 0xa94d

I completly lost, maybe you understand that information, sorry..


2015-05-16 23:16 GMT+02:00 Arend van Spriel <aspriel@gmail.com>:
>
>
> On 16-05-15 16:58, Rafał Miłecki wrote:
>>
>> On 16 May 2015 at 16:34, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>
>>> On 05/16/2015 04:12 AM, Schmirr Wurst wrote:
>>>>
>>>>
>>>> I've already posted the message once, but as it was my first, I'm not
>>>> sure, if it worked...
>>>>
>>>> Actually I'm trying to get read of a t100af from asus, that has a nice
>>>> broadcom wifi chipset, but I'm wondering that I don't see anything
>>>> with lspci, do that mean, that the chipset is broken ?
>>>> (I though lspci is one level deeper than driver, and I should see
>>>> something, even if I have driver problems) ?
>>>>
>>>> Could just somebody tell me if I'm right or wrong ?
>>>
>>>
>>>
>>> On Intel Bay Trail tablets, the wifi device is frequently attached using
>>> an
>>> SDIO bus, not a PCI connection. Accordingly, lspci will probably not show
>>> the device.
>>
>>
>> But you should be able to browse  /sys/bus/sdio/devices/ I guess
>> (assuming bus host driver is working).
>
>
> Indeed. The broadcom device would have a modalias starting 'sdio:c00v02D0d'.
> The Asus T100 series use 43241 if I am not mistaken. It should be supported
> by the brcmfmac driver.
>
> Regards,
> Arend
