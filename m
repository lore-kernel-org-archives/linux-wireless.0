Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34014 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbEQNAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 09:00:03 -0400
Received: by pdbnk13 with SMTP id nk13so10631219pdb.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 06:00:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+0W_Asj3f10VJ=NVu_WGRO3iLyLZY3AhHnD3pkb7-r45j-yYA@mail.gmail.com>
References: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>
	<5557556C.2080107@lwfinger.net>
	<CACna6rwCapwThrMGt2HV_YyPQtZ+xRPJdBcapRqs2mkvGPdmSQ@mail.gmail.com>
	<5557B396.9080300@gmail.com>
	<CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com>
	<CA+0W_AuXCgFoH2fm0kr5V9nkcNB9bCp8M4KF=J2=c5QCBrbL8A@mail.gmail.com>
	<CA+0W_Asj3f10VJ=NVu_WGRO3iLyLZY3AhHnD3pkb7-r45j-yYA@mail.gmail.com>
Date: Sun, 17 May 2015 15:00:03 +0200
Message-ID: <CA+0W_At6_zecdghFj1MS8XxiqvrELTd=TTPVZ84hEM=gqL-brw@mail.gmail.com> (sfid-20150517_150007_483715_6AA814AD)
Subject: Re: lspci not working
From: Schmirr Wurst <schmirrwurst@gmail.com>
To: Arend van Spriel <aspriel@gmail.com>,
	=?UTF-8?Q?S=C3=A9bastien_Brennion?= <sebastien.brennion@gmail.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-05-17 14:57 GMT+02:00 Schmirr Wurst <schmirrwurst@gmail.com>:
> I'm not familiar with inline answers and mailing list, tried to put
> some order in my answer + log file
>
> 2015-05-17 13:18 GMT+02:00 Rafał Miłecki <zajec5@gmail.com>:
>> On 17 May 2015 at 12:23, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 05/17/15 02:21, Schmirr Wurst wrote:
>>>> I tried as suggested to had a look at
>>>> /sys/bus/sdio/devices, but the only devices around there a 3
>>>> mmc1:0001:1 to :3, I guess it is something else...
>>>>
>>>> I already try to install brcmfmac_sdio , with some tutorial from the
>>>> internet, but it didn't work...
>>>> actually, I see under /sys/bus/sdio/drivers brcmfmac_sdio ...
>>>>
>>>> In that directory, I see a directory mmc1:0001:2
>>>> under device I have 0xa94d
>>>>
>>>> I completly lost, maybe you understand that information, sorry..
>>>
>>>
>>> I do. The fact that you see a subdirectory mmc1:0001:2 in
>>> /sys/bus/sdio/drivers/brcmfmac_sdio means that the driver was probed for
>>> this device. Now would be a good time to share your (friends') kernel log,
>>> but my guess is you are either missing firmware or nvram data or both for
>>> this device.
> I ve attatched the kernel.log here https://drive.google.com/file/d/0B8gm4mLCCQAgMmNlVVFSYmNjOGs/view?usp=sharing
> In dmsg I see following linked with the brc driver :
> dmesg | grep brc
> [    7.987661] brcmf_sdio_drivestrengthinit: No SDIO Drive strength
> init done for chip 43340 rev 2 pmurev 20
> [    7.993487] usbcore: registered new interface driver brcmfmac
> [    7.996318] brcmfmac_sdio mmc1:0001:1: Direct firmware load for
> brcm/brcmfmac43340-sdio.bin failed with error -2
> [    9.011572] brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
> [   10.037365] brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>>
>> It could also mean driver was loaded manually. So please also make
>> sure the friend uses kernel 4.0 or newer.
> Kernel : 4.0.0 #3 SMP PREEMPT Wed Apr 22 17:52:53 MSK 2015
> Distro:
> Distributor ID:    T100 Ubuntu 15.04
> Description:    Ubuntu 15.04
> Release:    15.04
> Codename:    vivid
> I ve installed it from the magic stick here
> https://plus.google.com/communities/117853703024346186936
