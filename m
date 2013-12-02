Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50100 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824Ab3LBU75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:57 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so5513753wib.14
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:56 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/13] iwlwifi: mvm: rs: use the proper channel width define for legacy rate
Date: Mon,  2 Dec 2013 22:59:23 +0200
Message-Id: <1386017965-13641-11-git-send-email-egrumbach@gmail.com> (sfid-20131202_220011_479926_9B060E8D)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Use the 20Mhz channel width define instead of just the number
zero for legacy rates. Note that the define has the same value
so this is just a minor cleanup.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index ef7126a..1bfdde5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -691,7 +691,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 			rate->ant =
 			    first_antenna(iwl_fw_valid_tx_ant(mvm->fw));
 
-		rate->bw = 0;
+		rate->bw = RATE_MCS_CHAN_WIDTH_20;
 		rate->sgi = false;
 	}
 
-- 
1.7.9.5

