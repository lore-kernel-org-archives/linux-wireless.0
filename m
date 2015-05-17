Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36666 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbbEQOII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 10:08:08 -0400
Received: by pdfh10 with SMTP id h10so107793418pdf.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 07:08:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+0W_AsY3sz9+t=guZYi9v-_X1-MMc5=11FPm=4QKkMxNd=uFQ@mail.gmail.com>
References: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>
	<5557556C.2080107@lwfinger.net>
	<CACna6rwCapwThrMGt2HV_YyPQtZ+xRPJdBcapRqs2mkvGPdmSQ@mail.gmail.com>
	<5557B396.9080300@gmail.com>
	<CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com>
	<CA+0W_AuXCgFoH2fm0kr5V9nkcNB9bCp8M4KF=J2=c5QCBrbL8A@mail.gmail.com>
	<CA+0W_Asj3f10VJ=NVu_WGRO3iLyLZY3AhHnD3pkb7-r45j-yYA@mail.gmail.com>
	<CA+0W_At6_zecdghFj1MS8XxiqvrELTd=TTPVZ84hEM=gqL-brw@mail.gmail.com>
	<555894E7.3080600@hauke-m.de>
	<CA+0W_AsY3sz9+t=guZYi9v-_X1-MMc5=11FPm=4QKkMxNd=uFQ@mail.gmail.com>
Date: Sun, 17 May 2015 16:08:08 +0200
Message-ID: <CA+0W_Au9-xCi4mb1+1UTqQJ+ymHTqzbiORO6yiZD6CBAjZN1yQ@mail.gmail.com> (sfid-20150517_160814_759562_629FF849)
Subject: Fwd: lspci not working
From: Schmirr Wurst <schmirrwurst@gmail.com>
To: Schmirr Wurst <schmirrwurst@gmail.com>,
	Arend van Spriel <aspriel@gmail.com>,
	=?UTF-8?Q?S=C3=A9bastien_Brennion?= <sebastien.brennion@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: Schmirr Wurst <schmirrwurst@gmail.com>
Date: 2015-05-17 16:07 GMT+02:00
Subject: Re: lspci not working
To: Hauke Mehrtens <hauke@hauke-m.de>


2015-05-17 15:17 GMT+02:00 Hauke Mehrtens <hauke@hauke-m.de>:
> On 05/17/2015 03:00 PM, Schmirr Wurst wrote:
>> 2015-05-17 14:57 GMT+02:00 Schmirr Wurst <schmirrwurst@gmail.com>:
>>> I'm not familiar with inline answers and mailing list, tried to put
>>> some order in my answer + log file
>>>
>>> 2015-05-17 13:18 GMT+02:00 Rafał Miłecki <zajec5@gmail.com>:
>>>> On 17 May 2015 at 12:23, Arend van Spriel <arend@broadcom.com> wrote:
>>>>> On 05/17/15 02:21, Schmirr Wurst wrote:
>>>>>> I tried as suggested to had a look at
>>>>>> /sys/bus/sdio/devices, but the only devices around there a 3
>>>>>> mmc1:0001:1 to :3, I guess it is something else...
>>>>>>
>>>>>> I already try to install brcmfmac_sdio , with some tutorial from the
>>>>>> internet, but it didn't work...
>>>>>> actually, I see under /sys/bus/sdio/drivers brcmfmac_sdio ...
>>>>>>
>>>>>> In that directory, I see a directory mmc1:0001:2
>>>>>> under device I have 0xa94d
>>>>>>
>>>>>> I completly lost, maybe you understand that information, sorry..
>>>>>
>>>>>
>>>>> I do. The fact that you see a subdirectory mmc1:0001:2 in
>>>>> /sys/bus/sdio/drivers/brcmfmac_sdio means that the driver was probed for
>>>>> this device. Now would be a good time to share your (friends') kernel log,
>>>>> but my guess is you are either missing firmware or nvram data or both for
>>>>> this device.
>>> I ve attatched the kernel.log here https://drive.google.com/file/d/0B8gm4mLCCQAgMmNlVVFSYmNjOGs/view?usp=sharing
>>> In dmsg I see following linked with the brc driver :
>>> dmesg | grep brc
>>> [    7.987661] brcmf_sdio_drivestrengthinit: No SDIO Drive strength
>>> init done for chip 43340 rev 2 pmurev 20
>>> [    7.993487] usbcore: registered new interface driver brcmfmac
>>> [    7.996318] brcmfmac_sdio mmc1:0001:1: Direct firmware load for
>>> brcm/brcmfmac43340-sdio.bin failed with error -2
>>> [    9.011572] brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>>> [   10.037365] brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>>>>
>>>> It could also mean driver was loaded manually. So please also make
>>>> sure the friend uses kernel 4.0 or newer.
>>> Kernel : 4.0.0 #3 SMP PREEMPT Wed Apr 22 17:52:53 MSK 2015
>>> Distro:
>>> Distributor ID:    T100 Ubuntu 15.04
>>> Description:    Ubuntu 15.04
>>> Release:    15.04
>>> Codename:    vivid
>>> I ve installed it from the magic stick here
>>> https://plus.google.com/communities/117853703024346186936
>
> The driver complains about missing firmware and Ubuntu 15.04 does not
> contain it.
>
> Please place this file
> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/plain/brcm/brcmfmac43340-sdio.bin
>
> to /lib/firmware/brcm/brcmfmac43340-sdio.bin
>
> Hauke
 Before that, the system was complaining about
brcm/brcmfmac43340-sdio.bin, and now about brcm/brcmfmac43340-sdio.txt
but errors are similar...

43340 rev 2 pmurev 20
May 17 15:53:48 scheissasus kernel: [    7.372974] usbcore: registered
new interface driver brcmfmac
May 17 15:53:48 scheissasus kernel: [    7.374344] brcmfmac_sdio
mmc1:0001:1: Direct firmware load for brcm/brcmfmac43340-sdio.bin
failed with error -2
May 17 15:53:48 scheissasus kernel: [    8.383270] brcmf_sdio_htclk:
HT Avail timeout (1000000): clkctl 0x50
May 17 15:53:50 scheissasus kernel: [   11.401582] brcmf_sdio_htclk:
HT Avail timeout (1000000): clkctl 0x50
May 17 15:59:23 scheissasus kernel: [    7.496560]
brcmf_sdio_drivestrengthinit: No SDIO Drive strength init done for
chip 43340 rev 2 pmurev 20
May 17 15:59:23 scheissasus kernel: [    7.500086] usbcore: registered
new interface driver brcmfmac
May 17 15:59:23 scheissasus kernel: [    7.506911] brcmfmac_sdio
mmc1:0001:1: Direct firmware load for brcm/brcmfmac43340-sdio.txt
failed with error -2
May 17 15:59:23 scheissasus kernel: [    8.514107] brcmf_sdio_htclk:
HT Avail timeout (1000000): clkctl 0x50
May 17 15:59:23 scheissasus kernel: [    9.531340] brcmf_sdio_htclk:
HT Avail timeout (1000000): clkctl 0x50
