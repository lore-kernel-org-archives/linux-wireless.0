Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpe-075-189-159-031.nc.res.rr.com ([75.189.159.31]:33282 "EHLO
	jgpicker.rdu.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932863Ab3GLP3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 11:29:03 -0400
From: John Greene <jogreene@redhat.com>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org
Subject: [PATCH] brcmsmac: Further reduce log spam from tx phy messages
Date: Fri, 12 Jul 2013 10:55:19 -0400
Message-Id: <1373640919-2685-1-git-send-email-jogreene@redhat.com> (sfid-20130712_172907_266472_30C56BE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Relegate 2 phy messages to debug status as they create excessive
log spam, noted in multiple bugzillas for brcmsmac v3.8 and up.
This is a follow on to net-next 99e94940697adec4f84758adb2db71f4a82c7ba5:
brcmsmac: Reduce log spam in heavy tx, make err print in debug

 brcmsmac bcma0:0: phyerr 0x10, rate 0x14
 brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete:
ampdu tx phy error (0x10)

Signed-off-by: John Greene <jogreene@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c | 2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index bd98285..42efac7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -928,7 +928,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			}
 		} else if (txs->phyerr) {
 			update_rate = false;
-			brcms_err(wlc->hw->d11core,
+			brcms_dbg_ht(wlc->hw->d11core,
 				  "%s: ampdu tx phy error (0x%x)\n",
 				  __func__, txs->phyerr);
 		}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9fd6f2f..fdb4c3f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -882,7 +882,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	mcl = le16_to_cpu(txh->MacTxControlLow);
 
 	if (txs->phyerr)
-		brcms_err(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
+		brcms_dbg_tx(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
 			  txs->phyerr, txh->MainRates);
 
 	if (txs->frameid != le16_to_cpu(txh->TxFrameID)) {
-- 
1.7.11.7

