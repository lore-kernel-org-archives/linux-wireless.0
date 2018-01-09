Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34576 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759793AbeAIQuE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 11:50:04 -0500
Received: by mail-pf0-f173.google.com with SMTP id e76so4161511pfk.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jan 2018 08:50:04 -0800 (PST)
Received: from [192.168.1.131] ([50.51.72.82])
        by smtp.googlemail.com with ESMTPSA id l80sm30880176pfk.67.2018.01.09.08.50.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jan 2018 08:50:02 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Kyle Evans <kvans32@gmail.com>
Subject: brcmfmac4329-sdio firmware load failed.
Message-ID: <7c73dc36-5b7a-729e-4656-b45839c1360d@gmail.com> (sfid-20180109_175023_108848_FE582121)
Date: Tue, 9 Jan 2018 12:51:15 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is linux-4.15-rc2 on an ASUS TF101. This device was shipped with 
Android and a custom kernel using bcmdhd. I have taken nvram.txt from 
/system/etc/ on the stock filesystem and copied to 
/lib/firmware/brcm/brcmfmac4329-sdio.txt. Below is the result.

[    2.729157] brcmfmac: F1 signature read @0x18000000=0x9934329
[    2.734313] brcmfmac: brcmf_sdiod_regrw_helper: failed to read data 
F1@0x080ac, err: -84
[    2.739952] brcmfmac: brcmf_fw_map_chip_to_name: using 
brcm/brcmfmac4329-sdio.bin for chip 0x004329(17193) rev 0x000003
[    2.965820] brcmfmac mmc0:0001:1: Direct firmware load for 
brcm/brcmfmac4329-sdio.clm_blob failed with error -2
[    2.969658] brcmfmac mmc0:0001:1: Falling back to user helper
[   64.489695] brcmfmac: brcmf_c_process_clm_blob: request CLM blob file 
failed (-11)
[   64.489720] brcmfmac: brcmf_c_preinit_dcmds: download CLM blob file 
failed, -11
[   64.489739] brcmfmac: brcmf_bus_started: failed: -11
[   64.489783] brcmfmac: brcmf_sdio_firmware_callback: dongle is not 
responding
[   64.596281] [<c061fd98>] (device_release_driver_internal) from 
[<c068f394>] (brcmf_sdio_firmware_callback+0x244/0x5b8)
[   64.596500] [<c068f394>] (brcmf_sdio_firmware_callback) from 
[<c0686870>] (brcmf_fw_request_nvram_done+0x1cc/0x73c)
[   64.596716] [<c0686870>] (brcmf_fw_request_nvram_done) from 
[<c063337c>] (request_firmware_work_func+0x3c/0x64)

md5sum /lib/firmware/brcm/brcmfmac4329*
ff610cee869375a2d0c0be6b97b107fb  \
	/lib/firmware/brcm/brcmfmac4329-sdio.bin
84ecaf20d459b11b720d6b5884040553  \
	/lib/firmware/brcm/brcmfmac4329-sdio.txt

-Kyle
