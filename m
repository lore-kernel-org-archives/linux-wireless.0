Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14421 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbaFPQiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:14 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 02/25] wil6210: indicate mgmt_tx status
Date: Mon, 16 Jun 2014 19:37:00 +0300
Message-ID: <1402936643-31819-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183822_460790_E24F7871)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inform cfg80211 about Tx result

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 1725dfc..cfdf1a2 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -451,6 +451,7 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	size_t len = params->len;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	int rc;
+	bool tx_status = false;
 	struct ieee80211_mgmt *mgmt_frame = (void *)buf;
 	struct wmi_sw_tx_req_cmd *cmd;
 	struct {
@@ -459,8 +460,10 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	} __packed evt;
 
 	cmd = kmalloc(sizeof(*cmd) + len, GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
+	if (!cmd) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	memcpy(cmd->dst_mac, mgmt_frame->da, WMI_MAC_LEN);
 	cmd->len = cpu_to_le16(len);
@@ -469,10 +472,12 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	rc = wmi_call(wil, WMI_SW_TX_REQ_CMDID, cmd, sizeof(*cmd) + len,
 		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
 	if (rc == 0)
-		rc = evt.evt.status;
+		tx_status = !evt.evt.status;
 
 	kfree(cmd);
-
+ out:
+	cfg80211_mgmt_tx_status(wdev, cookie ? *cookie : 0, buf, len,
+				tx_status, GFP_KERNEL);
 	return rc;
 }
 
-- 
1.9.1

