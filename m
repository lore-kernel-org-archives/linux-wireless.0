Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37504 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1VjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:39:00 -0500
Received: by vbbfc26 with SMTP id fc26so4193335vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 13:38:59 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 2/5] ath6kl: fix set tx power
Date: Mon, 28 Nov 2011 16:38:47 -0500
Message-Id: <1322516330-4007-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_223903_551982_7C9001A2)
In-Reply-To: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl assumed cfg80211 passed to us power in dBm but it is in mBm.

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---

Kalle queued this up already.

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0252604..9f3d3f0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1181,11 +1181,12 @@ static int ath6kl_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 */
 static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 				       enum nl80211_tx_power_setting type,
-				       int dbm)
+				       int mbm)
 {
 	struct ath6kl *ar = (struct ath6kl *)wiphy_priv(wiphy);
 	struct ath6kl_vif *vif;
 	u8 ath6kl_dbm;
+	int dbm = MBM_TO_DBM(mbm);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type 0x%x, dbm %d\n", __func__,
 		   type, dbm);
-- 
1.7.4.15.g7811d

