Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58246 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbeD0LVz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 07:21:55 -0400
Date: Fri, 27 Apr 2018 14:21:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] rsi: fix a bug in rsi_hal_key_config()
Message-ID: <20180427112130.GA27655@mwanda> (sfid-20180427_132200_343887_364F4019)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains that the end of this function is dead code.  I'm pretty
sure that this return needs to be changed to only return on error.

Fixes: 4fd6c4762f37 ("rsi: roaming enhancements")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 766d874cc6e2..80e7f4f4f188 100644
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
 
