Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.no-log.org ([80.67.172.39]:50052 "EHLO
	webmail.no-log.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1LRLlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 06:41:11 -0500
Message-ID: <c37d1dd4f7760df63a92b6fc1a187068.squirrel@webmail.no-log.org> (sfid-20111218_124130_256295_8110E1EC)
In-Reply-To: <4EE3C515.5050307@broadcom.com>
References: <4ECC1F41.90003@broadcom.com>
    <1323539463-6072-1-git-send-email-GNUtoo@no-log.org>
    <4EE3C515.5050307@broadcom.com>
Date: Sun, 18 Dec 2011 12:33:21 +0100 (CET)
Subject: Re: brcmfmac + compat wireless + 2.6.35
From: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
To: "Franky Lin" <frankyl@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Reply-To: GNUtoo@no-log.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
With the following patch instead of mine:
  brcm80211: fmac: register a dummy irq handler for SDIO function 2
it still fails the same way.

I added that:
#define BCMDBG                         1
after:
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
 in:
drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
and:
insmod brcmfmac.ko brcmf_msg_level=8192

But it wasn't more verbose so I added MMC debug and I got that:

[  101.531001] mmc2: starting CMD52 arg 00205000 flags 00000195
[  101.531149] sdhci [sdhci_irq()]: *** mmc2 got interrupt: 0x00000001
[  101.531232] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
[  101.531381] mmc2: starting CMD52 arg 00205200 flags 00000195
[  101.531468] sdhci [sdhci_irq()]: *** mmc2 got interrupt: 0x00000001
[  101.531615] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
[  101.531701] mmc2: starting CMD52 arg 00205400 flags 00000195
[  101.531851] sdhci [sdhci_irq()]: *** mmc2 got interrupt: 0x00000001
[  101.531934] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
[  101.532084] mmc2: starting CMD52 arg 00205600 flags 00000195
[  101.533235] sdhci [sdhci_irq()]: *** mmc2 got interrupt: 0x00000001
[  101.533321] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
[  101.533473] mmc2: starting CMD52 arg 00205800 flags 00000195
[  101.533560] sdhci [sdhci_irq()]: *** mmc2 got interrupt: 0x00000001
[  101.533707] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
[  101.533794] mmc2: starting CMD52 arg 00205a00 flags 00000195
[  101.533944] sdhci [sdhci_irq()]: *** mmc2 got interrupt: 0x00000001
[  101.534027] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
[  101.534177] mmc2: starting CMD52 arg 00205c00 flags 00000195
[  101.534327] sdhci [sdhci_irq()]: *** mmc2 got interrupt: 0x00000001
[  101.534411] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
[  101.534562] mmc2: starting CMD52 arg 00205e00 flags 00000195
--- Then it blocks here ---

Denis.

