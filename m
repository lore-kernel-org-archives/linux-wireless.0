Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58299 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbbHJQPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 12:15:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwl8k: refactor some conditionals for clarity
Date: Mon, 10 Aug 2015 12:05:39 -0400
Message-Id: <1439222739-24545-1-git-send-email-linville@tuxdriver.com> (sfid-20150810_181525_931540_024DA456)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/mwl8k.o
drivers/net/wireless/mwl8k.c: In function ‘mwl8k_bss_info_changed’:
drivers/net/wireless/mwl8k.c:3290:2: warning: ‘ap_mcs_rates’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  memcpy(cmd->mcs_set, mcs_rates, 16);
  ^
drivers/net/wireless/mwl8k.c:4987:5: note: ‘ap_mcs_rates’ was declared here
  u8 ap_mcs_rates[16];
     ^

The warning was bogus.  But the conditionals were rather complicated,
with multiple redundant checks.  This consolidates the checking and
makes it more readable IMHO.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Compile tested only.  Sorry for any duplicates -- I sent the first
one to the wrong list address!

 drivers/net/wireless/mwl8k.c | 49 ++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 77361af68b18..9420fc61c2e6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5019,35 +5019,36 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		memcpy(ap_mcs_rates, ap->ht_cap.mcs.rx_mask, 16);
 
 		rcu_read_unlock();
-	}
 
-	if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc &&
-	    !priv->ap_fw) {
-		rc = mwl8k_cmd_set_rate(hw, vif, ap_legacy_rates, ap_mcs_rates);
-		if (rc)
-			goto out;
+		if (changed & BSS_CHANGED_ASSOC) {
+			if (!priv->ap_fw) {
+				rc = mwl8k_cmd_set_rate(hw, vif,
+							ap_legacy_rates,
+							ap_mcs_rates);
+				if (rc)
+					goto out;
 
-		rc = mwl8k_cmd_use_fixed_rate_sta(hw);
-		if (rc)
-			goto out;
-	} else {
-		if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc &&
-		    priv->ap_fw) {
-			int idx;
-			int rate;
+				rc = mwl8k_cmd_use_fixed_rate_sta(hw);
+				if (rc)
+					goto out;
+			} else {
+				int idx;
+				int rate;
 
-			/* Use AP firmware specific rate command.
-			 */
-			idx = ffs(vif->bss_conf.basic_rates);
-			if (idx)
-				idx--;
+				/* Use AP firmware specific rate command.
+				 */
+				idx = ffs(vif->bss_conf.basic_rates);
+				if (idx)
+					idx--;
 
-			if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
-				rate = mwl8k_rates_24[idx].hw_value;
-			else
-				rate = mwl8k_rates_50[idx].hw_value;
+				if (hw->conf.chandef.chan->band ==
+				    IEEE80211_BAND_2GHZ)
+					rate = mwl8k_rates_24[idx].hw_value;
+				else
+					rate = mwl8k_rates_50[idx].hw_value;
 
-			mwl8k_cmd_use_fixed_rate_ap(hw, rate, rate);
+				mwl8k_cmd_use_fixed_rate_ap(hw, rate, rate);
+			}
 		}
 	}
 
-- 
2.4.3

