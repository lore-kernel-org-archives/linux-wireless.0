Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750864AbdGVSn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Jul 2017 14:43:56 -0400
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: russianneuromancer <russianneuromancer@ya.ru>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
From: Hans de Goede <hdegoede@redhat.com>
Subject: brcm43430 sdio wifi regression with 4.13-rc1
Message-ID: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com> (sfid-20170722_204400_545738_08E9EF96)
Date: Sat, 22 Jul 2017 20:43:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When upgrading my devel environment to 4.13-rc1+ I noticed that
the brcm43430 sdio wifi on a Chuwi Hi8 plus stopped working:

jul 22 14:13:23 localhost.localdomain kernel: brcmfmac: brcmf_sdio_probe: Loading firmware brcm/brcmfmac43430-sdio.bin for chip 0000a9a6 rev 00000001
jul 22 14:13:23 localhost.localdomain kernel: usbcore: registered new interface driver brcmfmac
jul 22 14:13:23 localhost.localdomain kernel: brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Aug 29 2016 20:48:16 version 7.45.41.26 (r640327) FWID 01-4527cfab
jul 22 14:13:23 localhost.localdomain kernel: brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
jul 22 14:13:26 localhost.localdomain kernel: brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
jul 22 14:13:28 localhost.localdomain kernel: brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
jul 22 14:13:31 localhost.localdomain kernel: brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
<repeats>

The real culprit here seems to be:

jul 22 14:13:23 localhost.localdomain kernel: brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012


I've tried reverting allmost all changes under drivers/net/wireless/broadcom/brcm80211
as well as those under drivers/mmc, but that did not help.

Googling for the "Unknown mailbox data content" error found some Raspberry Pi 3
related comments where users report success with a different firmware version
from: https://android.googlesource.com/platform/hardware/broadcom/wlan/+/master/bcmdhd/firmware/bcm4343/

So I tried that as well as a version extracted from the Android install
on the tablet and both work fine, only the "version 7.45.41.26" which
happens to be the one in linux-firmware causes this problem, I've put
all (Linux build, not NDIS) versions I could find here:

http://jwrdegoede.danny.cz/brcm-firmware/

I've the feeling that the 7.45.41.26 version is a bit buggy / suspect to
certain timing problems and 4.13 just happens to trigger those timing
conditions...

russianneuromancer has reported seeing a similar problem with 4.13.

russianneuromancer, can you check if the device you are seeing this with
also has a brcm43430 sdio wifi and if so if switching to:

http://jwrdegoede.danny.cz/brcm-firmware/brcmfmac43430-sdio.bin.7.45.77.0.ucode1043.2054

Fixes this ?

Regards,

Hans
