Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11853 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbdGFGmn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 02:42:43 -0400
Subject: [PATCH] ath10k: fix indenting in ath10k_wmi_update_noa()
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 6 Jul 2017 09:42:20 +0300
Message-ID: <149932333976.15174.4921279022358234069.stgit@potku.adurom.net> (sfid-20170706_084246_502639_8315F41C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 59ae1d127ac0 ("networking: introduce and use skb_put_data()") introduced
a new checkpatch warning:

drivers/net/wireless/ath/ath10k/wmi.c:3308: code indent should use tabs where possible

Fix that.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 3efb404b83c0..96cd1ebd6a7e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3305,7 +3305,7 @@ static void ath10k_wmi_update_noa(struct ath10k *ar, struct ath10k_vif *arvif,
 	if (arvif->u.ap.noa_data)
 		if (!pskb_expand_head(bcn, 0, arvif->u.ap.noa_len, GFP_ATOMIC))
 			skb_put_data(bcn, arvif->u.ap.noa_data,
-			             arvif->u.ap.noa_len);
+				     arvif->u.ap.noa_len);
 }
 
 static int ath10k_wmi_op_pull_swba_ev(struct ath10k *ar, struct sk_buff *skb,
