Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:64769 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdGVNS5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Jul 2017 09:18:57 -0400
Date: Sat, 22 Jul 2017 15:18:51 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: arend.vanspriel@broadcom.com, hante.meuleman@broadcom.com,
        pieter-paul.giesberts@broadcom.com, franky.lin@broadcom.com,
        kvalo@codeaurora.org
Cc: brcm80211-dev-list.pdl@broadcom.com, linux-wireless@vger.kernel.org
Message-ID: <1442361688.41682.1500729531173@email.1und1.de> (sfid-20170722_151902_060255_EA096856)
Subject: brcmfmac: Possible memleak brcmf_sdiod_sgtable_alloc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

with enabled memleak detector on 4.13-rc1 (Raspberry Pi Zero W) i get the following:

root@raspberrypi:/sys/kernel/debug# cat kmemleak
unreferenced object 0xd824e400 (size 1024):
  comm "kworker/0:0", pid 3, jiffies 4294939822 (age 873.420s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c07f741c>] kmemleak_alloc+0x60/0xc8
    [<c024cb44>] __kmalloc+0x184/0x2f4
    [<c03dc1c8>] sg_kmalloc+0x48/0x4c
    [<c03dc0dc>] __sg_alloc_table+0x78/0x11c
    [<c03dc5d0>] sg_alloc_table+0x2c/0x5c
    [<bf07d7e8>] brcmf_sdiod_sgtable_alloc+0xc0/0x110 [brcmfmac]
    [<bf07b814>] brcmf_sdio_probe+0x24c/0x970 [brcmfmac]
    [<bf07c6fc>] brcmf_ops_sdio_probe+0x17c/0x244 [brcmfmac]
    [<c057d5b4>] sdio_bus_probe+0xb4/0x124
    [<c04add08>] driver_probe_device+0x1d8/0x438
    [<c04ae00c>] __driver_attach+0xa4/0x108
    [<c04abe20>] bus_for_each_dev+0x84/0x98
    [<c04ad644>] driver_attach+0x28/0x30
    [<c04ad084>] bus_add_driver+0xe4/0x24c
    [<c04ae834>] driver_register+0xac/0xf0
    [<c057d7dc>] sdio_register_driver+0x2c/0x34

Regards
Stefan
