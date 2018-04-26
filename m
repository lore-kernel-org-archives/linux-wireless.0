Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.199.121]:11525 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755207AbeDZNuy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 09:50:54 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id BAC3A4100B698
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2018 08:01:40 -0500 (CDT)
Date: Thu, 26 Apr 2018 08:01:38 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] rsi_91x_mac80211: fix structurally dead code
Message-ID: <20180426130138.GA440@embeddedor.com> (sfid-20180426_155058_227145_27EADA82)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function rsi_hal_key_config returns before reaching code at line
922 if (status), hence this code is structurally dead.

Fix this by storing the value returned by rsi_hal_load_key
into _status_ for its further evaluation and use.

Addresses-Coverity-ID: 1468409 ("Structurally dead code")
Fixes: 4fd6c4762f37 ("rsi: roaming enhancements")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 766d874..80e7f4f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -911,14 +911,14 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
 		}
 	}
 
-	return rsi_hal_load_key(adapter->priv,
-				key->key,
-				key->keylen,
-				key_type,
-				key->keyidx,
-				key->cipher,
-				sta_id,
-				vif);
+	status = rsi_hal_load_key(adapter->priv,
+				  key->key,
+				  key->keylen,
+				  key_type,
+				  key->keyidx,
+				  key->cipher,
+				  sta_id,
+				  vif);
 	if (status)
 		return status;
 
-- 
2.7.4
