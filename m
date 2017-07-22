Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36330 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdGVTlC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Jul 2017 15:41:02 -0400
Received: by mail-wm0-f42.google.com with SMTP id w191so30095051wmw.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jul 2017 12:41:02 -0700 (PDT)
Subject: Re: brcmfmac: Possible memleak brcmf_sdiod_sgtable_alloc
To: Stefan Wahren <stefan.wahren@i2se.com>,
        hante.meuleman@broadcom.com, pieter-paul.giesberts@broadcom.com,
        franky.lin@broadcom.com, kvalo@codeaurora.org
Cc: brcm80211-dev-list.pdl@broadcom.com, linux-wireless@vger.kernel.org
References: <1442361688.41682.1500729531173@email.1und1.de>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <325e5f1a-2752-6004-a460-a59e8e2c702d@broadcom.com> (sfid-20170722_214107_732613_827B2132)
Date: Sat, 22 Jul 2017 21:40:59 +0200
MIME-Version: 1.0
In-Reply-To: <1442361688.41682.1500729531173@email.1und1.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-07-17 15:18, Stefan Wahren wrote:
> Hi,
> 
> with enabled memleak detector on 4.13-rc1 (Raspberry Pi Zero W) i get the following:
> 
> root@raspberrypi:/sys/kernel/debug# cat kmemleak
> unreferenced object 0xd824e400 (size 1024):
>   comm "kworker/0:0", pid 3, jiffies 4294939822 (age 873.420s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<c07f741c>] kmemleak_alloc+0x60/0xc8
>     [<c024cb44>] __kmalloc+0x184/0x2f4
>     [<c03dc1c8>] sg_kmalloc+0x48/0x4c
>     [<c03dc0dc>] __sg_alloc_table+0x78/0x11c
>     [<c03dc5d0>] sg_alloc_table+0x2c/0x5c
>     [<bf07d7e8>] brcmf_sdiod_sgtable_alloc+0xc0/0x110 [brcmfmac]
>     [<bf07b814>] brcmf_sdio_probe+0x24c/0x970 [brcmfmac]
>     [<bf07c6fc>] brcmf_ops_sdio_probe+0x17c/0x244 [brcmfmac]
>     [<c057d5b4>] sdio_bus_probe+0xb4/0x124
>     [<c04add08>] driver_probe_device+0x1d8/0x438
>     [<c04ae00c>] __driver_attach+0xa4/0x108
>     [<c04abe20>] bus_for_each_dev+0x84/0x98
>     [<c04ad644>] driver_attach+0x28/0x30
>     [<c04ad084>] bus_add_driver+0xe4/0x24c
>     [<c04ae834>] driver_register+0xac/0xf0
>     [<c057d7dc>] sdio_register_driver+0x2c/0x34

Hi Stefan,

Thanks for the report. Checking elixir it shows two call sites to
brcmf_sdiod_sgtable_alloc() [1]. This is rather unexpected. We did move
the call so this might be a merge issue.

4d7928959 sdio.c (Hante Meuleman   2016-02-17 11:27:07 +0100:
3867)     brcmf_sdiod_sgtable_alloc(sdiodev);

e0045bf80 sdio.c (Hante Meuleman   2016-01-19 12:39:24 +0100:
4180)     brcmf_sdiod_sgtable_alloc(bus->sdiodev);

The most recent change is:

commit 4d7928959832 ("brcmfmac: switch to new platform data") found in
patchwork [2], which shows the added call, but no removal so the merge
issue is probably internal with us (me :-( ).

Again thanks for the report. Below change should fix the issue.

Regards,
Arend

[1]
http://elixir.free-electrons.com/linux/latest/ident/brcmf_sdiod_sgtable_alloc
[2] https://patchwork.kernel.org/patch/8336231/

---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index fbcbb43..ed2c693 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4174,11 +4174,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct
brcmf_sdio_dev *sdiodev)
                goto fail;
        }

-       /* allocate scatter-gather table. sg support
-        * will be disabled upon allocation failure.
-        */
-       brcmf_sdiod_sgtable_alloc(bus->sdiodev);
-
        /* Query the F2 block size, set roundup accordingly */
        bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
        bus->roundup = min(max_roundup, bus->blocksize);
