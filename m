Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18269 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2AJEUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 23:20:31 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20235.48458.157197.283592@gargle.gargle.HOWL> (sfid-20120110_052034_556577_34D73EAA)
Date: Tue, 10 Jan 2012 09:53:38 +0530
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath6kl: Remove redundant pointer check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'params' is already used earlier and there is no point
in checking for a NULL condition again.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   31 +++++++++++++--------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2a166cc..cfe9cd5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -983,6 +983,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	struct ath6kl *ar = ath6kl_priv(ndev);
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 	struct ath6kl_key *key = NULL;
+	int seq_len;
 	u8 key_usage;
 	u8 key_type;
 
@@ -1011,23 +1012,21 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		key_usage = GROUP_USAGE;
 
-	if (params) {
-		int seq_len = params->seq_len;
-		if (params->cipher == WLAN_CIPHER_SUITE_SMS4 &&
-		    seq_len > ATH6KL_KEY_SEQ_LEN) {
-			/* Only first half of the WPI PN is configured */
-			seq_len = ATH6KL_KEY_SEQ_LEN;
-		}
-		if (params->key_len > WLAN_MAX_KEY_LEN ||
-		    seq_len > sizeof(key->seq))
-			return -EINVAL;
-
-		key->key_len = params->key_len;
-		memcpy(key->key, params->key, key->key_len);
-		key->seq_len = seq_len;
-		memcpy(key->seq, params->seq, key->seq_len);
-		key->cipher = params->cipher;
+	seq_len = params->seq_len;
+	if (params->cipher == WLAN_CIPHER_SUITE_SMS4 &&
+	    seq_len > ATH6KL_KEY_SEQ_LEN) {
+		/* Only first half of the WPI PN is configured */
+		seq_len = ATH6KL_KEY_SEQ_LEN;
 	}
+	if (params->key_len > WLAN_MAX_KEY_LEN ||
+	    seq_len > sizeof(key->seq))
+		return -EINVAL;
+
+	key->key_len = params->key_len;
+	memcpy(key->key, params->key, key->key_len);
+	key->seq_len = seq_len;
+	memcpy(key->seq, params->seq, key->seq_len);
+	key->cipher = params->cipher;
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
-- 
1.7.8.3

