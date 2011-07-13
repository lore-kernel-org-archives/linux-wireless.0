Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:42072 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab1GMBdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 21:33:41 -0400
Subject: [PATCH 04/24] ath6kl: add cfg80211.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com
Date: Wed, 13 Jul 2011 04:33:35 +0300
Message-ID: <20110713013335.8517.33529.stgit@localhost6.localdomain6> (sfid-20110713_033344_652390_C886320A)
In-Reply-To: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.h |   39 ++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/cfg80211.h

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
new file mode 100644
index 0000000..a84adc2
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (c) 2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef ATH6KL_CFG80211_H
+#define ATH6KL_CFG80211_H
+
+struct wireless_dev *ath6kl_cfg80211_init(struct device *dev);
+void ath6kl_cfg80211_deinit(struct ath6kl *ar);
+
+void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status);
+
+void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
+				   u8 *bssid, u16 listen_intvl,
+				   u16 beacon_intvl,
+				   enum network_type nw_type,
+				   u8 beacon_ie_len, u8 assoc_req_len,
+				   u8 assoc_resp_len, u8 *assoc_info);
+
+void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
+				      u8 *bssid, u8 assoc_resp_len,
+				      u8 *assoc_info, u16 proto_reason);
+
+void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl *ar, u8 keyid,
+				     bool ismcast);
+
+#endif /* ATH6KL_CFG80211_H */

