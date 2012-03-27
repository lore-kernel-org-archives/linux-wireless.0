Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46809 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab2C0Grm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 02:47:42 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Set background scan period.
Date: Tue, 27 Mar 2012 12:17:32 +0530
Message-ID: <1332830852-2348-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120327_084745_884930_B7AB7BDA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After connect command, send scan params WMI command to
set background scan period. If period value is zero
send 0xffff as bg scan period to disable bg scan.
Set default bg scan period to be 60 seconds if
not specified.

This patch depends on below patch
cfg80211: Add background scan period attribute.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index df95e0d..cf1e209 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -49,6 +49,8 @@
 	.max_power      = 30,                       \
 }
 
+#define DEFAULT_BG_SCAN_PERIOD 60
+
 static struct ieee80211_rate ath6kl_rates[] = {
 	RATETAB_ENT(10, 0x1, 0),
 	RATETAB_ENT(20, 0x2, 0),
@@ -607,6 +609,17 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 					vif->req_bssid, vif->ch_hint,
 					ar->connect_ctrl_flags, nw_subtype);
 
+	/* disable background scan if period is 0 */
+	if (sme->bg_scan_period == 0)
+		sme->bg_scan_period = 0xffff;
+
+	/* configure default value if not specified */
+	if (sme->bg_scan_period == -1)
+		sme->bg_scan_period = DEFAULT_BG_SCAN_PERIOD;
+
+	ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0, 0,
+		sme->bg_scan_period, 0, 0, 0, 3, 0, 0, 0);
+
 	up(&ar->sem);
 
 	if (status == -EINVAL) {
-- 
1.7.4.1

