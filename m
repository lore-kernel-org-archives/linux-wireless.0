Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34359 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbcGRXYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 19:24:55 -0400
Received: by mail-pa0-f67.google.com with SMTP id hh10so113707pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 16:24:55 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
	hante.meuleman@broadcom.com,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4/4] brcmsmac: Initialize power in brcms_c_stf_ss_algo_channel_get()
Date: Mon, 18 Jul 2016 16:24:37 -0700
Message-Id: <1468884277-18606-5-git-send-email-f.fainelli@gmail.com> (sfid-20160719_012500_992194_461665B4)
In-Reply-To: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlc_phy_txpower_get_current() does a logical OR of power->flags, which
presumes that power.flags was initiliazed earlier by the caller,
unfortunately, this is not the case, so make sure we zero out the struct
tx_power before calling into wlc_phy_txpower_get_current().

Reported-by: coverity (CID 146011)
Fixes: 5b435de0d7868 ("net: wireless: add brcm80211 drivers")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
index dd9162722495..0ab865de1491 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/stf.c
@@ -87,7 +87,7 @@ void
 brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
 			    u16 chanspec)
 {
-	struct tx_power power;
+	struct tx_power power = { };
 	u8 siso_mcs_id, cdd_mcs_id, stbc_mcs_id;
 
 	/* Clear previous settings */
-- 
2.7.4

