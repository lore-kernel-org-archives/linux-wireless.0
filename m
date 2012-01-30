Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55831 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2A3LoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:44:14 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v3 4/4] ath6kl: Return a proper error code when not in connected state
Date: Mon, 30 Jan 2012 17:13:12 +0530
Message-ID: <1327923792-16408-5-git-send-email-rmani@qca.qualcomm.com> (sfid-20120130_124422_617344_A51A936E)
In-Reply-To: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com>
References: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Error code ENOTCONN is more suitable than EINVAL to report
when the driver is not in connected state in ath6kl_wow_suspend().

I found this during code review.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 1902e2f..5934e40 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1916,7 +1916,7 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 		return -EIO;
 
 	if (!test_bit(CONNECTED, &vif->flags))
-		return -EINVAL;
+		return -ENOTCONN;
 
 	if (wow && (wow->n_patterns > WOW_MAX_FILTERS_PER_LIST))
 		return -EINVAL;
-- 
1.7.1

