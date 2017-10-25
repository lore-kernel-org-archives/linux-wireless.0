Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35612 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdJYNO2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 09:14:28 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 08/12] wil6210: missing length check in wil_cfg80211_mgmt_tx
Date: Wed, 25 Oct 2017 16:14:03 +0300
Message-Id: <1508937247-11890-9-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171025_151434_479742_7CE03D8C)
In-Reply-To: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
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
