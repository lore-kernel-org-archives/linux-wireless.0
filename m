Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:34766 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbeDKG46 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 02:56:58 -0400
Received: by mail-pl0-f65.google.com with SMTP id y12-v6so694378plt.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 23:56:58 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [PATCH 2/2] rsi: Fix 'invalid vdd' warning in mmc
Date: Wed, 11 Apr 2018 12:13:32 +0530
Message-Id: <1523429012-3978-2-git-send-email-amitkarwar@gmail.com> (sfid-20180411_085705_747200_11D2AB65)
In-Reply-To: <1523429012-3978-1-git-send-email-amitkarwar@gmail.com>
References: <1523429012-3978-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

While performing cleanup, driver is messing with card->ocr
value by not masking rocr against ocr_avail. Below panic
is observed with some of the SDIO host controllers due to
this. Issue is resolved by reverting incorrect modifications
to vdd.

[  927.423821] mmc1: Invalid vdd 0x1f
[  927.423925] Modules linked in: rsi_sdio(+) cmac bnep arc4 rsi_91x
	       mac80211 cfg80211 btrsi rfcomm bluetooth ecdh_generic
[  927.424073] CPU: 0 PID: 1624 Comm: insmod Tainted: G		W        4.15.0-1000-caracalla #1
[  927.424075] Hardware name: Dell Inc. Edge Gateway	3003/      , BIOS 01.00.06 01/22/2018
[  927.424082] RIP: 0010:sdhci_set_power_noreg+0xdd/0x190[sdhci]
[  927.424085] RSP: 0018:ffffac3fc064b930 EFLAGS:  00010282
[  927.424107] Call Trace:
[  927.424118]  sdhci_set_power+0x5a/0x60 [sdhci]
[  927.424125]  sdhci_set_ios+0x360/0x3b0 [sdhci]
[  927.424133]  mmc_set_initial_state+0x92/0x120
[  927.424137]  mmc_power_up.part.34+0x33/0x1d0
[  927.424141]  mmc_power_up+0x17/0x20
[  927.424147]  mmc_sdio_runtime_resume+0x2d/0x50
[  927.424151]  mmc_runtime_resume+0x17/0x20
[  927.424156]  __rpm_callback+0xc4/0x200
[  927.424161]  ? idr_alloc_cyclic+0x57/0xd0
[  927.424165]  ? mmc_runtime_suspend+0x20/0x20
[  927.424169]  rpm_callback+0x24/0x80
[  927.424172]  ? mmc_runtime_suspend+0x20/0x20
[  927.424176]  rpm_resume+0x4b3/0x6c0
[  927.424181]  __pm_runtime_resume+0x4e/0x80
[  927.424188]  driver_probe_device+0x41/0x490
[  927.424192]  __driver_attach+0xdf/0xf0
[  927.424196]  ? driver_probe_device+0x490/0x490
[  927.424201]  bus_for_each_dev+0x6c/0xc0
[  927.424205]  driver_attach+0x1e/0x20
[  927.424209]  bus_add_driver+0x1f4/0x270
[  927.424217]  ? rsi_sdio_ack_intr+0x50/0x50 [rsi_sdio]
[  927.424221]  driver_register+0x60/0xe0
[  927.424227]  ? rsi_sdio_ack_intr+0x50/0x50 [rsi_sdio]
[  927.424231]  sdio_register_driver+0x20/0x30
[  927.424237]  rsi_module_init+0x16/0x40 [rsi_sdio]

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index f7f2820..416981d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -170,7 +170,6 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 	int err;
 	struct mmc_card *card = pfunction->card;
 	struct mmc_host *host = card->host;
-	s32 bit = (fls(host->ocr_avail) - 1);
 	u8 cmd52_resp;
 	u32 clock, resp, i;
 	u16 rca;
@@ -190,7 +189,6 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 	msleep(20);
 
 	/* Initialize the SDIO card */
-	host->ios.vdd = bit;
 	host->ios.chip_select = MMC_CS_DONTCARE;
 	host->ios.bus_mode = MMC_BUSMODE_OPENDRAIN;
 	host->ios.power_mode = MMC_POWER_UP;
-- 
2.7.4
