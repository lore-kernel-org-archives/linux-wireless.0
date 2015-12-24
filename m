Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33127 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbbLXRXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 12:23:23 -0500
Received: by mail-wm0-f41.google.com with SMTP id p187so183669509wmp.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Dec 2015 09:23:22 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 24 Dec 2015 18:23:22 +0100
Message-ID: <CAOQ7t2bEs2UhxfWUCs7TBwidw2JKCKLmeUzcYjng4f5p4Wr-Mw@mail.gmail.com> (sfid-20151224_182327_543450_47CC9CE3)
Subject: [BISECTED] brcmfmac issue since 4.3.0-rc3
From: Carlo Caione <carlo@caione.org>
To: meuleman@broadcom.com
Cc: arend@broadcom.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hante,
I'm having an issue with my BCM43340 SDIO WiFi card on the Asus X205TA
laptop and the latest firmware taken from the linux-firmware git repo
with the correct nvram file in place. I bisected the issue back to
commit 2b76acd "brcmfmac: Rework p2p attach, use single method for p2p
dev creation." (bad commit).

The problem is not always reproducible. I'd say it happens once every
ten reboots. What I see is that the kernel panics at boot immediately
after I see:

brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive strength init
done for chip 43340 rev 2 pmurev 20
brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -52
brcmfmac: brcmf_bus_start: failed: -52
brcmfmac: brcmf_sdio_firmware_callback: dongle is not responding
brcmfmac: brcmf_sdio_dpc: failed backplane access over SDIO, halting operation
brcmfmac: brcmf_sdio_dpc: failed backplane access over SDIO, halting operation

With a messy trace similar to
https://gist.github.com/carlocaione/06d17124a2589f3d4108

Any idea what's going on?

Thanks

-- 
Carlo Caione
