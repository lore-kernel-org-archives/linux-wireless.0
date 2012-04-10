Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:32996 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758489Ab2DJDHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 23:07:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/5] mwifiex: set default regulatory domain
Date: Mon,  9 Apr 2012 20:06:54 -0700
Message-Id: <1334027217-23724-3-git-send-email-bzhao@marvell.com> (sfid-20120410_050722_012066_764A303B)
In-Reply-To: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
References: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Driver gets region code from FW during initialisation. This patch
makes use of it for settting default regulatory domain using
regulatory_hint() API.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 ++++++
 drivers/net/wireless/mwifiex/cfp.c      |   31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h     |    1 +
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c7e8918..bd07030 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1422,6 +1422,7 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 	void *wdev_priv;
 	struct wireless_dev *wdev;
 	struct ieee80211_sta_ht_cap *ht_info;
+	u8 *country_code;
 
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev) {
@@ -1484,6 +1485,11 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 			"info: successfully registered wiphy device\n");
 	}
 
+	country_code = mwifiex_11d_code_2_region(priv->adapter->region_code);
+	if (country_code && regulatory_hint(wdev->wiphy, country_code))
+		dev_err(priv->adapter->dev,
+			"%s: regulatory_hint failed\n", __func__);
+
 	priv->wdev = wdev;
 
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 2fe1c33..560871b 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -71,6 +71,37 @@ u16 region_code_index[MWIFIEX_MAX_REGION_CODE] = { 0x10, 0x20, 0x30,
 
 static u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
 
+struct region_code_mapping {
+	u8 code;
+	u8 region[IEEE80211_COUNTRY_STRING_LEN];
+};
+
+static struct region_code_mapping region_code_mapping_t[] = {
+	{ 0x10, "US " }, /* US FCC */
+	{ 0x20, "CA " }, /* IC Canada */
+	{ 0x30, "EU " }, /* ETSI */
+	{ 0x31, "ES " }, /* Spain */
+	{ 0x32, "FR " }, /* France */
+	{ 0x40, "JP " }, /* Japan */
+	{ 0x41, "JP " }, /* Japan */
+	{ 0x50, "CN " }, /* China */
+};
+
+/* This function converts integer code to region string */
+u8 *mwifiex_11d_code_2_region(u8 code)
+{
+	u8 i;
+	u8 size = sizeof(region_code_mapping_t)/
+				sizeof(struct region_code_mapping);
+
+	/* Look for code in mapping table */
+	for (i = 0; i < size; i++)
+		if (region_code_mapping_t[i].code == code)
+			return region_code_mapping_t[i].region;
+
+	return NULL;
+}
+
 /*
  * This function maps an index in supported rates table into
  * the corresponding data rate.
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index fcccf6b..e601c46 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -965,6 +965,7 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 					u32 *flags, struct vif_params *params);
 int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev);
 
+u8 *mwifiex_11d_code_2_region(u8 code);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
-- 
1.7.0.2

