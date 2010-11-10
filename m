Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25294 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab0KJMYB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:24:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 04:23:48 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 2/5] ath: Add a keycache entry if beamforming is enabled.
Date: Wed, 10 Nov 2010 17:53:46 +0530
Message-ID: <1289391829-8577-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keycache entry for a sta has the details of the negotiated
beamforming parameters which is to be used by the hardware
while trasmitting to that specific sta.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath.h |    2 ++
 drivers/net/wireless/ath/key.c |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 501050c..214a25f 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -177,5 +177,7 @@ int ath_key_config(struct ath_common *common,
 bool ath_hw_keyreset(struct ath_common *common, u16 entry);
 void ath_hw_cycle_counters_update(struct ath_common *common);
 int32_t ath_hw_get_listen_time(struct ath_common *common);
+int ath_txbf_key_config(struct ath_common *common,
+			struct ieee80211_sta *sta);
 
 #endif /* ATH_H */
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 62e3dac..11f562e 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -115,6 +115,7 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 	void *ah = common->ah;
 	u32 key0, key1, key2, key3, key4;
 	u32 keyType;
+	u32 txbf = 0;
 
 	if (entry >= common->keymax) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -199,6 +200,9 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
 		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
 
+		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry),
+				keyType | txbf);
+
 		/* Write MAC address for the entry */
 		(void) ath_hw_keysetmac(common, entry, mac);
 
@@ -435,6 +439,31 @@ static int ath_reserve_key_cache_slot(struct ath_common *common,
 	return -1;
 }
 
+int ath_txbf_key_config(struct ath_common *common, struct ieee80211_sta *sta)
+{
+	int idx, ret;
+	struct ath_keyval hk;
+
+	if (WARN_ON(!sta))
+		return -EOPNOTSUPP;
+
+	memset(&hk, 0, sizeof(hk));
+	hk.kv_type = ATH_CIPHER_CLR;
+
+	idx = ath_reserve_key_cache_slot(common, 0);
+
+	if (idx < 0)
+		return -ENOSPC;
+
+	ret = ath_hw_set_keycache_entry(common, idx, &hk, sta->addr);
+
+	if (!ret)
+		return -EIO;
+
+	return idx;
+}
+EXPORT_SYMBOL(ath_txbf_key_config);
+
 /*
  * Configure encryption in the HW.
  */
-- 
1.6.3.3

