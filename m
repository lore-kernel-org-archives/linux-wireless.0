Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:54342 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbdKVQUu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 11:20:50 -0500
Date: Wed, 22 Nov 2017 17:20:17 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list@cypress.com
Message-ID: <1906631797.229909.1511367617667@email.1und1.de> (sfid-20171122_172054_351151_CA5FEFE2)
In-Reply-To: <578431614.96494.1510505412682@email.1und1.de>
References: <578431614.96494.1510505412682@email.1und1.de>
Subject: Re: brcmfmac: Unable to handle kernel paging request at virtual
 address 726f6674616cd8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Stefan Wahren <stefan.wahren@i2se.com> hat am 12. November 2017 um 17:50 geschrieben:
> 
> 
> Hi,
> i discovered a random oops during probe of brcmfmac on Raspberry Pi 3 in yesterdays kernelci run for net-next [1]. I need to point out there is no DT entry for the wifi chip on Raspberry Pi 3 in the lack of a driver for the necessary GPIO expander. So the "HT Avail timeout" is expected.
> 
> I was also able to trigger this oops by calling "modprobe brcmfmac" on my Raspberry Pi 3 with latest linux-next.
> 
> Any help to fix this is appreciated.
> 
> [1] - https://storage.kernelci.org/net-next/master/v4.14-rc8-2221-ga8a6f1e4ea78/arm64/defconfig+kselftest/lab-baylibre/boot-bcm2837-rpi-3-b.txt
> 

the issue still persists in linux-next-20171122:

[  817.659632] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac43430-sdio.bin for chip 0x00a9a6(43430) rev 0x000001
[  817.672739] brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac43430-sdio.txt failed with error -2
[  818.708435] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
[  819.722103] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
[  819.755321] Unable to handle kernel paging request at virtual address 726f6674616cd8
[  819.763255] Mem abort info:
[  819.766131]   ESR = 0x96000004
[  819.769240]   Exception class = DABT (current EL), IL = 32 bits
[  819.775290]   SET = 0, FnV = 0
[  819.778416]   EA = 0, S1PTW = 0
[  819.781605] Data abort info:
[  819.784552]   ISV = 0, ISS = 0x00000004
[  819.788495]   CM = 0, WnR = 0
[  819.791532] [00726f6674616cd8] address between user and kernel address ranges
[  819.798805] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[  819.804469] Modules linked in: brcmfmac cfg80211 brcmutil vc4 cec drm_kms_helper drm bcm2835_rng rfkill rng_core smsc95xx usbnet bcm2835_dma crc32_ce pwm_bcm2835 i2c_bcm2835 ip_tables x_tables ipv6 [last unloaded: cfg80211]
[  819.824687] CPU: 3 PID: 92 Comm: kworker/3:1 Not tainted 4.14.0-next-20171122 #1
[  819.832207] Hardware name: Raspberry Pi 3 Model B Rev 1.2 (DT)
[  819.838152] Workqueue: events request_firmware_work_func
[  819.843561] task: ffff80003833aa00 task.stack: ffff000009498000
[  819.849583] pstate: 60000005 (nZCv daif -PAN -UAO)
[  819.854460] pc : mutex_lock+0xc/0x40
[  819.858101] lr : device_release_driver_internal+0x38/0x1f0
[  819.863676] sp : ffff00000949bbf0
[  819.867045] x29: ffff00000949bbf0 x28: 0000000000000000
[  819.872451] x27: ffff00000931bd20 x26: ffff000008f9fbb0
[  819.877856] x25: ffff80003833aa00 x24: ffff800036e20f80
[  819.883261] x23: 0000000000000000 x22: ffff800039fd3d00
[  819.888665] x21: 0000000000000000 x20: 6d726f6674616cd8
[  819.894068] x19: 6d726f6674616c78 x18: 0000000000000000
[  819.899473] x17: 0000ffffa52ba930 x16: ffff000008256b30
[  819.904877] x15: 0000000000000000 x14: 0000000000000400
[  819.910282] x13: 0000000000000400 x12: 0000000000000000
[  819.915685] x11: 0000000000000000 x10: 0000000000000001
[  819.921087] x9 : 0000000000000001 x8 : ffff800032fdec08
[  819.926493] x7 : ffff800032d7c158 x6 : 0000000000000000
[  819.931895] x5 : ffff800032d7c288 x4 : 0000000000000000
[  819.937299] x3 : ffff80003833aa00 x2 : 0000000000000000
[  819.942705] x1 : ffff80003833aa00 x0 : 6d726f6674616cd8
[  819.948112] Process kworker/3:1 (pid: 92, stack limit = 0xffff000009498000)
[  819.955188] Call trace:
[  819.957681]  mutex_lock+0xc/0x40
[  819.960967]  device_release_driver+0x14/0x20
[  819.965450]  brcmf_sdio_firmware_callback+0x160/0x578 [brcmfmac]
[  819.971689]  brcmf_fw_request_nvram_done+0x258/0x5e8 [brcmfmac]
[  819.977717]  request_firmware_work_func+0x34/0x60
[  819.982510]  process_one_work+0x1cc/0x328
[  819.986592]  worker_thread+0x50/0x450
[  819.990320]  kthread+0xf8/0x128
[  819.993516]  ret_from_fork+0x10/0x18
[  819.997154] Code: d65f03c0 d5384101 d2800002 f9800011 (c85ffc03)
[  820.003351] ---[ end trace f4bff35241327a18 ]---
