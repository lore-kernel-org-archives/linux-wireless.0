Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49754 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752349AbeC1Rk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 13:40:29 -0400
From: Colin King <colin.king@canonical.com>
To: Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] wil6210: fix potential null dereference of ndev before null check
Date: Wed, 28 Mar 2018 18:40:27 +0100
Message-Id: <20180328174027.31551-1-colin.king@canonical.com> (sfid-20180328_194046_345375_7B0BD302)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The pointer ndev is being dereferenced before it is being null checked,
hence there is a potential null pointer deference. Fix this by only
dereferencing ndev after it has been null checked

Detected by CoverityScan, CID#1467010 ("Dereference before null check")

Fixes: e00243fab84b ("wil6210: infrastructure for multiple virtual interfaces")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a4b413e8d55a..82aec6b06d09 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -391,7 +391,7 @@ static void wil_fw_error_worker(struct work_struct *work)
 	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
 						fw_error_worker);
 	struct net_device *ndev = wil->main_ndev;
-	struct wireless_dev *wdev = ndev->ieee80211_ptr;
+	struct wireless_dev *wdev;
 
 	wil_dbg_misc(wil, "fw error worker\n");
 
@@ -399,6 +399,7 @@ static void wil_fw_error_worker(struct work_struct *work)
 		wil_info(wil, "No recovery - interface is down\n");
 		return;
 	}
+	wdev = ndev->ieee80211_ptr;
 
 	/* increment @recovery_count if less then WIL6210_FW_RECOVERY_TO
 	 * passed since last recovery attempt
-- 
2.15.1
