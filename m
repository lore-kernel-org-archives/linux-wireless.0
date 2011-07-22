Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3158 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1GVFnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 27/31] ath6kl: don't force foreground scan when connected
Date: Fri, 22 Jul 2011 08:42:00 +0300
Message-ID: <1311313324-6766-29-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074346_504020_5813165E)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In my setup data transfer stalls when there's data transmission during
scan. After some testing I found out that using background scan
when connected to makes the problem go away. This is more like
a workaround than a proper fix, but as the stall is so severe the
workaround is justified.

With a dual band card this increases scan time when connected from
1.9s to 4.4s. When not connected the scan time is not affected and
is the same 1.9s.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a70d2ac..b9090b8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -779,7 +779,6 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
 	int ret = 0;
-	u32 force_fg_scan = 0;
 
 	if (!ath6kl_cfg80211_ready(ar))
 		return -EIO;
@@ -807,10 +806,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 						  request->ssids[i].ssid);
 	}
 
-	if (test_bit(CONNECTED, &ar->flag))
-		force_fg_scan = 1;
-
-	if (ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, force_fg_scan,
+	if (ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
 				     false, 0, 0, 0, NULL) != 0) {
 		ath6kl_err("wmi_startscan_cmd failed\n");
 		ret = -EIO;
-- 
1.7.1

