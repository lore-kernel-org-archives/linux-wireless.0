Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38445 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbbEaJf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:35:56 -0400
Received: by wizo1 with SMTP id o1so70809517wiz.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:35:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/9] staging: vt6655: implement ieee80211_low_level_stats
Date: Sun, 31 May 2015 10:35:20 +0100
Message-Id: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113607_042532_C1C7E8F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Collect low level stats from mib counter for mac80211 call.

Replacing the unused function STAvUpdate802_11Counter.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  2 ++
 drivers/staging/vt6655/device_main.c | 24 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 440537e4..a49c6c6 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -410,6 +410,8 @@ struct vnt_private {
 	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE]; /* unsigned long alignment */
 
 	unsigned short wBeaconInterval;
+
+	struct ieee80211_low_level_stats low_stats;
 };
 
 static inline PDEVICE_RD_INFO alloc_rd_info(void)
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 8f96cc9..c27f5ef 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1056,8 +1056,9 @@ static void vnt_check_bb_vga(struct vnt_private *priv)
 static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 {
 	struct vnt_private *pDevice = dev_instance;
+	struct ieee80211_low_level_stats *low_stats = &pDevice->low_stats;
 	int             max_count = 0;
-	unsigned long dwMIBCounter = 0;
+	u32 mib_counter;
 	unsigned char byOrgPageSel = 0;
 	int             handled = 0;
 	unsigned long flags;
@@ -1084,14 +1085,20 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 	else
 		byOrgPageSel = 0;
 
-	MACvReadMIBCounter(pDevice->PortOffset, &dwMIBCounter);
+	/* Read low level stats */
+	MACvReadMIBCounter(pDevice->PortOffset, &mib_counter);
+
+	low_stats->dot11RTSSuccessCount += mib_counter & 0xff;
+	low_stats->dot11RTSFailureCount += (mib_counter >> 8) & 0xff;
+	low_stats->dot11ACKFailureCount += (mib_counter >> 16) & 0xff;
+	low_stats->dot11FCSErrorCount += (mib_counter >> 24) & 0xff;
+
 	/*
 	 * TBD....
 	 * Must do this after doing rx/tx, cause ISR bit is slow
 	 * than RD/TD write back
 	 * update ISR counter
 	 */
-	STAvUpdate802_11Counter(&pDevice->s802_11Counter, &pDevice->scStatistic, dwMIBCounter);
 	while (pDevice->dwIsr && pDevice->vif) {
 		STAvUpdateIsrStatCounter(&pDevice->scStatistic, pDevice->dwIsr);
 		MACvWriteISR(pDevice->PortOffset, pDevice->dwIsr);
@@ -1604,6 +1611,16 @@ static int vnt_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return 0;
 }
 
+static int vnt_get_stats(struct ieee80211_hw *hw,
+			 struct ieee80211_low_level_stats *stats)
+{
+	struct vnt_private *priv = hw->priv;
+
+	memcpy(stats, &priv->low_stats, sizeof(*stats));
+
+	return 0;
+}
+
 static u64 vnt_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct vnt_private *priv = hw->priv;
@@ -1641,6 +1658,7 @@ static const struct ieee80211_ops vnt_mac_ops = {
 	.prepare_multicast	= vnt_prepare_multicast,
 	.configure_filter	= vnt_configure,
 	.set_key		= vnt_set_key,
+	.get_stats		= vnt_get_stats,
 	.get_tsf		= vnt_get_tsf,
 	.set_tsf		= vnt_set_tsf,
 	.reset_tsf		= vnt_reset_tsf,
-- 
2.1.4

