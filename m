Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:50622 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751320AbdGQTD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 15:03:28 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        davem@davemloft.net
From: Ian Molton <ian@mnementh.co.uk>
Subject: BUG: brcmfmac: rework headroom check in .start_xmit() causes 43430a1
 to fail.
Message-ID: <86761c42-c91d-d4a7-3ba4-314612dd7fd1@mnementh.co.uk> (sfid-20170717_210332_180416_8095F9DA)
Date: Mon, 17 Jul 2017 20:03:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

I've found that:

270a6c1f65fe brcmfmac: rework headroom check in .start_xmit()

Causes the 43430a1 to become non-responsive. The log starts emitting
these messages:

brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
net_ratelimit: 3 callbacks suppressed
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0
brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received,
flags 0x0

Without this commit, the card works fine.

Again, Firmware version = wl0: Aug 29 2016 20:48:16 version 7.45.41.26
(r640327) FWID 01-4527cfab

Does anyone actually test these commits before applying to mainline?

Thats two total breakages I've found that are verifiable at module load
time in the last couple of hours.

Even if this is a case of me having old firmware - this should not cause
this issue- at worst the driver should refuse to load. Better, it should
disable or work around known bugs.

-Ian
