Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3625 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbbC3I3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:29:20 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 3/5] wil6210: trace disconnect source
Date: Mon, 30 Mar 2015 11:28:52 +0300
Message-Id: <1427704134-30699-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150330_102928_537204_BE11FD40)
In-Reply-To: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trace where wil6210_disconnect() is called from.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index d027a7f..ec46a94 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -507,6 +507,8 @@ static int wil_cfg80211_disconnect(struct wiphy *wiphy,
 	int rc;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
+	wil_dbg_misc(wil, "%s(reason=%d)\n", __func__, reason_code);
+
 	rc = wmi_send(wil, WMI_DISCONNECT_CMDID, NULL, 0);
 
 	return rc;
@@ -836,6 +838,9 @@ static int wil_cfg80211_del_station(struct wiphy *wiphy,
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
+	wil_dbg_misc(wil, "%s(%pM, reason=%d)\n", __func__, params->mac,
+		     params->reason_code);
+
 	mutex_lock(&wil->mutex);
 	wil6210_disconnect(wil, params->mac, params->reason_code, false);
 	mutex_unlock(&wil->mutex);
-- 
2.1.0

