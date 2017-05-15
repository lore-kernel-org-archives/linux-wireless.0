Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45044 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756867AbdEOLqJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 07:46:09 -0400
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 3/5] wil6210: Improve AP stop handling
Date: Mon, 15 May 2017 14:45:57 +0300
Message-Id: <1494848759-3651-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170515_134620_788300_ACBAB5A7)
In-Reply-To: <1494848759-3651-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1494848759-3651-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

Set resetting flag early when stopping AP to avoid
disconnect events as a result of disconnect command
sent during AP stop procedure.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index aa9ce30..567fe43 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1446,6 +1446,8 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 	wil6210_bus_request(wil, WIL_DEFAULT_BUS_REQUEST_KBPS);
 	wil_set_recovery_state(wil, fw_recovery_idle);
 
+	set_bit(wil_status_resetting, wil->status);
+
 	mutex_lock(&wil->mutex);
 
 	wmi_pcp_stop(wil);
-- 
1.9.1
