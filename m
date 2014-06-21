Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16019 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934502AbaFUKLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 06:11:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/8] brcmfmac: correct logging levels in btcoex source
Date: Sat, 21 Jun 2014 12:11:17 +0200
Message-ID: <1403345479-13467-7-git-send-email-arend@broadcom.com> (sfid-20140621_121141_513985_B8948D15)
In-Reply-To: <1403345479-13467-1-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All log messages were set to TRACE level, which is intended
for function entry and exit. Using INFO instead in other
places. Also reducing an error message that always popped
up upon module unload.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c |   38 +++++++++++-----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
index 0cb591b..a29ac49 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
@@ -157,7 +157,7 @@ static void brcmf_btcoex_boost_wifi(struct brcmf_btcoex_info *btci,
 		 */
 
 		/* save current */
-		brcmf_dbg(TRACE, "new SCO/eSCO coex algo {save & override}\n");
+		brcmf_dbg(INFO, "new SCO/eSCO coex algo {save & override}\n");
 		brcmf_btcoex_params_read(ifp, 50, &btci->reg50);
 		brcmf_btcoex_params_read(ifp, 51, &btci->reg51);
 		brcmf_btcoex_params_read(ifp, 64, &btci->reg64);
@@ -165,7 +165,7 @@ static void brcmf_btcoex_boost_wifi(struct brcmf_btcoex_info *btci,
 		brcmf_btcoex_params_read(ifp, 71, &btci->reg71);
 
 		btci->saved_regs_part2 = true;
-		brcmf_dbg(TRACE,
+		brcmf_dbg(INFO,
 			  "saved bt_params[50,51,64,65,71]: 0x%x 0x%x 0x%x 0x%x 0x%x\n",
 			  btci->reg50, btci->reg51, btci->reg64,
 			  btci->reg65, btci->reg71);
@@ -179,21 +179,21 @@ static void brcmf_btcoex_boost_wifi(struct brcmf_btcoex_info *btci,
 
 	} else if (btci->saved_regs_part2) {
 		/* restore previously saved bt params */
-		brcmf_dbg(TRACE, "Do new SCO/eSCO coex algo {restore}\n");
+		brcmf_dbg(INFO, "Do new SCO/eSCO coex algo {restore}\n");
 		brcmf_btcoex_params_write(ifp, 50, btci->reg50);
 		brcmf_btcoex_params_write(ifp, 51, btci->reg51);
 		brcmf_btcoex_params_write(ifp, 64, btci->reg64);
 		brcmf_btcoex_params_write(ifp, 65, btci->reg65);
 		brcmf_btcoex_params_write(ifp, 71, btci->reg71);
 
-		brcmf_dbg(TRACE,
+		brcmf_dbg(INFO,
 			  "restored bt_params[50,51,64,65,71]: 0x%x 0x%x 0x%x 0x%x 0x%x\n",
 			  btci->reg50, btci->reg51, btci->reg64,
 			  btci->reg65, btci->reg71);
 
 		btci->saved_regs_part2 = false;
 	} else {
-		brcmf_err("attempted to restore not saved BTCOEX params\n");
+		brcmf_dbg(INFO, "attempted to restore not saved BTCOEX params\n");
 	}
 }
 
@@ -219,14 +219,14 @@ static bool brcmf_btcoex_is_sco_active(struct brcmf_if *ifp)
 			break;
 		}
 
-		brcmf_dbg(TRACE, "sample[%d], btc_params 27:%x\n", i, param27);
+		brcmf_dbg(INFO, "sample[%d], btc_params 27:%x\n", i, param27);
 
 		if ((param27 & 0x6) == 2) { /* count both sco & esco  */
 			sco_id_cnt++;
 		}
 
 		if (sco_id_cnt > 2) {
-			brcmf_dbg(TRACE,
+			brcmf_dbg(INFO,
 				  "sco/esco detected, pkt id_cnt:%d samples:%d\n",
 				  sco_id_cnt, i);
 			res = true;
@@ -250,7 +250,7 @@ static void btcmf_btcoex_save_part1(struct brcmf_btcoex_info *btci)
 		brcmf_btcoex_params_read(ifp, 41, &btci->reg41);
 		brcmf_btcoex_params_read(ifp, 68, &btci->reg68);
 		btci->saved_regs_part1 = true;
-		brcmf_dbg(TRACE,
+		brcmf_dbg(INFO,
 			  "saved btc_params regs (66,41,68) 0x%x 0x%x 0x%x\n",
 			  btci->reg66, btci->reg41,
 			  btci->reg68);
@@ -270,7 +270,7 @@ static void brcmf_btcoex_restore_part1(struct brcmf_btcoex_info *btci)
 		brcmf_btcoex_params_write(ifp, 66, btci->reg66);
 		brcmf_btcoex_params_write(ifp, 41, btci->reg41);
 		brcmf_btcoex_params_write(ifp, 68, btci->reg68);
-		brcmf_dbg(TRACE,
+		brcmf_dbg(INFO,
 			  "restored btc_params regs {66,41,68} 0x%x 0x%x 0x%x\n",
 			  btci->reg66, btci->reg41,
 			  btci->reg68);
@@ -307,7 +307,7 @@ static void brcmf_btcoex_handler(struct work_struct *work)
 		/* DHCP started provide OPPORTUNITY window
 		   to get DHCP address
 		*/
-		brcmf_dbg(TRACE, "DHCP started\n");
+		brcmf_dbg(INFO, "DHCP started\n");
 		btci->bt_state = BRCMF_BT_DHCP_OPPR_WIN;
 		if (btci->timeout < BRCMF_BTCOEX_OPPR_WIN_TIME) {
 			mod_timer(&btci->timer, btci->timer.expires);
@@ -322,12 +322,12 @@ static void brcmf_btcoex_handler(struct work_struct *work)
 
 	case BRCMF_BT_DHCP_OPPR_WIN:
 		if (btci->dhcp_done) {
-			brcmf_dbg(TRACE, "DHCP done before T1 expiration\n");
+			brcmf_dbg(INFO, "DHCP done before T1 expiration\n");
 			goto idle;
 		}
 
 		/* DHCP is not over yet, start lowering BT priority */
-		brcmf_dbg(TRACE, "DHCP T1:%d expired\n",
+		brcmf_dbg(INFO, "DHCP T1:%d expired\n",
 			  BRCMF_BTCOEX_OPPR_WIN_TIME);
 		brcmf_btcoex_boost_wifi(btci, true);
 
@@ -339,9 +339,9 @@ static void brcmf_btcoex_handler(struct work_struct *work)
 
 	case BRCMF_BT_DHCP_FLAG_FORCE_TIMEOUT:
 		if (btci->dhcp_done)
-			brcmf_dbg(TRACE, "DHCP done before T2 expiration\n");
+			brcmf_dbg(INFO, "DHCP done before T2 expiration\n");
 		else
-			brcmf_dbg(TRACE, "DHCP T2:%d expired\n",
+			brcmf_dbg(INFO, "DHCP T2:%d expired\n",
 				  BRCMF_BT_DHCP_FLAG_FORCE_TIMEOUT);
 
 		goto idle;
@@ -440,13 +440,13 @@ static void brcmf_btcoex_dhcp_end(struct brcmf_btcoex_info *btci)
 	/* Stop any bt timer because DHCP session is done */
 	btci->dhcp_done = true;
 	if (btci->timer_on) {
-		brcmf_dbg(TRACE, "disable BT DHCP Timer\n");
+		brcmf_dbg(INFO, "disable BT DHCP Timer\n");
 		btci->timer_on = false;
 		del_timer_sync(&btci->timer);
 
 		/* schedule worker if transition to IDLE is needed */
 		if (btci->bt_state != BRCMF_BT_DHCP_IDLE) {
-			brcmf_dbg(TRACE, "bt_state:%d\n",
+			brcmf_dbg(INFO, "bt_state:%d\n",
 				  btci->bt_state);
 			schedule_work(&btci->work);
 		}
@@ -472,7 +472,7 @@ int brcmf_btcoex_set_mode(struct brcmf_cfg80211_vif *vif,
 
 	switch (mode) {
 	case BRCMF_BTCOEX_DISABLED:
-		brcmf_dbg(TRACE, "DHCP session starts\n");
+		brcmf_dbg(INFO, "DHCP session starts\n");
 		if (btci->bt_state != BRCMF_BT_DHCP_IDLE)
 			return -EBUSY;
 		/* Start BT timer only for SCO connection */
@@ -484,14 +484,14 @@ int brcmf_btcoex_set_mode(struct brcmf_cfg80211_vif *vif,
 		break;
 
 	case BRCMF_BTCOEX_ENABLED:
-		brcmf_dbg(TRACE, "DHCP session ends\n");
+		brcmf_dbg(INFO, "DHCP session ends\n");
 		if (btci->bt_state != BRCMF_BT_DHCP_IDLE &&
 		    vif == btci->vif) {
 			brcmf_btcoex_dhcp_end(btci);
 		}
 		break;
 	default:
-		brcmf_dbg(TRACE, "Unknown mode, ignored\n");
+		brcmf_dbg(INFO, "Unknown mode, ignored\n");
 	}
 	return 0;
 }
-- 
1.7.9.5

