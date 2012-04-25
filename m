Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44665 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2DYHIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 03:08:19 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Fix bss filter setting while scanning
Date: Wed, 25 Apr 2012 12:39:06 +0530
Message-ID: <1335337746-7294-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120425_090822_115131_C36EA52C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bss filter is configured to allow the frames from all the bss other
than the currenly connected one, this is done when a scan is requested
in connected state. There is no reason to filter out the currently
connected bss, configure the filter to allow all the bss. This would
fix the reporting of stale rssi of the current bss while scanning.

Reported-by: Naveen singh <navesing@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d417213..dd5e79a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -925,10 +925,8 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (!ar->usr_bss_filter) {
 		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &vif->flags);
-		ret = ath6kl_wmi_bssfilter_cmd(
-			ar->wmi, vif->fw_vif_idx,
-			(test_bit(CONNECTED, &vif->flags) ?
-			 ALL_BUT_BSS_FILTER : ALL_BSS_FILTER), 0);
+		ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+					       ALL_BSS_FILTER, 0);
 		if (ret) {
 			ath6kl_err("couldn't set bss filtering\n");
 			return ret;
-- 
1.7.0.4

