Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward3p.cmail.yandex.net ([77.88.31.18]:45582 "EHLO
        forward3p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752299AbdHBUy0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 16:54:26 -0400
From: "russianneuromancer@ya.ru" <russianneuromancer@ya.ru>
To: Hans de Goede <hdegoede@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>
In-Reply-To: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
References: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
Subject: Re: brcm43430 sdio wifi regression with 4.13-rc1
MIME-Version: 1.0
Message-Id: <1570131501706612@web24o.yandex.ru> (sfid-20170802_225430_609762_776CD8FB)
Date: Thu, 03 Aug 2017 04:43:32 +0800
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Sorry for late answer.

> russianneuromancer has reported seeing a similar problem with 4.13.

> russianneuromancer, can you check if the device you are seeing this with
also has a brcm43430 sdio wifi and if so if switching to:

> http://jwrdegoede.danny.cz/brcm-firmware/brcmfmac43430-sdio.bin.7.45.77.0.ucode1043.2054

> Fixes this ?

Judging by this error message

> [    7.744262] brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac43241b4-sdio.txt failed with error -2

Lenovo Miix2 8 have brcm43241b4 sdio wifi. 

With brcmfmac43241b4-sdio.txt from NVRAM, as suggested here https://wireless.wiki.kernel.org/en/users/drivers/brcm80211 WiFi connection works for me with upstream Linux 4.12.4, but doesn't work with Linux 4.13rc1 and Linux 4.13rc3.

Few connection attempts with Linux 4.13rc3 looks like this:

> [    7.779370] usbcore: registered new interface driver brcmfmac
> [    7.948487] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jul 17 2013 07:36:07 version 6.10.197.71 (r412987) FWID 01-882d2634
> [   32.282374] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
> [   32.282393] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlan0 type 10 failed: err=-16
> [   43.560596] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   44.494422] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   45.492956] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   46.491317] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   54.922652] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   55.849565] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   56.849437] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   57.853150] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   66.542999] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   67.483115] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
> [   68.483434] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0

23.07.2017, 02:44, "Hans de Goede" <hdegoede@redhat.com>:
> Hi,
>
> When upgrading my devel environment to 4.13-rc1+ I noticed that
> the brcm43430 sdio wifi on a Chuwi Hi8 plus stopped working:
>
> jul 22 14:13:23 localhost.localdomain kernel: brcmfmac: brcmf_sdio_probe: Loading firmware brcm/brcmfmac43430-sdio.bin for chip 0000a9a6 rev 00000001
> jul 22 14:13:23 localhost.localdomain kernel: usbcore: registered new interface driver brcmfmac
> jul 22 14:13:23 localhost.localdomain kernel: brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Aug 29 2016 20:48:16 version 7.45.41.26 (r640327) FWID 01-4527cfab
> jul 22 14:13:23 localhost.localdomain kernel: brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
> jul 22 14:13:26 localhost.localdomain kernel: brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> jul 22 14:13:28 localhost.localdomain kernel: brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> jul 22 14:13:31 localhost.localdomain kernel: brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> <repeats>
>
> The real culprit here seems to be:
>
> jul 22 14:13:23 localhost.localdomain kernel: brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
>
> I've tried reverting allmost all changes under drivers/net/wireless/broadcom/brcm80211
> as well as those under drivers/mmc, but that did not help.
>
> Googling for the "Unknown mailbox data content" error found some Raspberry Pi 3
> related comments where users report success with a different firmware version
> from: https://android.googlesource.com/platform/hardware/broadcom/wlan/+/master/bcmdhd/firmware/bcm4343/
>
> So I tried that as well as a version extracted from the Android install
> on the tablet and both work fine, only the "version 7.45.41.26" which
> happens to be the one in linux-firmware causes this problem, I've put
> all (Linux build, not NDIS) versions I could find here:
>
> http://jwrdegoede.danny.cz/brcm-firmware/
>
> I've the feeling that the 7.45.41.26 version is a bit buggy / suspect to
> certain timing problems and 4.13 just happens to trigger those timing
> conditions...
>
> russianneuromancer has reported seeing a similar problem with 4.13.
>
> russianneuromancer, can you check if the device you are seeing this with
> also has a brcm43430 sdio wifi and if so if switching to:
>
> http://jwrdegoede.danny.cz/brcm-firmware/brcmfmac43430-sdio.bin.7.45.77.0.ucode1043.2054
>
> Fixes this ?
>
> Regards,
>
> Hans
