Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:56115 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2CLLX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 07:23:28 -0400
Subject: [PATCH 4/4] ath6kl: use max_t() in ath6kl_cfg80211_connect()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 12 Mar 2012 13:23:23 +0200
Message-ID: <20120312112323.23253.64415.stgit@x201> (sfid-20120312_122332_024706_C0FEA8AD)
In-Reply-To: <20120312112131.23253.74137.stgit@x201>
References: <20120312112131.23253.74137.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl/cfg80211.c:589: WARNING: max() should probably be
max_t(u16, vif->listen_intvl_t, ATH6KL_MAX_WOW_LISTEN_INTL)

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5ecc53a..00d3895 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -586,8 +586,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	vif->reconnect_flag = 0;
 
 	if (vif->nw_type == INFRA_NETWORK) {
-		interval = max(vif->listen_intvl_t,
-			       (u16) ATH6KL_MAX_WOW_LISTEN_INTL);
+		interval = max_t(u16, vif->listen_intvl_t,
+				 ATH6KL_MAX_WOW_LISTEN_INTL);
 		status = ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
 						       interval,
 						       0);

