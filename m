Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32952 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757266AbaAHXqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 18:46:18 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: use a function to replace two copies of a code fragment
Date: Wed, 8 Jan 2014 15:45:57 -0800
Message-ID: <1389224757-14339-2-git-send-email-bzhao@marvell.com> (sfid-20140109_004622_534376_A18468A4)
In-Reply-To: <1389224757-14339-1-git-send-email-bzhao@marvell.com>
References: <1389224757-14339-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of having two copies of the code for device tree cfgdata
downloading, add a function to improve the code.

Reviewed-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |  9 +--------
 drivers/net/wireless/mwifiex/main.h      |  1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c | 17 +++++++++++------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b994679..e7c81ab 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -563,14 +563,7 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 		memcpy(adapter->country_code, request->alpha2,
 		       sizeof(request->alpha2));
 		mwifiex_send_domain_info_cmd_fw(wiphy);
-
-		if (adapter->dt_node) {
-			char txpwr[] = {"marvell,00_txpwrlimit"};
-
-			memcpy(&txpwr[8], adapter->country_code, 2);
-			mwifiex_dnld_dt_cfgdata(priv, adapter->dt_node,
-						txpwr);
-		}
+		mwifiex_dnld_txpwr_table(priv);
 	}
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ab34164..d8ad554 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1155,6 +1155,7 @@ void mwifiex_11h_process_join(struct mwifiex_private *priv, u8 **buffer,
 int mwifiex_11h_handle_event_chanswann(struct mwifiex_private *priv);
 int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
 			    struct device_node *node, const char *prefix);
+void mwifiex_dnld_txpwr_table(struct mwifiex_private *priv);
 
 extern const struct ethtool_ops mwifiex_ethtool_ops;
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 3edc92f..c5cb2ed 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -184,6 +184,16 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	return mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
 }
 
+void mwifiex_dnld_txpwr_table(struct mwifiex_private *priv)
+{
+	if (priv->adapter->dt_node) {
+		char txpwr[] = {"marvell,00_txpwrlimit"};
+
+		memcpy(&txpwr[8], priv->adapter->country_code, 2);
+		mwifiex_dnld_dt_cfgdata(priv, priv->adapter->dt_node, txpwr);
+	}
+}
+
 static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 				      struct cfg80211_bss *bss)
 {
@@ -234,12 +244,7 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	if (priv->adapter->dt_node) {
-		char txpwr[] = {"marvell,00_txpwrlimit"};
-
-		memcpy(&txpwr[8], priv->adapter->country_code, 2);
-		mwifiex_dnld_dt_cfgdata(priv, priv->adapter->dt_node, txpwr);
-	}
+	mwifiex_dnld_txpwr_table(priv);
 
 	return 0;
 }
-- 
1.8.2.3

