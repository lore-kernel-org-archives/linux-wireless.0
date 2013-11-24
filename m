Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50757 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3KXUH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:27 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so1193197wgh.17
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:26 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/29] iwlwifi: mvm: don't configure mimo rates if nss is limited to 1
Date: Sun, 24 Nov 2013 22:06:46 +0200
Message-Id: <1385323606-3603-29-git-send-email-egrumbach@gmail.com> (sfid-20131124_210807_694309_ABA2568D)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Remote peer can publish a different number of supported nss via the
operating mode notification IE or action frame. If it limits to 1
then we don't want mimo rates configured in the rate table.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index f1364b7..a7efeb3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2250,6 +2250,9 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 		}
 	}
 
+	if (sta->rx_nss < 2)
+		return;
+
 	highest_mcs = rs_vht_highest_rx_mcs_index(vht_cap, 2);
 	if (highest_mcs >= IWL_RATE_MCS_0_INDEX) {
 		for (i = IWL_RATE_MCS_0_INDEX; i <= highest_mcs; i++) {
-- 
1.7.9.5

