Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:34788 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933736AbbDUVd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 17:33:28 -0400
Received: by wgso17 with SMTP id o17so227665238wgs.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2015 14:33:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/3] staging: vt6655: CARDbUpdateTSF bss timestamp correct tsf counter value.
Date: Tue, 21 Apr 2015 22:33:01 +0100
Message-Id: <1429651982-4352-2-git-send-email-tvboxspy@gmail.com> (sfid-20150421_233334_949664_F5EE93E5)
In-Reply-To: <1429651982-4352-1-git-send-email-tvboxspy@gmail.com>
References: <1429651982-4352-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TSF counter is not set correctly.

Use sync_tsf for last beacon value and get tsf local value.

Remove qwLocalTSF variable and call CARDbGetCurrentTSF.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        | 10 +++++++---
 drivers/staging/vt6655/card.h        |  2 +-
 drivers/staging/vt6655/device_main.c |  2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 1cdcf49..e00c060 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -362,12 +362,16 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type)
  * Return Value: none
  */
 bool CARDbUpdateTSF(struct vnt_private *pDevice, unsigned char byRxRate,
-		    u64 qwBSSTimestamp, u64 qwLocalTSF)
+		    u64 qwBSSTimestamp)
 {
+	u64 local_tsf;
 	u64 qwTSFOffset = 0;
 
-	if (qwBSSTimestamp != qwLocalTSF) {
-		qwTSFOffset = CARDqGetTSFOffset(byRxRate, qwBSSTimestamp, qwLocalTSF);
+	CARDbGetCurrentTSF(pDevice, &local_tsf);
+
+	if (qwBSSTimestamp != local_tsf) {
+		qwTSFOffset = CARDqGetTSFOffset(byRxRate, qwBSSTimestamp,
+						local_tsf);
 		/* adjust TSF, HW's TSF add TSF Offset reg */
 		VNSvOutPortD(pDevice->PortOffset + MAC_REG_TSFOFST, (u32)qwTSFOffset);
 		VNSvOutPortD(pDevice->PortOffset + MAC_REG_TSFOFST + 4, (u32)(qwTSFOffset >> 32));
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 2dfc419..16cca49 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -83,7 +83,7 @@ bool CARDbRadioPowerOff(struct vnt_private *);
 bool CARDbRadioPowerOn(struct vnt_private *);
 bool CARDbSetPhyParameter(struct vnt_private *, u8);
 bool CARDbUpdateTSF(struct vnt_private *, unsigned char byRxRate,
-		    u64 qwBSSTimestamp, u64 qwLocalTSF);
+		    u64 qwBSSTimestamp);
 bool CARDbSetBeaconPeriod(struct vnt_private *, unsigned short wBeaconInterval);
 
 #endif /* __CARD_H__ */
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index ed90b6f..26a6f67 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1473,7 +1473,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC && priv->op_mode != NL80211_IFTYPE_AP) {
 		if (conf->assoc) {
 			CARDbUpdateTSF(priv, conf->beacon_rate->hw_value,
-				       conf->sync_device_ts, conf->sync_tsf);
+				       conf->sync_tsf);
 
 			CARDbSetBeaconPeriod(priv, conf->beacon_int);
 
-- 
2.1.4

