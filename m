Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:36194 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756171Ab2CBBls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 20:41:48 -0500
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D5EC92E3
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:44 +0000 (GMT)
Received: from relay2.stm.gmessaging.net (unknown [10.230.100.18])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 908CF47AD
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:44 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay2.stm.gmessaging.net (Postfix) with ESMTPS id 67CC1A8065
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 02:41:43 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 10/21] cw1200: ht.h, small helper header with HT definitions.
Date: Fri, 2 Mar 2012 02:41:24 +0100
Message-ID: <1330652495-25837-11-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024152_074512_B48905EB)
In-Reply-To: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch implements HT-related inlines, used in the driver.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/staging/cw1200/ht.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/cw1200/ht.h

diff --git a/drivers/staging/cw1200/ht.h b/drivers/staging/cw1200/ht.h
new file mode 100644
index 0000000..5c486a6
--- /dev/null
+++ b/drivers/staging/cw1200/ht.h
@@ -0,0 +1,43 @@
+/*
+ *  HT-related code for ST-Ericsson CW1200 driver
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CW1200_HT_H_INCLUDED
+#define CW1200_HT_H_INCLUDED
+
+#include <net/mac80211.h>
+
+struct cw1200_ht_info {
+	struct ieee80211_sta_ht_cap	ht_cap;
+	enum nl80211_channel_type	channel_type;
+	u16				operation_mode;
+};
+
+static inline int cw1200_is_ht(const struct cw1200_ht_info *ht_info)
+{
+	return ht_info->channel_type != NL80211_CHAN_NO_HT;
+}
+
+static inline int cw1200_ht_greenfield(const struct cw1200_ht_info *ht_info)
+{
+	return cw1200_is_ht(ht_info) &&
+		(ht_info->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
+		!(ht_info->operation_mode &
+			IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+}
+
+static inline int cw1200_ht_ampdu_density(const struct cw1200_ht_info *ht_info)
+{
+	if (!cw1200_is_ht(ht_info))
+		return 0;
+	return ht_info->ht_cap.ampdu_density;
+}
+
+#endif /* CW1200_HT_H_INCLUDED */
-- 
1.7.9

