Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34741 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdKAJ00 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 05:26:26 -0400
From: Colin King <colin.king@canonical.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlegacy: remove redundant pointer sta_priv
Date: Wed,  1 Nov 2017 09:26:22 +0000
Message-Id: <20171101092622.16625-1-colin.king@canonical.com> (sfid-20171101_102647_711060_BE38A6BF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer sta_priv is assigned but never read, hence it is redundant
and can be removed. Cleans up clang warning:

drivers/net/wireless/intel/iwlegacy/4965-rs.c:2163:2: warning: Value
stored to 'sta_priv' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index c055f6da11c6..365a4187fc37 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2154,13 +2154,11 @@ il4965_rs_initialize_lq(struct il_priv *il, struct ieee80211_conf *conf,
 	u8 use_green;
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
-	struct il_station_priv *sta_priv;
 
 	if (!sta || !lq_sta)
 		return;
 
 	use_green = il4965_rs_use_green(il, sta);
-	sta_priv = (void *)sta->drv_priv;
 
 	i = lq_sta->last_txrate_idx;
 
-- 
2.14.1
