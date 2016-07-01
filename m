Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36750 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcGAJOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 05:14:45 -0400
Received: by mail-pf0-f175.google.com with SMTP id t190so38706356pfb.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2016 02:14:45 -0700 (PDT)
Subject: Re: building brcmfmac driver for iMX6 Ultralite platform
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Eskowitz <MichaelE@inventeksys.com>
References: <002601d1d305$183c3070$48b49150$@inventeksys.com>
 <CACna6rx-iw8cBT9kp5gsW0REuVNE-GzU62GBKjR9BAtWu14mCA@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <293add70-308d-fe78-d5d5-ba8b6079658d@broadcom.com> (sfid-20160701_111450_034252_111E9FC2)
Date: Fri, 1 Jul 2016 11:14:36 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rx-iw8cBT9kp5gsW0REuVNE-GzU62GBKjR9BAtWu14mCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1-7-2016 11:07, Rafał Miłecki wrote:
> On 30 June 2016 at 21:24, Michael Eskowitz <MichaelE@inventeksys.com> wrote:
>>         insmod  brcmfmac.ko
>> firmware_path=ISM4334X_Wifi_FW_6.10.190.49_P.bin
>> nvram_path=ISM4334X_NVRAM_C1.txt
>>
>> I receive the following errors:
>>
>>         brcmfmac: Unknown symbol brcmu_pktq_mlen (err 0)
>>         brcmfmac: Unknown symbol brcmu_pkt_buf_free_skb (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_init (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_penq_head (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_pdeq (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_peek_tail (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_flush (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_pdeq_match (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_mdeq (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_penq (err 0)
>>         brcmfmac: Unknown symbol brcmu_pktq_pdeq_tail (err 0)
>>         brcmfmac: Unknown symbol brcmu_pkt_buf_get_skb (err 0)
>>         brcmfmac: Unknown symbol brcmu_d11_attach (err 0)
>>         insmod: ERROR: could not insert module brcmfmac.ko: Unknown symbol
>> in module
>>
>> I'm not sure that the firmware_path and nvram_path should be specified in
>> this manner, but I doubt that is what is causing these errors.
>>
>> The module compiled and built just fine so I am assuming that there are some
>> dependencies that aren't being met.  Is there another module that I need to
>> load before attempting to load the fmac driver?
> 
> If you don't know module dependencies, why not use something that
> handled this for you? Replace insmod with modprobe.

That only works when the modules are in an installed location and depmod
has been used properly, which I doubt is the case in this experiment.

> You can't load brcmfmac.ko without loading brcmutil.ko first.

Indeed.

Regards,
Arend
