Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46383 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1COHCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 03:02:15 -0400
Date: Tue, 15 Mar 2011 10:01:58 +0300
From: Dan Carpenter <error27@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>, johannes.berg@intel.com
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] iwlwifi: missing unlock on error path
Message-ID: <20110315070158.GQ2008@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should unlock here instead of returning -EINVAL directly.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 581dc9f..321b18b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3009,14 +3009,17 @@ static int iwl_mac_offchannel_tx_cancel_wait(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mutex);
 
-	if (!priv->_agn.offchan_tx_skb)
-		return -EINVAL;
+	if (!priv->_agn.offchan_tx_skb) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
 	priv->_agn.offchan_tx_skb = NULL;
 
 	ret = iwl_scan_cancel_timeout(priv, 200);
 	if (ret)
 		ret = -EIO;
+unlock:
 	mutex_unlock(&priv->mutex);
 
 	return ret;
