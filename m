Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33099 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdANXTG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Jan 2017 18:19:06 -0500
Received: by mail-lf0-f65.google.com with SMTP id x1so3726903lff.0
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jan 2017 15:19:05 -0800 (PST)
MIME-Version: 1.0
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sun, 15 Jan 2017 00:18:44 +0100
Message-ID: <CAFBinCDyQqDQ3mS4H0qZCzHs7xYKwxRqvfboU4ibdN0WNmpkQA@mail.gmail.com> (sfid-20170115_001916_117499_7642DB1D)
Subject: support for Ampak AP6255 (bcm43455c0 with SDIO device ID 0xa9bf)
To: brcm80211-dev-list.pdl@broadcom.com
Cc: arend.vanspriel@broadcom.com, hante.meuleman@broadcom.com,
        linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a1142b0ee2d56e10546162ddd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a1142b0ee2d56e10546162ddd
Content-Type: text/plain; charset=UTF-8

Hello,

I recently got a "Khadas VIM Pro" (see [0] for more information)
The "Pro" version comes with an AP6255 wifi chipset.
Looking at the vendor firmware this seems to be a bcm43455 device: [1]

To my surprise brcmfmac from a mainline 4.10-rc3 kernel did not pick
this device up.
So I started investigating:
$ grep "" /sys/class/mmc_host/mmc2/mmc2\:0001/mmc2\:0001\:*/{class,device,vendor}
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:1/class:0x00
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:2/class:0x00
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:3/class:0x02
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:1/device:0xa9bf
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:2/device:0xa9bf
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:3/device:0xa9bf
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:1/vendor:0x02d0
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:2/vendor:0x02d0
/sys/class/mmc_host/mmc2/mmc2:0001/mmc2:0001:3/vendor:0x02d0

I then went ahead and added the device ID to
drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c (sample
patch attached)
as a result of that the device is now being detected.
it boots fine with the firmware found in linux-firmware: [2] (plus the
nvram.txt from the vendor repo [1] renamed to brcmfmac43455-sdio.txt)

$ cat /sys/kernel/debug/brcmfmac/mmc2\:0001\:1/revinfo
vendorid: 0x14e4
deviceid: 0x43ab
radiorev: 0.88.3.11
chipnum: 17221 (4345)
chiprev: 6
chippkg: 2
corerev: 54
boardid: 0x06e4
boardvendor: 0x14e4
boardrev: P304
driverrev: 7.45.18
ucoderev: 0
bus: 0
phytype: 11
phyrev: 20
anarev: 0
nvramrev: 00079ac5

downloading a random 100MB file from the internet using curl confirms this.
There are no hangs, connection drops, other devices are also working fine.

the problem I'm facing is very simply (but unfortunately a very common
development problem): naming things (the SDIO_DEVICE_ID_BROADCOM_TODO
constant)!
there's already a definition for SDIO_DEVICE_ID_BROADCOM_4345 with
value 0x4345, does that mean 0xa9bf should be
SDIO_DEVICE_ID_BROADCOM_43455?


Regards,
Martin


[0] http://khadas.com/vim/
[1] https://github.com/khadas/android_hardware_amlogic_wifi/tree/b6709758755568e4a0ff6e80993be0fc64c77fb9/bcm_ampak/config/6255
[2] https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/brcm/brcmfmac43455-sdio.bin?id=b9a38d041d38ac6cf47274e9933f8083e12fc601

--001a1142b0ee2d56e10546162ddd
Content-Type: text/x-patch; charset=US-ASCII; name="brmcfmac-sdio-0xa9bf.patch"
Content-Disposition: attachment; filename="brmcfmac-sdio-0xa9bf.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixxucksd0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNt
Zm1hYy9iY21zZGguYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9i
cmNtZm1hYy9iY21zZGguYwppbmRleCA3MjEzOWI1NzliMTguLjcyMDZiYjFmOTkwOCAxMDA2NDQK
LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2Jj
bXNkaC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNt
Zm1hYy9iY21zZGguYwpAQCAtMTEwNiw2ICsxMTA2LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBz
ZGlvX2RldmljZV9pZCBicmNtZl9zZG1tY19pZHNbXSA9IHsKIAlCUkNNRl9TRElPX0RFVklDRShT
RElPX0RFVklDRV9JRF9CUk9BRENPTV80MzQ1KSwKIAlCUkNNRl9TRElPX0RFVklDRShTRElPX0RF
VklDRV9JRF9CUk9BRENPTV80MzU0KSwKIAlCUkNNRl9TRElPX0RFVklDRShTRElPX0RFVklDRV9J
RF9CUk9BRENPTV80MzU2KSwKKwlCUkNNRl9TRElPX0RFVklDRSgweGE5YmYpLAogCXsgLyogZW5k
OiBhbGwgemVyb2VzICovIH0KIH07CiBNT0RVTEVfREVWSUNFX1RBQkxFKHNkaW8sIGJyY21mX3Nk
bW1jX2lkcyk7Cgo=
--001a1142b0ee2d56e10546162ddd--
