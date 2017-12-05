Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:40006 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752806AbdLEJGr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 04:06:47 -0500
Received: by mail-qt0-f181.google.com with SMTP id u42so27422960qte.7
        for <linux-wireless@vger.kernel.org>; Tue, 05 Dec 2017 01:06:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1512413992.18900.3.camel@nxp.com>
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com> <1510916848.26896.2.camel@nxp.com>
 <5A0EDC25.7030505@broadcom.com> <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com> <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
 <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com> <1512413992.18900.3.camel@nxp.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Date: Tue, 5 Dec 2017 10:06:46 +0100
Message-ID: <CAF7Mx6q6mTOXc=4OFVCHAHd26pyfv5e6pK=TMNmb1S6=FBWUWQ@mail.gmail.com> (sfid-20171205_100831_929637_849096C0)
Subject: Re: AP6335 with mainline kernel
To: Vanessa Maegima <vanessa.maegima@nxp.com>
Cc: "van.ayumi@gmail.com" <van.ayumi@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "embed3d@gmail.com" <embed3d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 4, 2017 at 8:00 PM, Vanessa Maegima <vanessa.maegima@nxp.com> wrote:
> Hi Arend,
>
> On Qui, 2017-11-30 at 13:31 +0100, Arend van Spriel wrote:
>> On 11/23/2017 4:24 PM, Vanessa Maegima wrote:
>> >
>> > >
>> > > >
>> > > > >
>> > > > > >
>> > > > > > >
>> > > > > > > Buildroot:
>> > > > > > > # dmesg | grep brcmfmac
>> > > > > > > [    5.343118] brcmfmac: brcmf_fw_map_chip_to_name: using
>> > > > > > > brcm/brcmfmac4339-sdio.bin for chip 0x00433
>> > > > > > > 9(17209) rev 0x000002
>> > > > > > > [    6.420070] brcmfmac: brcmf_sdio_htclk: HT Avail
>> > > > > > > timeout
>> > > > > > > (1000000):
>> > > > > > > clkctl 0x50
>> > > > > > > [    6.427722] brcmfmac:
>> > > > > > > brcmf_sdio_htclk:   pmucontrol   =
>> > > > > > > 01774381
>> > > > > > > [    6.434865] brcmfmac:
>> > > > > > > brcmf_sdio_htclk:   pmustatus    =
>> > > > > > > 0000002a
>> > > > > > > [    6.441174] brcmfmac: brcmf_sdio_htclk:   min_res_mask
>> > > > > > > =
>> > > > > > > 0fcaff77
>> > > > > > > [    6.447379] brcmfmac: brcmf_sdio_htclk:   max_res_mask
>> > > > > > > =
>> > > > > > > 0fceff77
>> It toook me a while to look into this. Unfortunately I do not have a
>> 4339 to replicate your issue. The closest I have is a 4335. What
>> looks
>> wrong here is the max_res_mask because the HT Avail resource is bit
>> 29
>> which needs to be set in max_res_mask in order to make the request
>> work.
>> On my 4335 the max_res_mask is 0x7fffffff before calling
>> brcmf_sdio_htclk(). So that is the cause of the failure in
>> brcmf_sdio_htclk(). However, now the question is why it is not
>> properly set.
>>
>> Between your device and mine there is once discrepancy in the
>> pmucontrol
>> register, ie. bit 9 is set for your device. According the
>> documentation
>> the power-on reset value for this bit is 0 and I don't seen any code
>> in
>> our proprietary driver touching it.
>>
>> >
>> > Sorry for the delayed answer, I had some trouble to copy the
>> > symlinks
>> > files corretly from /sys/class/devcoredump.
>> >
>> > I uploaded this folder to: https://emea01.safelinks.protection.outl
>> > ook.com/?url=https%3A%2F%2Fdrive.google.com%2Fopen%3Fid%3D1fosahjLN
>> > 1K&data=02%7C01%7Cvanessa.maegima%40nxp.com%7Cb643e57876e44140aa300
>> > 8d537ee44aa%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6364764188
>> > 49464214&sdata=BrsDz0Ncm786g169TQOqFlbWuylR1pc1JklEkqeL%2FA0%3D&res
>> > erved=0
>> > I5NKS59_aPZdHLpENPFHtK
>> That worked nicely. So the firmware seems to crash very early. I
>> have
>> rebuilt the firmware to provide me more info. Can you redo the
>> devcoredump trick with that firmware.
>>
>> Regards,
>> Arend
>
> Thanks for your reply!
>
> I tried your new firmware and here is the output (new_firmware folder):
> https://drive.google.com/drive/folders/1fosahjLN1KI5NKS59_aPZdHLpENPFHt
> K

Hi Vanessa.

The only file of interest is one named 'data' and it is not present in
the new folder. These core dumps are removed from the filesystem after
some timeout (not sure how long) so that may be the reason.

Regards,
Arend

> Thanks!
>
> Regards,
> Vanessa
