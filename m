Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:58887 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756958Ab2IKBb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:31:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 06/10] mwifiex: use country ie of requested AP while associating
Date: Mon, 10 Sep 2012 18:30:45 -0700
Message-Id: <1347327049-13665-7-git-send-email-bzhao@marvell.com> (sfid-20120911_033200_952641_148733F6)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

AP's country ie is parsed and 11d information is updated in firmware
while associating. Previous mwifiex_send_domain_info_cmd_fw() call in
association path is not necessary now. Hence it is removed in this
patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |   40 ++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 7113086..3a27554 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1157,7 +1157,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 			      ~priv->adapter->fw_bands))
 				priv->adapter->config_bands = config_bands;
 		}
-		mwifiex_send_domain_info_cmd_fw(priv->wdev->wiphy);
 	}
 
 	/* As this is new association, clear locally stored
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 3f02597..d7ad2d4 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -192,6 +192,44 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	return ret;
 }
 
+static int mwifiex_process_country_ie(struct mwifiex_private *priv,
+				      struct cfg80211_bss *bss)
+{
+	u8 *country_ie, country_ie_len;
+	struct mwifiex_802_11d_domain_reg *domain_info =
+					&priv->adapter->domain_reg;
+
+	country_ie = (u8 *)ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
+
+	if (!country_ie)
+		return 0;
+
+	country_ie_len = country_ie[1];
+	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
+		return 0;
+
+	domain_info->country_code[0] = country_ie[2];
+	domain_info->country_code[1] = country_ie[3];
+	domain_info->country_code[2] = ' ';
+
+	country_ie_len -= IEEE80211_COUNTRY_STRING_LEN;
+
+	domain_info->no_of_triplet =
+		country_ie_len / sizeof(struct ieee80211_country_ie_triplet);
+
+	memcpy((u8 *)domain_info->triplet,
+	       &country_ie[2] + IEEE80211_COUNTRY_STRING_LEN, country_ie_len);
+
+	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
+				   HostCmd_ACT_GEN_SET, 0, NULL)) {
+		wiphy_err(priv->adapter->wiphy,
+			  "11D: setting domain info in FW\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 /*
  * In Ad-Hoc mode, the IBSS is created if not found in scan list.
  * In both Ad-Hoc and infra mode, an deauthentication is performed
@@ -207,6 +245,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 	priv->scan_block = false;
 
 	if (bss) {
+		mwifiex_process_country_ie(priv, bss);
+
 		/* Allocate and fill new bss descriptor */
 		bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),
 				GFP_KERNEL);
-- 
1.7.0.2

