Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:23901 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1KTVEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 16:04:31 -0500
Date: Mon, 21 Nov 2011 00:04:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlegacy: off by one in iwl3945_hw_build_tx_cmd_rate()
Message-ID: <20111120210400.GB7354@elgon.mountain> (sfid-20111120_220436_339076_B3BDAD7E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use "rate_index" like this:
	rate = iwl3945_rates[rate_index].plcp;
The iwl3945_rates[] array has IWL_RATE_COUNT_3945 elements so the
limit here is off by one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index f7c0a74..1627048 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -676,7 +676,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				  int sta_id, int tx_id)
 {
 	u16 hw_value = ieee80211_get_tx_rate(priv->hw, info)->hw_value;
-	u16 rate_index = min(hw_value & 0xffff, IWL_RATE_COUNT_3945);
+	u16 rate_index = min(hw_value & 0xffff, IWL_RATE_COUNT_3945 - 1);
 	u16 rate_mask;
 	int rate;
 	u8 rts_retry_limit;
