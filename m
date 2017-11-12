Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:63525 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdKLQuW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Nov 2017 11:50:22 -0500
Date: Sun, 12 Nov 2017 17:50:12 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com
Message-ID: <578431614.96494.1510505412682@email.1und1.de> (sfid-20171112_175054_585341_CB80B1D4)
Subject: brcmfmac: Unable to handle kernel paging request at virtual address
 726f6674616cd8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
i discovered a random oops during probe of brcmfmac on Raspberry Pi 3 in yesterdays kernelci run for net-next [1]. I need to point out there is no DT entry for the wifi chip on Raspberry Pi 3 in the lack of a driver for the necessary GPIO expander. So the "HT Avail timeout" is expected.

I was also able to trigger this oops by calling "modprobe brcmfmac" on my Raspberry Pi 3 with latest linux-next.

Any help to fix this is appreciated.

[1] - https://storage.kernelci.org/net-next/master/v4.14-rc8-2221-ga8a6f1e4ea78/arm64/defconfig+kselftest/lab-baylibre/boot-bcm2837-rpi-3-b.txt

[   94.922915] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   94.933262] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   94.940503] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   94.950222] cfg80211: failed to load regulatory.db
[   94.977028] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac43430-sdio.bin for chip 0x00a9a6(43430) rev 0x000001
[   94.990977] brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac43430-sdio.txt failed with error -2
[   96.021578] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
[   97.034210] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
[   97.071241] Unable to handle kernel paging request at virtual address 726f6674616cd8
[   97.079464] Mem abort info:
[   97.082437]   ESR = 0x96000004
[   97.085744]   Exception class = DABT (current EL), IL = 32 bits
[   97.092140]   SET = 0, FnV = 0
[   97.095438]   EA = 0, S1PTW = 0
[   97.098775] Data abort info:
[   97.101851]   ISV = 0, ISS = 0x00000004
[   97.105942]   CM = 0, WnR = 0
[   97.118824] [00726f6674616cd8] address between user and kernel address ranges
[   97.135901] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[   97.151348] Modules linked in: brcmfmac cfg80211 brcmutil vc4 cec drm_kms_helper drm crc32_ce smsc95xx rfkill bcm2835_rng usbnet rng_core pwm_bcm2835 bcm2835_dma i2c_bcm2835 ip_tables x_tables ipv6 [last unloaded: cfg80211]
[   97.182218] CPU: 3 PID: 92 Comm: kworker/3:1 Tainted: G        W        4.14.0-rc8-next-20171110 #1
[   97.202052] Hardware name: Raspberry Pi 3 Model B Rev 1.2 (DT)
[   97.218562] Workqueue: events request_firmware_work_func
[   97.234663] task: ffff8000372dd400 task.stack: ffff000009420000
[   97.251451] pstate: 60000005 (nZCv daif -PAN -UAO)
[   97.267105] pc : mutex_lock+0x30/0x60
[   97.281628] lr : mutex_lock+0x24/0x60
[   97.296124] sp : ffff000009423bd0
[   97.309945] x29: ffff000009423bd0 x28: 0000000000000000 
[   97.325824] x27: ffff00000932bd20 x26: ffff000008fafbf0 
[   97.341362] x25: ffff8000372dd400 x24: ffff800036d8c100 
[   97.356869] x23: 0000000000000000 x22: ffff800038fd3d00 
[   97.372367] x21: 0000000000000000 x20: 6d726f6674616cd8 
[   97.387876] x19: 6d726f6674616cd8 x18: 0000000000000000 
[   97.403458] x17: 0000ffffacf22930 x16: ffff00000825b470 
[   97.419094] x15: 0000000000000000 x14: 0000000000000400 
[   97.434747] x13: 0000000000000400 x12: 0000000000000000 
[   97.450344] x11: 0000000000000000 x10: 0000000000000000 
[   97.465868] x9 : 0000000000000000 x8 : ffff8000312aa9a8 
[   97.481377] x7 : ffff8000312a1458 x6 : 0000000000000000 
[   97.496942] x5 : 0000000000000000 x4 : ffff8000372dd400 
[   97.512552] x3 : 0000000000000000 x2 : 0000000004208060 
[   97.528144] x1 : 0000000000000000 x0 : ffff8000372dd400 
[   97.543741] Process kworker/3:1 (pid: 92, stack limit = 0xffff000009420000)
[   97.561203] Call trace:
[   97.574047]  mutex_lock+0x30/0x60
[   97.587808]  device_release_driver_internal+0x38/0x1f0
[   97.603563]  device_release_driver+0x14/0x20
[   97.618589]  brcmf_sdio_firmware_callback+0x160/0x578 [brcmfmac]
[   97.635534]  brcmf_fw_request_nvram_done+0x258/0x5e8 [brcmfmac]
[   97.652336]  request_firmware_work_func+0x34/0x60
[   97.667928]  process_one_work+0x1ac/0x328
[   97.682825]  worker_thread+0x50/0x460
[   97.697361]  kthread+0x104/0x130
[   97.711466]  ret_from_fork+0x10/0x18
[   97.725960] Code: 97dc9c70 d2800001 d5384100 f9800271 (c85ffe62) 
[   97.743203] ---[ end trace a27498e726fb3a35 ]---
