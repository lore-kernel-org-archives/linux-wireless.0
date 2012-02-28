Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33643 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754302Ab2B1GFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 01:05:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/6] mwifiex: remove unnecessary struct mwifiex_802_11_ssid
Date: Mon, 27 Feb 2012 22:04:14 -0800
Message-Id: <1330409056-4399-5-git-send-email-bzhao@marvell.com> (sfid-20120228_070548_900039_7D49C183)
In-Reply-To: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
References: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Use struct cfg80211_ssid available in include/net/cfg80211.h
instead of having similar definition in driver.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    4 ++--
 drivers/net/wireless/mwifiex/decl.h      |    5 -----
 drivers/net/wireless/mwifiex/ioctl.h     |    4 ++--
 drivers/net/wireless/mwifiex/join.c      |    4 ++--
 drivers/net/wireless/mwifiex/main.h      |   15 +++++++--------
 drivers/net/wireless/mwifiex/scan.c      |    7 +++----
 drivers/net/wireless/mwifiex/sta_event.c |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |    5 ++---
 8 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 55293a3..6a91c2f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -839,12 +839,12 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		       u8 *bssid, int mode, struct ieee80211_channel *channel,
 		       struct cfg80211_connect_params *sme, bool privacy)
 {
-	struct mwifiex_802_11_ssid req_ssid;
+	struct cfg80211_ssid req_ssid;
 	int ret, auth_type = 0;
 	struct cfg80211_bss *bss = NULL;
 	u8 is_scanning_required = 0;
 
-	memset(&req_ssid, 0, sizeof(struct mwifiex_802_11_ssid));
+	memset(&req_ssid, 0, sizeof(struct cfg80211_ssid));
 
 	req_ssid.ssid_len = ssid_len;
 	if (ssid_len > IEEE80211_MAX_SSID_LEN) {
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 3735c77..be5fd16 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -91,11 +91,6 @@ struct mwifiex_fw_image {
 	u32 fw_len;
 };
 
-struct mwifiex_802_11_ssid {
-	u32 ssid_len;
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-};
-
 struct mwifiex_wait_queue {
 	wait_queue_head_t wait;
 	int status;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index d5d81f1..7ca4e82 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -50,7 +50,7 @@ struct mwifiex_chan_freq {
 };
 
 struct mwifiex_ssid_bssid {
-	struct mwifiex_802_11_ssid ssid;
+	struct cfg80211_ssid ssid;
 	u8 bssid[ETH_ALEN];
 };
 
@@ -122,7 +122,7 @@ struct mwifiex_ver_ext {
 
 struct mwifiex_bss_info {
 	u32 bss_mode;
-	struct mwifiex_802_11_ssid ssid;
+	struct cfg80211_ssid ssid;
 	u32 bss_chan;
 	u32 region_code;
 	u32 media_connected;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 5c95e48..bce9991 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -714,7 +714,7 @@ done:
 int
 mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *cmd,
-				struct mwifiex_802_11_ssid *req_ssid)
+				struct cfg80211_ssid *req_ssid)
 {
 	int rsn_ie_len = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1245,7 +1245,7 @@ int mwifiex_associate(struct mwifiex_private *priv,
  */
 int
 mwifiex_adhoc_start(struct mwifiex_private *priv,
-		    struct mwifiex_802_11_ssid *adhoc_ssid)
+		    struct cfg80211_ssid *adhoc_ssid)
 {
 	dev_dbg(priv->adapter->dev, "info: Adhoc Channel = %d\n",
 		priv->adhoc_channel);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index dddb556..a0bd4eb 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -244,7 +244,7 @@ struct ieee_types_generic {
 
 struct mwifiex_bssdescriptor {
 	u8 mac_address[ETH_ALEN];
-	struct mwifiex_802_11_ssid ssid;
+	struct cfg80211_ssid ssid;
 	u32 privacy;
 	s32 rssi;
 	u32 channel;
@@ -388,7 +388,7 @@ struct mwifiex_private {
 	s16 bcn_rssi_avg;
 	s16 bcn_nf_avg;
 	struct mwifiex_bssdescriptor *attempted_bss_desc;
-	struct mwifiex_802_11_ssid prev_ssid;
+	struct cfg80211_ssid prev_ssid;
 	u8 prev_bssid[ETH_ALEN];
 	struct mwifiex_current_bss_params curr_bss_params;
 	u16 beacon_period;
@@ -747,8 +747,7 @@ void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 			    struct cmd_ctrl_node *cmd_node);
 int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			    struct host_cmd_ds_command *resp);
-s32 mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
-		       struct mwifiex_802_11_ssid *ssid2);
+s32 mwifiex_ssid_cmp(struct cfg80211_ssid *ssid1, struct cfg80211_ssid *ssid2);
 int mwifiex_associate(struct mwifiex_private *priv,
 		      struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
@@ -760,12 +759,12 @@ void mwifiex_reset_connect_state(struct mwifiex_private *priv);
 u8 mwifiex_band_to_radio_type(u8 band);
 int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac);
 int mwifiex_adhoc_start(struct mwifiex_private *priv,
-			struct mwifiex_802_11_ssid *adhoc_ssid);
+			struct cfg80211_ssid *adhoc_ssid);
 int mwifiex_adhoc_join(struct mwifiex_private *priv,
 		       struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				    struct host_cmd_ds_command *cmd,
-				    struct mwifiex_802_11_ssid *req_ssid);
+				    struct cfg80211_ssid *req_ssid);
 int mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *cmd,
 				   struct mwifiex_bssdescriptor *bss_desc);
@@ -898,7 +897,7 @@ int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 			    struct net_device *dev);
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter);
 int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
