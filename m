Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19831 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab3LNCd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 21:33:29 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: download per country tx power table to firmware
Date: Fri, 13 Dec 2013 18:33:02 -0800
Message-ID: <1386988382-30023-4-git-send-email-bzhao@marvell.com> (sfid-20131214_033345_380052_BE7839AA)
In-Reply-To: <1386988382-30023-1-git-send-email-bzhao@marvell.com>
References: <1386988382-30023-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When driver gets regulatory domain change notifications or before
associates to an AP with Country IE, the txpwrlimit table stored
in device tree for that country is downloaded to firmware.

The txpwrlimit downloading will happen only at the first time
when the alpha2 country code is changed. World regulatory domain
"00" notification doesn't trigger the downloading. This behavior
is same as domain_info command.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  | 10 ++++++++++
 drivers/net/wireless/mwifiex/main.h      |  2 ++
 drivers/net/wireless/mwifiex/sta_cmd.c   |  4 ++--
 drivers/net/wireless/mwifiex/sta_ioctl.c |  7 +++++++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 611fbcf..0a10500 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -538,6 +538,8 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 				 struct regulatory_request *request)
 {
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	struct mwifiex_private *priv = mwifiex_get_priv(adapter,
+							MWIFIEX_BSS_ROLE_ANY);
 
 	wiphy_dbg(wiphy, "info: cfg80211 regulatory domain callback for %c%c\n",
 		  request->alpha2[0], request->alpha2[1]);
@@ -561,6 +563,14 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 		memcpy(adapter->country_code, request->alpha2,
 		       sizeof(request->alpha2));
 		mwifiex_send_domain_info_cmd_fw(wiphy);
+
+		if (adapter->dt_node) {
+			char txpwr[] = {"marvell,00_txpwrlimit"};
+
+			memcpy(&txpwr[8], adapter->country_code, 2);
+			mwifiex_dnld_dt_cfgdata(priv, adapter->dt_node,
+						txpwr);
+		}
 	}
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 2f50354..ab34164 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1153,6 +1153,8 @@ void mwifiex_uap_del_sta_data(struct mwifiex_private *priv,
 void mwifiex_11h_process_join(struct mwifiex_private *priv, u8 **buffer,
 			      struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_11h_handle_event_chanswann(struct mwifiex_private *priv);
+int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
+			    struct device_node *node, const char *prefix);
 
 extern const struct ethtool_ops mwifiex_ethtool_ops;
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 6a95086..9c2404c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1156,8 +1156,8 @@ static u32 mwifiex_parse_cal_cfg(u8 *src, size_t len, u8 *dst)
 	return d - dst;
 }
 
-static int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
-				   struct device_node *node, const char *prefix)
+int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
+			    struct device_node *node, const char *prefix)
 {
 #ifdef CONFIG_OF
 	struct property *prop;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 3259e00..874ecec 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -234,6 +234,13 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 		return -1;
 	}
 
+	if (priv->adapter->dt_node) {
+		char txpwr[] = {"marvell,00_txpwrlimit"};
+
+		memcpy(&txpwr[8], priv->adapter->country_code, 2);
+		mwifiex_dnld_dt_cfgdata(priv, priv->adapter->dt_node, txpwr);
+	}
+
 	return 0;
 }
 
-- 
1.8.2.3

