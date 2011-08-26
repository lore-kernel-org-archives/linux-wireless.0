Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab1HZPZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 11:25:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>, stable@kernel.org
Subject: [PATCH] iwlegacy: fix BUG_ON(info->control.rates[0].idx < 0)
Date: Fri, 26 Aug 2011 17:24:59 +0200
Message-Id: <1314372299-13319-1-git-send-email-sgruszka@redhat.com> (sfid-20110826_172600_932771_31E54834)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to connect to 5GHz we can provide negative index to
mac80211 what trigger BUG_ON. Reason of iwl-3945-rs malfunction
on 5GHz is unknown and needs further investigation. For now, to
do not trigger a bug, correct value and just print WARNING.

Address bug:
https://bugzilla.redhat.com/show_bug.cgi?id=730653

Reported-and-tested-by: Jan Teichmann <jan.teichmann@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 977bd24..164bcae 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -822,12 +822,15 @@ static void iwl3945_rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
  out:
 
-	rs_sta->last_txrate_idx = index;
-	if (sband->band == IEEE80211_BAND_5GHZ)
-		info->control.rates[0].idx = rs_sta->last_txrate_idx -
-				IWL_FIRST_OFDM_RATE;
-	else
+	if (sband->band == IEEE80211_BAND_5GHZ) {
+		if (WARN_ON_ONCE(index < IWL_FIRST_OFDM_RATE))
+			index = IWL_FIRST_OFDM_RATE;
+		rs_sta->last_txrate_idx = index;
+		info->control.rates[0].idx = index - IWL_FIRST_OFDM_RATE;
+	} else {
+		rs_sta->last_txrate_idx = index;
 		info->control.rates[0].idx = rs_sta->last_txrate_idx;
+	}
 
 	IWL_DEBUG_RATE(priv, "leave: %d\n", index);
 }
-- 
1.7.1

