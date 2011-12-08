Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:59544 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1LHP2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 10:28:50 -0500
Subject: [PATCH 1/6] ath6kl: remove a workaround from ath6kl_cfg80211_stop()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 08 Dec 2011 17:28:24 +0200
Message-ID: <20111208152824.16924.31984.stgit@x201> (sfid-20111208_162854_348666_4026C81E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a workaround in ath6kl_cfg80211_stop() which emits disconnected
even when sme_state was disconnected. This is legacy from the old
staging driver and I can't repoduce the old problem anymore. I assume the
bug got fixed while the driver was cleaned up so let's get
rid of the hack.

This makes it possible to call ath6kl_cfg80211_stop from ath6kl_close()
which happens in a followup patch.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index aa93527..5f12c04 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2406,6 +2406,8 @@ void ath6kl_cfg80211_stop(struct ath6kl *ar)
 	}
 
 	switch (vif->sme_state) {
+	case SME_DISCONNECTED:
+		break;
 	case SME_CONNECTING:
 		cfg80211_connect_result(vif->ndev, vif->bssid, NULL, 0,
 					NULL, 0,
@@ -2413,12 +2415,6 @@ void ath6kl_cfg80211_stop(struct ath6kl *ar)
 					GFP_KERNEL);
 		break;
 	case SME_CONNECTED:
-	default:
-		/*
-		 * FIXME: oddly enough smeState is in DISCONNECTED during
-		 * suspend, why? Need to send disconnected event in that
-		 * state.
-		 */
 		cfg80211_disconnected(vif->ndev, 0, NULL, 0, GFP_KERNEL);
 		break;
 	}

