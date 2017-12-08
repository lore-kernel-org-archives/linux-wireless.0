Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35620 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752965AbdLHNcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 08:32:07 -0500
From: Govind Singh <govinds@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH 1/2] mac80211: Populate RSC counter in set_key method
Date: Fri,  8 Dec 2017 19:02:02 +0530
Message-Id: <1512739922-1529-1-git-send-email-govinds@qti.qualcomm.com> (sfid-20171208_143212_579925_57EDA6B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send RSC counter to driver in set_key method, so that FW/driver
can drop the packet in PN check if received packet sequence
no is less than current RSC counter during group keys(GTK)
exchange.

Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 include/net/mac80211.h | 6 ++++--
 net/mac80211/key.c     | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2ee4af2..2f0c91d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1564,6 +1564,8 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_RESERVE_TAILROOM	= BIT(7),
 };
 
+#define IEEE80211_MAX_PN_LEN	16
+
 /**
  * struct ieee80211_key_conf - key information
  *
@@ -1586,6 +1588,7 @@ enum ieee80211_key_flags {
  * 	- Temporal Authenticator Rx MIC Key (64 bits)
  * @icv_len: The ICV length for this key type
  * @iv_len: The IV length for this key type
+ * @rx_pn: Last received packet number, must be in little endian.
  */
 struct ieee80211_key_conf {
 	atomic64_t tx_pn;
@@ -1596,11 +1599,10 @@ struct ieee80211_key_conf {
 	u8 flags;
 	s8 keyidx;
 	u8 keylen;
+	u8 rx_pn[IEEE80211_MAX_PN_LEN];
 	u8 key[0];
 };
 
-#define IEEE80211_MAX_PN_LEN	16
-
 #define TKIP_PN_TO_IV16(pn) ((u16)(pn & 0xffff))
 #define TKIP_PN_TO_IV32(pn) ((u32)((pn >> 16) & 0xffffffff))
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 9380493..15e1822 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -538,6 +538,12 @@ struct ieee80211_key *
 	}
 	memcpy(key->conf.key, key_data, key_len);
 	INIT_LIST_HEAD(&key->list);
+	/* Assign receive packet sequence no, rx_pn remains in
+	 * little endian format as seq is guaranteed to be in little
+	 * endian format.
+	 */
+	if (seq)
+		memcpy(&key->conf.rx_pn, seq, seq_len);
 
 	return key;
 }
-- 
1.9.1
