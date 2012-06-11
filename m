Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab2FKGsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 02:48:32 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 2/9] ath9k: restore power state on set channel failure
Date: Mon, 11 Jun 2012 12:19:30 +0530
Message-ID: <1339397377-3374-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120611_084834_889616_55994B4D)
In-Reply-To: <1339397377-3374-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339397377-3374-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not doing so, could cause imbalance in powersave count.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c0f478b..e655f2a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1258,6 +1258,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		if (ath_set_channel(sc, hw, &sc->sc_ah->channels[pos]) < 0) {
 			ath_err(common, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
+			ath9k_ps_restore(sc);
 			return -EINVAL;
 		}
 
-- 
1.7.10.4

