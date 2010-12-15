Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51751 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0LOHdP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 02:33:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 23:32:59 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>, <lrodriguez@atheros.com>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Add comments for making pm-qos as modparam
Date: Wed, 15 Dec 2010 13:02:46 +0530
Message-ID: <1292398366-4906-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

PM-QOS value can be user specified via module parameter.
This patch adds few comments regarding this in the driver
code.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 36f4f5a..4d64716 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1196,6 +1196,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
+	/* User has the option to provide pm-qos value as a module
+	 * parameter rather than using the default value of
+	 * 'ATH9K_PM_QOS_DEFAULT_VALUE'.
+	 */
 	pm_qos_update_request(&sc->pm_qos_req, ath9k_pm_qos_value);
 
 	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
-- 
1.7.0.4

