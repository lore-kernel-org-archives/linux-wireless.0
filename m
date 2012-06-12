Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:45321 "HELO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752883Ab2FLBOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 21:14:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.5] mwifiex: fix incorrect privacy setting in beacon and probe response
Date: Mon, 11 Jun 2012 18:13:57 -0700
Message-Id: <1339463637-10682-1-git-send-email-bzhao@marvell.com> (sfid-20120612_031445_770700_08F4D402)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Test procedure:
1. Start AP with security setting (e.g. WPA2)
2. Stop AP
3. Start AP with open security

Here it's observed that privacy is enabled in beacons and
probe responses.

This patch fixes it by checking the privacy parameter from
cfg80211_ap_settings. If privacy is not set in cfg80211_ap_settings,
set open authentication and no encryption in FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 8173ab6..89f9a2a 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -27,6 +27,17 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 			      struct cfg80211_ap_settings *params) {
 	int i;
 
+	if (!params->privacy) {
+		bss_config->protocol = PROTOCOL_NO_SECURITY;
+		bss_config->key_mgmt = KEY_MGMT_NONE;
+		bss_config->wpa_cfg.length = 0;
+		priv->sec_info.wep_enabled = 0;
+		priv->sec_info.wpa_enabled = 0;
+		priv->sec_info.wpa2_enabled = 0;
+
+		return 0;
+	}
+
 	switch (params->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		bss_config->auth_mode = WLAN_AUTH_OPEN;
-- 
1.7.0.2

