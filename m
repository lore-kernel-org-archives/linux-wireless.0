Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30703 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2DMNIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 09:08:17 -0400
From: Ming Jiang <mjiang@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>,
	<linux-wireless@vger.kernel.org>
CC: Ming Jiang <mjiang@qca.qualcomm.com>
Subject: [PATCH v2] Allow deepsleep_suspend function when wlan interface down
Date: Fri, 13 Apr 2012 21:09:25 +0800
Message-ID: <1334322565-7893-1-git-send-email-mjiang@qca.qualcomm.com> (sfid-20120413_150820_545087_6B3889CF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl: after wlan interface down. WLAN_ENABLED flags will be cleared.
deepsleep_suspend function will be blocked in this senario. This patch 
allows deepsleep_suspend function when wlan interface down by removed 
the WLAN_ENABLED flag checking

Signed-off-by: Ming Jiang <mjiang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 90420ee..c9fbfac 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2154,8 +2154,10 @@ static int ath6kl_cfg80211_deepsleep_suspend(struct ath6kl *ar)
 	if (!vif)
 		return -EIO;
 
-	if (!ath6kl_cfg80211_ready(vif))
+	if (!test_bit(WMI_READY, &ar->flag)) {
+		ath6kl_err("deepsleep failed as wmi is not ready\n");
 		return -EIO;
+	}
 
 	ath6kl_cfg80211_stop_all(ar);
 
-- 
1.7.1

