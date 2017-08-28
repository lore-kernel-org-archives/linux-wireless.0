Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41752 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751192AbdH1TS6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 15:18:58 -0400
Cc: Gidon Studinski <QCA_gidons@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 2/7] wil6210: make debugfs compilation optional
Date: Mon, 28 Aug 2017 22:18:42 +0300
Message-Id: <1503947927-18877-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170828_211901_643109_CA13A475)
In-Reply-To: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gidon Studinski <qca_gidons@qca.qualcomm.com>

Since debugfs is a kernel configuration option, enable the driver to
compile without debugfs.

Signed-off-by: Gidon Studinski <qca_gidons@qca.qualcomm.com>
Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Kconfig   | 12 ++++++++++++
 drivers/net/wireless/ath/wil6210/Makefile  |  2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h |  6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index 6dfedc8..b448926 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -40,3 +40,15 @@ config WIL6210_TRACING
 	  option if you are interested in debugging the driver.
 
 	  If unsure, say Y to make it easier to debug problems.
+
+config WIL6210_DEBUGFS
+	bool "wil6210 debugfs support"
+	depends on WIL6210
+	depends on DEBUG_FS
+	default y
+	---help---
+	  Say Y here to enable wil6210 debugfs support, using the
+	  kernel debugfs infrastructure. Select this
+	  option if you are interested in debugging the driver.
+
+	  If unsure, say Y to make it easier to debug problems.
diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index 4ae21da..d27efe8 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -4,7 +4,7 @@ wil6210-y := main.o
 wil6210-y += netdev.o
 wil6210-y += cfg80211.o
 wil6210-y += pcie_bus.o
-wil6210-y += debugfs.o
+wil6210-$(CONFIG_WIL6210_DEBUGFS) += debugfs.o
 wil6210-y += wmi.o
 wil6210-y += interrupt.o
 wil6210-y += txrx.o
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 73dbd62..a8c2680 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -940,8 +940,14 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
 			 u64 *cookie);
 
+#if defined(CONFIG_WIL6210_DEBUGFS)
 int wil6210_debugfs_init(struct wil6210_priv *wil);
 void wil6210_debugfs_remove(struct wil6210_priv *wil);
+#else
+static inline int wil6210_debugfs_init(struct wil6210_priv *wil) { return 0; }
+static inline void wil6210_debugfs_remove(struct wil6210_priv *wil) {}
+#endif
+
 int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 		       struct station_info *sinfo);
 
-- 
1.9.1
