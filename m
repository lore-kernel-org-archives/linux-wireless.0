Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:56312 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdGQNL1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 09:11:27 -0400
Date: Mon, 17 Jul 2017 15:10:53 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: arend.vanspriel@broadcom.com, hante.meuleman@broadcom.com,
        pieter-paul.giesberts@broadcom.com, franky.lin@broadcom.com,
        kvalo@codeaurora.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Message-ID: <1133935948.74840.1500297053336@email.1und1.de> (sfid-20170717_151131_391516_8F47C117)
In-Reply-To: <384537059.123625.1498678388857@email.1und1.de>
References: <384537059.123625.1498678388857@email.1und1.de>
Subject: Re: brcmfmac: BCM43431 won't get probed on Raspberry Pi Zero W
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Stefan Wahren <stefan.wahren@i2se.com> hat am 28. Juni 2017 um 21:33 geschrieben:
> 
> 
> Hi,
> 
> i'm currently working on Raspberry Pi Zero W for Mainline. Here is my first patch series [1].
> 
> Unfortunately i didn't get brcmfmac (connected via SDIO) probed with this patch series against 4.12.0-rc5-next-20170616+
> 
> [    8.389167] brcmfmac: F1 signature read @0x18000000=0x1541a9a6
> [    8.735111] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: May 27 2016 00:13:38 version 7.45.41.26 (r640327) FWID 01-df77e4a7
> [    8.786016] brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
> [   11.288798] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> [   11.292822] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   13.848777] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> [   13.852974] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   16.408762] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> [   16.413004] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   18.968769] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> [   18.972965] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   21.528743] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> [   21.532924] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   24.088745] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> [   24.092948] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   26.648764] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
> [   26.648789] brcmfmac: brcmf_cfg80211_attach: Failed to get D11 version (-110)
> [   26.648831] brcmfmac: brcmf_bus_started: failed: -12
> [   26.648842] brcmfmac: brcmf_sdio_firmware_callback: dongle is not responding
> 
> I already tried the additional patches from Gerd Hofmann's repo [2], but this didn't improve anything.
> 
> Any ideas what could be the problem?

i found out that 4.12 didn't have the problem and rebased my changes [3].

Now 4.13-rc1 is out and i bisected the regression:

5771a8c08880cdca3bfb4a3fc6d309d6bba20877 bad
6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c good
e5f76a2e0e84ca2a215ecbf6feae88780d055c56 bad
1849f800fba32cd5a0b647f824f11426b85310d8 good
ca7bbc845e0aa2d9d6d252e72f0a2602ebd16361 bad
0c90e9c6b5549825e410b6589ad6c4478f81ebad good
44e179da0e27a1cc1001becefa0931634dbafae3 bad
219569ad0c41df7a7f999a2cad688c6b6ce173e2 bad
fb53905cf2c3db6eb1ce37a37c5002456fa7ee20 bad
37a5be0cfca6487bbdf423a09dfe70e9bfb049db bad
a3b2ba8666b7947eb323368b5c6f751450e61766 bad
21f569af9ab3608382482166ae9aba802b097e3f bad
94ed6ffb7965aa09409a5ff7d17b2f84ed085c3c bad
a95cfad947d5f40cfbf9ad3019575aac1d8ac7a6 good

9fe929aaace6a3019dd64a70063cc7b0bb956a4e bad

brcmfmac: add firmware feature detection for gscan feature
Detect gscan support in firmware by doing pfn_gscan_cfg iovar with
invalid version.

Unfortunately this commit cannot be simply reverted and i wasn't sure about the dependencies. So i need to revert the following commits to get it running with 4.13-rc1:

123fef3fd4ae6052bad5cf1623c49845d16a6c67
2526ff21aa77c205f72e8263335f20b7d7e636fc
b8a64f0e96c2b258321ee03975aeb0f5e88a055b
69897f390b006948ca4cfa37174fa653a0ef7223
42596f761449595e3f0f18ce57c88472ad2d6160
efc2c1fa8e145b60a7805fa9b6c92ac0746fccc3
94ed6ffb7965aa09409a5ff7d17b2f84ed085c3c
9fe929aaace6a3019dd64a70063cc7b0bb956a4e

Would be nice to get this fixed.

Regards
Stefan

[3] - https://github.com/lategoodbye/rpi-zero/commits/rpi-zero-w-v2

> 
> Thanks
> Stefan
> 
> [1] - http://lists.infradead.org/pipermail/linux-rpi-kernel/2017-June/006598.html
> [2] - https://www.kraxel.org/cgit/linux/log/?h=bcm2837
