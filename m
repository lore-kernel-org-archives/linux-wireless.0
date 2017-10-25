Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:55407 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdJYRdF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 13:33:05 -0400
Received: by mail-lf0-f46.google.com with SMTP id p184so818502lfe.12
        for <linux-wireless@vger.kernel.org>; Wed, 25 Oct 2017 10:33:04 -0700 (PDT)
MIME-Version: 1.0
From: Dennis Millard <macphyter@gmail.com>
Date: Wed, 25 Oct 2017 11:33:02 -0600
Message-ID: <CAPUyO0_3sabBk1Zf4evRt0RoH-yLLE-BtGAqSkHeu6udcg4pkA@mail.gmail.com> (sfid-20171025_193318_907576_C191A2BF)
Subject: brcmfmac on Inventek 43341 module over sdio
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been trying to bring up this BRC43341 module on an nVidia TX1
plugged into the uSD card slot and I'm having some trouble with the
driver.  First of all, the uSD card slot works fine with uSD memory
cards.  Now I've got this eval board from Inventek, the
ISM43340-L77-EVB which plugs into the uSD card slot.

I've enabled brcmfmac in the kernel config and things started off very
well.  I had to modify the driver code to add support for the 43341
firmware and nvram filenames, but that all seems to be working.  I got
the firmware and nvram files directly from Inventek.  When I insert
the card, I can see it detected, and the driver starts talking to it.
It configures a few registers, and then the firmware and nvram are
getting loaded successfully, as evidenced by this:

[   31.935443] brcmfmac: [2] brcmf_sdio_download_code_file Enter
[   32.122020] brcmfmac: [4] brcmf_sdio_verifymemory Compare RAM dl &
ul at 0x00000000; size=368538
[   32.497360] brcmfmac: [2] brcmf_sdio_download_nvram Enter
[   32.504947] brcmfmac: [4] brcmf_sdio_verifymemory Compare RAM dl &
ul at 0x0007fa48; size=1464
[   32.516009] brcmfmac: [2] brcmf_chip_set_active Enter
[   32.523964] brcmfmac: [2] brcmf_sdiod_change_state 0 -> 1
[   32.529422] brcmfmac: [2] brcmf_bus_change_state 0 -> 1

What happens next, as near as I can tell, is that the inband interrupt
gets configured, and then pretty quickly I get an interrupt for a bad
CRC, then a register dump.

[   32.664411] brcmfmac: [131072] brcmf_sdio_bus_sleep Enter: request
WAKE currently WAKE
[   32.664413] brcmfmac: [131072] brcmf_sdio_clkctl Enter
[   32.664415] brcmfmac: [131072] brcmf_sdio_bus_sleep new state WAKE
[   32.664416] brcmfmac: [131072] brcmf_sdio_bus_sleep Exit: err=0
[   32.664418] brcmfmac: [131072] brcmf_sdio_hostmail Enter
[   32.664610] brcmfmac: [131072] brcmf_sdio_hostmail Dongle ready,
protocol version 4
[   32.664612] brcmfmac: [131072] brcmf_sdio_bus_sleep Enter: request
WAKE currently WAKE
[   32.664614] brcmfmac: [131072] brcmf_sdio_clkctl Enter
[   32.664615] brcmfmac: [131072] brcmf_sdio_bus_sleep new state WAKE
[   32.664617] brcmfmac: [131072] brcmf_sdio_bus_sleep Exit: err=0
[   32.664618] brcmfmac: [2] brcmf_chip_sr_capable Enter
[   32.665150] brcmfmac: [4] brcmf_sdio_readshared sdpcm_shared
address 0x0003D538
[   32.665519] brcmfmac: [2] brcmf_sdio_readframes Enter
[   32.665524] brcmfmac: [131072] brcmf_sdiod_recv_pkt addr =
0x18000000, size = 64
[   32.665591] mmc1: sdhci_cmd_irq 2634 SDHCI_INT_CRC intmask: 20001
Interface clock = 6000000Hz
[   32.665592] sdhci: =========== REGISTER DUMP (mmc1)===========
[   32.665597] sdhci: Sys addr: 0x00000000 | Version:  0x00000303
[   32.665601] sdhci: Blk size: 0x00007040 | Blk cnt:  0x00000001
[   32.665605] sdhci: Argument: 0x21000040 | Trn mode: 0x00000013
[   32.665608] sdhci: Present:  0x01db0008 | Host ctl: 0x00000016
[   32.665612] sdhci: Power:    0x00000001 | Blk gap:  0x00000000
[   32.665616] sdhci: Wake-up:  0x00000000 | Clock:    0x00000007
[   32.665619] sdhci: Timeout:  0x0000000e | Int stat: 0x00000000
[   32.665623] sdhci: Int enab: 0x02ff000b | Sig enab: 0x02fc000b
[   32.665626] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[   32.665630] sdhci: Caps:     0x376cd08c | Caps_1:   0x10006f73
[   32.665634] sdhci: Cmd:      0x0000353a | Max curr: 0x00000000
[   32.665636] sdhci: Host ctl2: 0x0000308b
[   32.665641] sdhci: ADMA Err: 0x00000000 | ADMA Ptr: 0x0000000080000010
[   32.665642] sdhci: ===========================================
[   32.665658] brcmfmac: brcmf_err- brcmf_sdio_readframes: RXHEADER FAILED: -84
[   32.665660] brcmfmac: brcmf_err- brcmf_sdio_rxfail: abort command,
terminate frame, send NAK
[   32.665662] brcmfmac: [131072] brcmf_sdiod_abort Enter


A short time after this, there's another register dump, and then the
kernel crashes.


I had trouble figuring out how to enable specific logging modes in the
driver, so I just hacked it to spit out everything.  I have a pretty
detailed log showing the driver communication that I can post if it
will help.  I'm not sure about the etiquette on this mailing list, so
I didn't want to start off with posting the whole log right away.

Any help on this would be much appreciated.

  -Dennis
