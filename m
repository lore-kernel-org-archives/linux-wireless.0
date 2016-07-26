Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:36048 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbcGZWfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2016 18:35:25 -0400
Received: by mail-yw0-f179.google.com with SMTP id u134so37334748ywg.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2016 15:35:24 -0700 (PDT)
MIME-Version: 1.0
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 26 Jul 2016 19:35:23 -0300
Message-ID: <CAOMZO5Cu_UO6L9wYy6eJUJwEE25BN-qeBRAMbFveFrJKHtF=aw@mail.gmail.com> (sfid-20160727_003529_283723_36173D06)
Subject: brcm4330 fails to load on newer kernels
To: Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On a imx6sl-warp board with a brcm4330 I get the following results
depending on the kernel version:

- Kernel 4.4.15: place brcmfmac4330-sdio.bin and brcmfmac4330-sdio.txt
in the rootfs and the kernel is able to read them correctly. wlan0 is
present. All is fine.

- Kernel 4.5.7: place brcmfmac4330-sdio.bin brcmfmac4330-sdio.txt in
the rootfs and the kernel fails to load them:

brcmfmac mmc1:0001:1: Direct firmware load for
brcm/brcmfmac4330-sdio.bin failed with error -2

Then I build brcmfmac4330-sdio.bin brcmfmac4330-sdio.txt into the
kernel and then firmware is detected and wlan0 appears.

- Kernel 4.7: I can place the firmware and nvram file into the rootfs
or built-i and the following error is seen:

brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50

So wlan0 never appears here.

Does anyone have any suggestions about these different behaviours?

Thanks,

Fabio Estevam
