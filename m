Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41752 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751192AbdH1TTG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 15:19:06 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 6/7] wil6210: increase connect timeout
Date: Mon, 28 Aug 2017 22:18:46 +0300
Message-Id: <1503947927-18877-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170828_211909_932286_7A84FD3D)
In-Reply-To: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Connect can take longer than current timeout in some scenarios,
for example with long-range antenna array. Increase the timeout
to support these scenarios.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 9b529ea..0712a89 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -811,7 +811,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 		wil->bss = bss;
 		/* Connect can take lots of time */
 		mod_timer(&wil->connect_timer,
-			  jiffies + msecs_to_jiffies(2000));
+			  jiffies + msecs_to_jiffies(5000));
 	} else {
 		clear_bit(wil_status_fwconnecting, wil->status);
 	}
-- 
1.9.1
