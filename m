Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3625 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbbC3I3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:29:19 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 2/5] wil6210: debug [add|del]_key operations
Date: Mon, 30 Mar 2015 11:28:51 +0300
Message-Id: <1427704134-30699-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150330_102924_566481_82E3900E)
In-Reply-To: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide info for [add|del]_key.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 8f7596f..d027a7f 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -569,6 +569,9 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
+	wil_dbg_misc(wil, "%s(%pM[%d] %s)\n", __func__, mac_addr, key_index,
+		     pairwise ? "PTK" : "GTK");
+
 	/* group key is not used */
 	if (!pairwise)
 		return 0;
@@ -584,6 +587,9 @@ static int wil_cfg80211_del_key(struct wiphy *wiphy,
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
+	wil_dbg_misc(wil, "%s(%pM[%d] %s)\n", __func__, mac_addr, key_index,
+		     pairwise ? "PTK" : "GTK");
+
 	/* group key is not used */
 	if (!pairwise)
 		return 0;
-- 
2.1.0