-		      struct mwifiex_802_11_ssid *req_ssid);
+		      struct cfg80211_ssid *req_ssid);
 int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
 int mwifiex_disable_auto_ds(struct mwifiex_private *priv);
@@ -907,7 +906,7 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv,
 int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 			      struct mwifiex_rate_cfg *rate);
 int mwifiex_request_scan(struct mwifiex_private *priv,
-			 struct mwifiex_802_11_ssid *req_ssid);
+			 struct cfg80211_ssid *req_ssid);
 int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 				struct mwifiex_user_scan_cfg *scan_req);
 int mwifiex_change_adhoc_chan(struct mwifiex_private *priv, int channel);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 8f10038..67422f6 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -163,8 +163,7 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
  * This function compares two SSIDs and checks if they match.
  */
 s32
-mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
-		 struct mwifiex_802_11_ssid *ssid2)
+mwifiex_ssid_cmp(struct cfg80211_ssid *ssid1, struct cfg80211_ssid *ssid2)
 {
 	if (!ssid1 || !ssid2 || (ssid1->ssid_len != ssid2->ssid_len))
 		return -1;
@@ -1851,7 +1850,7 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
  * firmware, filtered on a specific SSID.
  */
 static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
-				      struct mwifiex_802_11_ssid *req_ssid)
+				      struct cfg80211_ssid *req_ssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
@@ -1896,7 +1895,7 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
  * scan, depending upon whether an SSID is provided or not.
  */
 int mwifiex_request_scan(struct mwifiex_private *priv,
-			 struct mwifiex_802_11_ssid *req_ssid)
+			 struct cfg80211_ssid *req_ssid)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index d7aa21d..b9b59db 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -101,7 +101,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 
 	memcpy(&priv->prev_ssid,
 	       &priv->curr_bss_params.bss_descriptor.ssid,
-	       sizeof(struct mwifiex_802_11_ssid));
+	       sizeof(struct cfg80211_ssid));
 
 	memcpy(priv->prev_bssid,
 	       priv->curr_bss_params.bss_descriptor.mac_address, ETH_ALEN);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index e10161f..593d285 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -192,7 +192,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
  * first.
  */
 int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
-		      struct mwifiex_802_11_ssid *req_ssid)
+		      struct cfg80211_ssid *req_ssid)
 {
 	int ret;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -464,8 +464,7 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 
 	info->bss_mode = priv->bss_mode;
 
-	memcpy(&info->ssid, &bss_desc->ssid,
-	       sizeof(struct mwifiex_802_11_ssid));
+	memcpy(&info->ssid, &bss_desc->ssid, sizeof(struct cfg80211_ssid));
 
 	memcpy(&info->bssid, &bss_desc->mac_address, ETH_ALEN);
 
-- 
1.7.0.2

