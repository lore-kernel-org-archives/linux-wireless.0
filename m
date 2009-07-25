Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:62838 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbZGYVb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 17:31:56 -0400
Received: by ewy26 with SMTP id 26so2436577ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 14:31:56 -0700 (PDT)
Message-ID: <4A6B7A67.9070906@gmail.com>
Date: Sat, 25 Jul 2009 23:34:31 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] iwlwifi: Read outside array bounds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tid is bounded (above) by the size of default_tid_to_tx_fifo (17 elements), but
the size of priv->stations[].tid[] is MAX_TID_COUNT (9) elements.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 85ae7a6..e9441c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1170,6 +1170,8 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 		IWL_ERR(priv, "Start AGG on invalid station
");
 		return -ENXIO;
 	}
+	if (unlikely(tid >= MAX_TID_COUNT))
+		return -EINVAL;
 
 	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
 		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !
");
