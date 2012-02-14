Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60084 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760196Ab2BNNJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 08:09:28 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: remove obselete comments
Date: Tue, 14 Feb 2012 18:39:18 +0530
Message-ID: <1329224959-12143-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120214_140952_950228_04EDEB66)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

the corresponding code/logic was removed in
"ath9k: rework power state handling"

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ec82e92..22785c7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1587,12 +1587,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
-	/*
-	 * Leave this as the first check because we need to turn on the
-	 * radio if it was disabled before prior to processing the rest
-	 * of the changes. Likewise we must only disable the radio towards
-	 * the end.
-	 */
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
 		sc->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 		if (sc->ps_idle)
-- 
1.7.0.4

