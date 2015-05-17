Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f194.google.com ([209.85.212.194]:33047 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbEQJ16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 05:27:58 -0400
Received: by wivz2 with SMTP id z2so5811867wiv.0
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 02:27:56 -0700 (PDT)
Message-ID: <55585F1B.5050008@gmail.com> (sfid-20150517_112803_590186_FFF9A7F7)
Date: Sun, 17 May 2015 11:27:55 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Schmirr Wurst <schmirrwurst@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: lspci not working
References: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>	<5557556C.2080107@lwfinger.net>	<CACna6rwCapwThrMGt2HV_YyPQtZ+xRPJdBcapRqs2mkvGPdmSQ@mail.gmail.com>	<5557B396.9080300@gmail.com>	<CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com> <CACna6rzxZJg3MHsBV3vtaEtgUbh9umE6CS=2YkgkexT51J1oiw@mail.gmail.com>
In-Reply-To: <CACna6rzxZJg3MHsBV3vtaEtgUbh9umE6CS=2YkgkexT51J1oiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-05-15 10:47, Rafał Miłecki wrote:
> On 17 May 2015 at 02:21, Schmirr Wurst <schmirrwurst@gmail.com> wrote:
>> I tried as suggested to had a look at
>> /sys/bus/sdio/devices, but the only devices around there a 3
>> mmc1:0001:1 to :3, I guess it is something else...
>
> Why do you guess so? You didn't provide us any details about entries there.

Indeed a wrong guess. The sdio specification allows a physical sdio 
device to provide multiple sdio functions, which are instantiated as 
devices in the linux driver model. So they will have the same modalias.

>> In that directory, I see a directory mmc1:0001:2
>> under device I have 0xa94d
>>
>> I completly lost, maybe you understand that information, sorry..
>
> You provided only one single device id, without even vendor id. Give
> us at least a list of devices, e.g. by their modalias, like
> cat /sys/bus/sdio/devices/*/modalias
>

Converting 0xa94d gives 43341, which does not look like a coincidence to 
me. So this Asus device comes with a newer chip, but it is supported by 
brcmfmac (provided vendor id is indeed 0x02d0!).

Regards,
Arend
