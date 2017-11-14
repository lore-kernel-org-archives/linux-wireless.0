Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54362 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755369AbdKNN0C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 08:26:02 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v3 08/12] wil6210: missing length check in wil_cfg80211_mgmt_tx
Date: Tue, 14 Nov 2017 15:25:40 +0200
Message-Id: <1510665944-30198-9-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171114_142612_538932_3C590B6D)
In-Reply-To: <1510665944-30198-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1510665944-30198-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add a length check in wil_cfg80211_mgmt_tx to detect unsigned integer
overflow.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c3d3c0c..771a534 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -901,7 +901,7 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 u64 *cookie)
 {
 	const u8 *buf = params->buf;
-	size_t len = params->len;
+	size_t len = params->len, total;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	int rc;
 	bool tx_status = false;
@@ -926,7 +926,11 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (len < sizeof(struct ieee80211_hdr_3addr))
 		return -EINVAL;
 
-	cmd = kmalloc(sizeof(*cmd) + len, GFP_KERNEL);
+	total = sizeof(*cmd) + len;
+	if (total < len)
+		return -EINVAL;
+
+	cmd = kmalloc(total, GFP_KERNEL);
 	if (!cmd) {
 		rc = -ENOMEM;
 		goto out;
@@ -936,7 +940,7 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	cmd->len = cpu_to_le16(len);
 	memcpy(cmd->payload, buf, len);
 
-	rc = wmi_call(wil, WMI_SW_TX_REQ_CMDID, cmd, sizeof(*cmd) + len,
+	rc = wmi_call(wil, WMI_SW_TX_REQ_CMDID, cmd, total,
 		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
 	if (rc == 0)
 		tx_status = !evt.evt.status;
-- 
1.9.1
