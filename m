Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AUDBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:01:01 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so1249489iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:01:01 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63167.685562.673891@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:30:15 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 08/33] ath9k_htc: Make sequence number calculation per-VIF
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 4e646fb..87e2d41 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -208,6 +208,7 @@ struct ath9k_htc_target_stats {
 
 struct ath9k_htc_vif {
 	u8 index;
+	u16 seq_no;
 };
 
 struct ath9k_vif_iter_data {
@@ -372,7 +373,6 @@ struct ath9k_htc_priv {
 	u16 txpowlimit;
 	u16 nvifs;
 	u16 nstations;
-	u16 seq_no;
 	u32 bmiss_cnt;
 	bool rearm_ani;
 	bool reconfig_beacon;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 133f628..bbbdd60 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -207,9 +207,9 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending)
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		struct ieee80211_hdr *hdr =
 			(struct ieee80211_hdr *) beacon->data;
-		priv->seq_no += 0x10;
+		avp->seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(priv->seq_no);
+		hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
 	}
 
 	tx_ctl.type = ATH9K_HTC_NORMAL;
-- 
1.7.3.5

