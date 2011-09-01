Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:39813 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab1IAJHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:07:43 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id EE48A8CA2F
	for <linux-wireless@vger.kernel.org>; Thu,  1 Sep 2011 12:07:41 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id DCD78158A63
	for <linux-wireless@vger.kernel.org>; Thu,  1 Sep 2011 12:07:38 +0300 (EEST)
Subject: [PATCH] ath6kl: fix compilation when NL80211_TESTMODE is disabled
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Thu, 01 Sep 2011 12:07:33 +0300
Message-ID: <20110901090733.7373.36100.stgit@localhost6.localdomain6> (sfid-20110901_110746_555374_FE52BE77)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ERROR: "ath6kl_tm_rx_report_event"
[drivers/net/wireless/ath/ath6kl/ath6kl.ko] undefined

Reported-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/testmode.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/testmode.h b/drivers/net/wireless/ath/ath6kl/testmode.h
index 2e6b723..43dffcc 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.h
+++ b/drivers/net/wireless/ath/ath6kl/testmode.h
@@ -16,5 +16,21 @@
 
 #include "core.h"
 
+#ifdef CONFIG_NL80211_TESTMODE
+
 void ath6kl_tm_rx_report_event(struct ath6kl *ar, void *buf, size_t buf_len);
 int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len);
+
+#else
+
+static inline void ath6kl_tm_rx_report_event(struct ath6kl *ar, void *buf,
+					     size_t buf_len)
+{
+}
+
+static inline int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len)
+{
+	return 0;
+}
+
+#endif

