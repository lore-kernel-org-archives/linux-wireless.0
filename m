Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:65064 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbdF1Tdi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 15:33:38 -0400
Date: Wed, 28 Jun 2017 21:33:08 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: arend.vanspriel@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Message-ID: <384537059.123625.1498678388857@email.1und1.de> (sfid-20170628_213341_409454_4DF458BE)
Subject: brcmfmac: BCM43431 won't get probed on Raspberry Pi Zero W
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

i'm currently working on Raspberry Pi Zero W for Mainline. Here is my first patch series [1].

Unfortunately i didn't get brcmfmac (connected via SDIO) probed with this patch series against 4.12.0-rc5-next-20170616+

[    8.389167] brcmfmac: F1 signature read @0x18000000=0x1541a9a6
[    8.735111] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: May 27 2016 00:13:38 version 7.45.41.26 (r640327) FWID 01-df77e4a7
[    8.786016] brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
[   11.288798] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   11.292822] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
[   13.848777] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   13.852974] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
[   16.408762] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   16.413004] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
[   18.968769] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   18.972965] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
[   21.528743] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   21.532924] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
[   24.088745] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   24.092948] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
[   26.648764] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
[   26.648789] brcmfmac: brcmf_cfg80211_attach: Failed to get D11 version (-110)
[   26.648831] brcmfmac: brcmf_bus_started: failed: -12
[   26.648842] brcmfmac: brcmf_sdio_firmware_callback: dongle is not responding

I already tried the additional patches from Gerd Hofmann's repo [2], but this didn't improve anything.

Any ideas what could be the problem?

Thanks
Stefan

[1] - http://lists.infradead.org/pipermail/linux-rpi-kernel/2017-June/006598.html
[2] - https://www.kraxel.org/cgit/linux/log/?h=bcm2837
