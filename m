Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35304 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdECHgY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 03:36:24 -0400
From: Xie Qirong <cheerx1994@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Piotr Haber <phaber@broadcom.com>,
        Xie Qirong <cheerx1994@gmail.com>
Subject: [PATCH] brcmfmac: btcoex: replace init_timer with setup_timer
Date: Wed,  3 May 2017 15:35:55 +0800
Message-Id: <20170503073555.3922-1-cheerx1994@gmail.com> (sfid-20170503_093835_380450_35868507)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Xie Qirong <cheerx1994@gmail.com>
---

 setup_timer.cocci suggested the following improvement:
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:383:1-11: Use
 setup_timer function for function on line 384.

 Patch was compile checked with: x86_64_defconfig + CONFIG_BRCMFMAC=y +
 CONFIG_BRCMFMAC_USB=y + CONFIG_BRCMFMAC_PCIE=y + CONFIG_BRCM_TRACING=y +
 CONFIG_BRCMDBG=y

 Kernel version: next-20170502 (localversion-next is next-20170502)

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
index 14a70d4..3559fb5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
@@ -380,9 +380,7 @@ int brcmf_btcoex_attach(struct brcmf_cfg80211_info *cfg)
 	/* Set up timer for BT  */
 	btci->timer_on = false;
 	btci->timeout = BRCMF_BTCOEX_OPPR_WIN_TIME;
-	init_timer(&btci->timer);
-	btci->timer.data = (ulong)btci;
-	btci->timer.function = brcmf_btcoex_timerfunc;
+	setup_timer(&btci->timer, brcmf_btcoex_timerfunc, (ulong)btci);
 	btci->cfg = cfg;
 	btci->saved_regs_part1 = false;
 	btci->saved_regs_part2 = false;
-- 
2.9.3
