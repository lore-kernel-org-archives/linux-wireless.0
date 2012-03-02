Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:52685 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759310Ab2CBU04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 15:26:56 -0500
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0C0C01AF
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:26:54 +0000 (GMT)
Received: from relay1.stm.gmessaging.net (unknown [10.230.100.17])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id AE04129FF
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:26:54 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay1.stm.gmessaging.net (Postfix) with ESMTPS id 7DFB924C2F2
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 21:26:44 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCHv2 10/21] cw1200: ht.h, small helper header with HT definitions.
Date: Fri, 2 Mar 2012 21:26:32 +0100
Message-ID: <1330720003-15866-11-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_212705_967068_828E352B)
In-Reply-To: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
 <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch implements HT-related inlines, used in the driver.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/net/wireless/cw1200/ht.h |   43 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/cw1200/ht.h

diff --git a/drivers/net/wireless/cw1200/ht.h b/drivers/net/wireless/cw1200/ht.h
new file mode 100644
index 0000000..5c486a6
--- /dev/null
+++ b/drivers/net/wireless/cw1200/ht.h
@@ -0,0 +1,43 @@
+/*
+ *  HT-related code for ST-Ericsson CW1200 driver
+ *
+ * Copyright (c) 2010-2012, ST-Ericsson AB
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

