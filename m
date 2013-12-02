Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:65152 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab3LBU7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:53 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so12685965wgg.7
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:52 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/13] iwlwifi: mvm: rs: remove unused parameter to rs_get_supported_rates
Date: Mon,  2 Dec 2013 22:59:20 +0200
Message-Id: <1386017965-13641-8-git-send-email-egrumbach@gmail.com> (sfid-20131202_220010_543538_24E78C84)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

No use of the ieee80211 header. Drop it.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 3af9062..7beb548 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -597,15 +597,7 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *ucode_rate,
 	return 1;
 }
 
-/**
- * rs_get_supported_rates - get the available rates
- *
- * if management frame or broadcast frame only return
- * basic available rates.
- *
- */
 static u16 rs_get_supported_rates(struct iwl_lq_sta *lq_sta,
-				  struct ieee80211_hdr *hdr,
 				  struct rs_rate *rate)
 {
 	if (is_legacy(rate))
@@ -704,7 +696,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 		rate->sgi = false;
 	}
 
-	rate_mask = rs_get_supported_rates(lq_sta, NULL, rate);
+	rate_mask = rs_get_supported_rates(lq_sta, rate);
 
 	/* Mask with station rate restriction */
 	if (is_legacy(rate)) {
@@ -1762,7 +1754,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	index = lq_sta->last_txrate_idx;
 
 	/* rates available for this association, and for modulation mode */
-	rate_mask = rs_get_supported_rates(lq_sta, hdr, rate);
+	rate_mask = rs_get_supported_rates(lq_sta, rate);
 
 	/* mask with station rate restriction */
 	if (is_legacy(rate)) {
-- 
1.7.9.5

