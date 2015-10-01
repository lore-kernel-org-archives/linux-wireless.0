Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:55463 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbbJAKvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 06:51:04 -0400
Subject: [PATCH 3/6] ath10k: brace style fixes
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 01 Oct 2015 13:50:59 +0300
Message-ID: <20151001105059.8770.12429.stgit@potku.adurom.net> (sfid-20151001_125107_491721_49184F47)
In-Reply-To: <20151001105001.8770.96252.stgit@potku.adurom.net>
References: <20151001105001.8770.96252.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath10k/htt_tx.c:457: braces {} are not necessary for single statement blocks
drivers/net/wireless/ath/ath10k/htt_tx.c:545: braces {} are not necessary for single statement blocks
drivers/net/wireless/ath/ath10k/mac.c:200: braces {} are not necessary for single statement blocks

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c |    8 ++++----
 drivers/net/wireless/ath/ath10k/mac.c    |    3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index eb5ba9bb8b4d..a31d508fc397 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -454,9 +454,9 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	spin_lock_bh(&htt->tx_lock);
 	res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
 	spin_unlock_bh(&htt->tx_lock);
-	if (res < 0) {
+	if (res < 0)
 		goto err_tx_dec;
-	}
+
 	msdu_id = res;
 
 	txdesc = ath10k_htc_alloc_skb(ar, len);
@@ -542,9 +542,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	spin_lock_bh(&htt->tx_lock);
 	res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
 	spin_unlock_bh(&htt->tx_lock);
-	if (res < 0) {
+	if (res < 0)
 		goto err_tx_dec;
-	}
+
 	msdu_id = res;
 
 	prefetch_len = min(htt->prefetch_len, msdu->len);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1b4b53b9ffc1..3316aec16043 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -197,9 +197,8 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		return -EOPNOTSUPP;
 	}
 
-	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	}
 
 	if (cmd == DISABLE_KEY) {
 		arg.key_cipher = WMI_CIPHER_NONE;

