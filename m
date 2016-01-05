Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13896 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbcAEKGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:06:05 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/6] brcmfmac: use jiffies for timeout in btcoex
Date: Tue, 5 Jan 2016 11:05:49 +0100
Message-ID: <1451988350-2197-6-git-send-email-arend@broadcom.com> (sfid-20160105_110632_735783_43A09960)
In-Reply-To: <1451988350-2197-1-git-send-email-arend@broadcom.com>
References: <1451988350-2197-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The btcoex uses a timeout which was in milliseconds and got
converted to jiffies upon using timer api. Instead, convert
it to jiffies and treat it as such further.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
index 4e33f96..14a70d4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
@@ -29,7 +29,7 @@
 #include "cfg80211.h"
 
 /* T1 start SCO/eSCO priority suppression */
-#define BRCMF_BTCOEX_OPPR_WIN_TIME   2000
+#define BRCMF_BTCOEX_OPPR_WIN_TIME   msecs_to_jiffies(2000)
 
 /* BT registers values during DHCP */
 #define BRCMF_BT_DHCP_REG50 0x8022
@@ -314,8 +314,7 @@ static void brcmf_btcoex_handler(struct work_struct *work)
 		} else {
 			btci->timeout -= BRCMF_BTCOEX_OPPR_WIN_TIME;
 			mod_timer(&btci->timer,
-				  jiffies +
-				  msecs_to_jiffies(BRCMF_BTCOEX_OPPR_WIN_TIME));
+				  jiffies + BRCMF_BTCOEX_OPPR_WIN_TIME);
 		}
 		btci->timer_on = true;
 		break;
@@ -328,12 +327,11 @@ static void brcmf_btcoex_handler(struct work_struct *work)
 
 		/* DHCP is not over yet, start lowering BT priority */
 		brcmf_dbg(INFO, "DHCP T1:%d expired\n",
-			  BRCMF_BTCOEX_OPPR_WIN_TIME);
+			  jiffies_to_msecs(BRCMF_BTCOEX_OPPR_WIN_TIME));
 		brcmf_btcoex_boost_wifi(btci, true);
 
 		btci->bt_state = BRCMF_BT_DHCP_FLAG_FORCE_TIMEOUT;
-		mod_timer(&btci->timer,
-			  jiffies + msecs_to_jiffies(btci->timeout));
+		mod_timer(&btci->timer, jiffies + btci->timeout);
 		btci->timer_on = true;
 		break;
 
@@ -477,7 +475,7 @@ int brcmf_btcoex_set_mode(struct brcmf_cfg80211_vif *vif,
 			return -EBUSY;
 		/* Start BT timer only for SCO connection */
 		if (brcmf_btcoex_is_sco_active(ifp)) {
-			btci->timeout = duration;
+			btci->timeout = msecs_to_jiffies(duration);
 			btci->vif = vif;
 			brcmf_btcoex_dhcp_start(btci);
 		}
-- 
1.9.1

