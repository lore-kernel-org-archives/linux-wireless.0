Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54478 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbcDGGiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 02:38:20 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 2/3] ath10k: remove unnecessary warning for probe response drops
Date: Thu, 7 Apr 2016 12:07:30 +0530
Message-ID: <1460011051-8272-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160407_083824_206574_9B24B80B)
In-Reply-To: <1460011051-8272-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1460011051-8272-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca99x0 and qca4019 solutions limit probe responses transmissions.
Logging warning message for each probe response drop is flooding
kernel log unnecessary with " failed to increase tx mgmt pending
count: -16, dropping". Hence reducing log level to debug.

Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 20d72e29dfa1..b0e613bc10a5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3994,8 +3994,8 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 
 		ret = ath10k_htt_tx_mgmt_inc_pending(htt, is_mgmt, is_presp);
 		if (ret) {
-			ath10k_warn(ar, "failed to increase tx mgmt pending count: %d, dropping\n",
-				    ret);
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "failed to increase tx mgmt pending count: %d, dropping\n",
+				   ret);
 			ath10k_htt_tx_dec_pending(htt);
 			spin_unlock_bh(&ar->htt.tx_lock);
 			ieee80211_free_txskb(ar->hw, skb);
-- 
2.7.4

