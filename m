Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54358 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755314AbdKNNZz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 08:25:55 -0500
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 04/12] wil6210: abort properly in cfg suspend
Date: Tue, 14 Nov 2017 15:25:36 +0200
Message-Id: <1510665944-30198-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171114_142603_337091_0CF5BCD8)
In-Reply-To: <1510665944-30198-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1510665944-30198-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

On-going operations were not aborted properly
and required locks were not taken.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 85d5c04..c3d3c0c 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1727,9 +1727,12 @@ static int wil_cfg80211_suspend(struct wiphy *wiphy,
 
 	wil_dbg_pm(wil, "suspending\n");
 
-	wil_p2p_stop_discovery(wil);
-
+	mutex_lock(&wil->mutex);
+	mutex_lock(&wil->p2p_wdev_mutex);
+	wil_p2p_stop_radio_operations(wil);
 	wil_abort_scan(wil, true);
+	mutex_unlock(&wil->p2p_wdev_mutex);
+	mutex_unlock(&wil->mutex);
 
 out:
 	return rc;
-- 
1.9.1
