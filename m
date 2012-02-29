Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48363 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2B2NIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 08:08:12 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Set background scan period.
Date: Wed, 29 Feb 2012 18:38:04 +0530
Message-ID: <1330520884-15503-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120229_140820_854453_B952CA5B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After connect command, send scan params WMI command to
set background scan period. If period value is zero
send 0xffff as bg scan period to disable bg scan.

This patch depends on below patch
cfg80211: Add background scan period attribute.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a91f521..8e984d7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -578,6 +578,15 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 					vif->req_bssid, vif->ch_hint,
 					ar->connect_ctrl_flags, nw_subtype);
 
+	if (sme->bg_scan_period >= 0) {
+		/* disable bg scan if period is 0 */
+		if (sme->bg_scan_period == 0)
+			sme->bg_scan_period = 0xffff;
+
+		ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0, 0,
+			sme->bg_scan_period, 0, 0, 0, 3, 0, 0, 0);
+	}
+
 	up(&ar->sem);
 
 	if (status == -EINVAL) {
-- 
1.7.4.1

