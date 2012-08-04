Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog028.obsmtp.com ([74.125.150.102]:40408 "EHLO
	na6sys009bog028.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab2HDBTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:19:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 07/16] mwifiex: update 11n status as per start_ap IE
Date: Fri,  3 Aug 2012 18:06:05 -0700
Message-Id: <1344042374-6892-8-git-send-email-bzhao@marvell.com> (sfid-20120804_031945_071396_E81C63DD)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

If HT IE is present in beacon_data of start_ap cfg80211 handler,
enable 11n flag in AP. Disable 11n flag when stop_ap handler is
called.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 ++
 drivers/net/wireless/mwifiex/init.c     |    1 +
 drivers/net/wireless/mwifiex/main.h     |    1 +
 drivers/net/wireless/mwifiex/uap_cmd.c  |    1 +
 4 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fe42137..1f80f7e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -906,6 +906,8 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	if (mwifiex_del_mgmt_ies(priv))
 		wiphy_err(wiphy, "Failed to delete mgmt IEs!\n");
 
+	priv->ap_11n_enabled = 0;
+
 	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
 				  HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(wiphy, "Failed to stop the BSS\n");
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 81fc8ed..118a29f 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -208,6 +208,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->curr_bcn_size = 0;
 	priv->wps_ie = NULL;
 	priv->wps_ie_len = 0;
+	priv->ap_11n_enabled = 0;
 
 	priv->scan_block = false;
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 16f046a..5eeb17c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -487,6 +487,7 @@ struct mwifiex_private {
 	u16 assocresp_idx;
 	u16 rsn_idx;
 	struct timer_list scan_delay_timer;
+	u8 ap_11n_enabled;
 };
 
 enum mwifiex_ba_status {
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index f40e93f..c10aac0 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -167,6 +167,7 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 	if (ht_ie) {
 		memcpy(&bss_cfg->ht_cap, ht_ie + 2,
 		       sizeof(struct ieee80211_ht_cap));
+		priv->ap_11n_enabled = 1;
 	} else {
 		memset(&bss_cfg->ht_cap , 0, sizeof(struct ieee80211_ht_cap));
 		bss_cfg->ht_cap.cap_info = cpu_to_le16(MWIFIEX_DEF_HT_CAP);
-- 
1.7.0.2

