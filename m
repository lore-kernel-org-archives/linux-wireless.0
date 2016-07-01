Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34302 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbcGAJHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 05:07:20 -0400
Received: by mail-oi0-f53.google.com with SMTP id s66so102435412oif.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2016 02:07:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <002601d1d305$183c3070$48b49150$@inventeksys.com>
References: <002601d1d305$183c3070$48b49150$@inventeksys.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 1 Jul 2016 11:07:19 +0200
Message-ID: <CACna6rx-iw8cBT9kp5gsW0REuVNE-GzU62GBKjR9BAtWu14mCA@mail.gmail.com> (sfid-20160701_110735_752682_FB2E642E)
Subject: Re: building brcmfmac driver for iMX6 Ultralite platform
To: Michael Eskowitz <MichaelE@inventeksys.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 June 2016 at 21:24, Michael Eskowitz <MichaelE@inventeksys.com> wrote:
>         insmod  brcmfmac.ko
> firmware_path=ISM4334X_Wifi_FW_6.10.190.49_P.bin
> nvram_path=ISM4334X_NVRAM_C1.txt
>
> I receive the following errors:
>
>         brcmfmac: Unknown symbol brcmu_pktq_mlen (err 0)
>         brcmfmac: Unknown symbol brcmu_pkt_buf_free_skb (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_init (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_penq_head (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_pdeq (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_peek_tail (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_flush (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_pdeq_match (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_mdeq (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_penq (err 0)
>         brcmfmac: Unknown symbol brcmu_pktq_pdeq_tail (err 0)
>         brcmfmac: Unknown symbol brcmu_pkt_buf_get_skb (err 0)
>         brcmfmac: Unknown symbol brcmu_d11_attach (err 0)
>         insmod: ERROR: could not insert module brcmfmac.ko: Unknown symbol
> in module
>
> I'm not sure that the firmware_path and nvram_path should be specified in
> this manner, but I doubt that is what is causing these errors.
>
> The module compiled and built just fine so I am assuming that there are some
> dependencies that aren't being met.  Is there another module that I need to
> load before attempting to load the fmac driver?

If you don't know module dependencies, why not use something that
handled this for you? Replace insmod with modprobe.

You can't load brcmfmac.ko without loading brcmutil.ko first.

-- 
Rafał
