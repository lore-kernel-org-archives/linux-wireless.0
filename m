Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:42354 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751293AbdGQRuY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 13:50:24 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Subject: BUG: brcmfmac: add firmware feature detection for gscan feature
 breaks 43430a1
Message-ID: <25c47ffe-af3e-fb85-ed5b-ff1987cfd93f@mnementh.co.uk> (sfid-20170717_195028_764804_AC3DAC29)
Date: Mon, 17 Jul 2017 18:50:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resent due to subject error. Apologies, Hante :)

Hi Folks,

9fe929aaace6  brcmfmac: add firmware feature detection for gscan feature

Completely breaks 43430a1 support.

This was tested on top of my last patchset - but the same occurs on top
of vanilla 4.13-rc1

[   15.703014]  [1 ] core 0x800:49 base 0x18000000 wrap 0x18100000
[   15.703025]  [2 ] core 0x812:39 base 0x18001000 wrap 0x18101000
[   15.703036]  [3 ] core 0x829:21 base 0x18002000 wrap 0x18102000
[   15.703044]  [4 ] core 0x82a:9  base 0x18003000 wrap 0x18103000
[   15.703052]  [5 ] core 0x80e:22 base 0x18004000 wrap 0x18104000
[   15.703059]  [6 ] core 0x135:0  base 0x00000000 wrap 0x18105000
[   15.703067]  [7 ] core 0x240:0  base 0x00000000 wrap 0x18106000
[   15.703070] Enter
[   15.735280] RAM: base=0x0 size=524288 (0x80000) sr=65536 (0x10000)
[   15.735293] Found BCM43430, AXI backplane, rev=1
[   15.735461] ccrev=49, pmurev=24, pmucaps=0x39d25f18
[   15.904051] Enter
[   15.974045] Enter
[   15.984378] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
Aug 29 2016 20:48:16 version 7.45.41.26 (r640327) FWID 01-4527cfab
[   16.009363] brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data
content: 0x40012
...
[   18.566406] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
...
[   21.126419] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   23.686371] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
...
[   26.246357] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   28.806347] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   31.366355] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   33.926319] brcmfmac: brcmf_proto_bcdc_query_dcmd:
brcmf_proto_bcdc_msg failed w/status -110
[   36.486448] brcmfmac: brcmf_proto_bcdc_query_dcmd:
brcmf_proto_bcdc_msg failed w/status -110
[   36.497332] brcmfmac: brcmf_cfg80211_attach: Failed to get D11
version (-110)
[   36.504059] brcmfmac: brcmf_bus_started: failed: -12
[   36.517686] brcmfmac: brcmf_sdio_firmware_callback: dongle is not
responding
[   36.586256] Enter

-Ian
