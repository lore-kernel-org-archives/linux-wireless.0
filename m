Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:48103 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754385Ab2B1GFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 01:05:50 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/6 V2] mwifiex: fix bug in wildcard scan handling
Date: Mon, 27 Feb 2012 22:04:15 -0800
Message-Id: <1330409056-4399-6-git-send-email-bzhao@marvell.com> (sfid-20120228_070553_945463_871FCC09)
In-Reply-To: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
References: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently if valid SSID list is provided in scan request, driver
performs specific SSID scan otherwise wildcard scan is chosen.

When wpa_supplicant provides valid SSID list followed by
zero-length SSID for wildcard scan, only specific SSID scan is
performed by driver. Actually driver is expected to do both type
of scanning in this case. The patch fixes this issue.

Also, use SSID list pointer provided by stack directly, instead
of copying SSID's to local structure.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
V2: Do not use strlen() on an SSID (Johanness Berg)

 drivers/net/wireless/mwifiex/cfg80211.c |   10 +++----
 drivers/net/wireless/mwifiex/fw.h       |   10 ++-----
 drivers/net/wireless/mwifiex/scan.c     |   40 +++++++++++++++---------------
 3 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6a91c2f..b4890a0 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1106,12 +1106,10 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 		dev_err(priv->adapter->dev, "failed to alloc scan_req\n");
 		return -ENOMEM;
 	}
-	for (i = 0; i < request->n_ssids; i++) {
-		memcpy(priv->user_scan_cfg->ssid_list[i].ssid,
-			request->ssids[i].ssid, request->ssids[i].ssid_len);
-		priv->user_scan_cfg->ssid_list[i].max_len =
-			request->ssids[i].ssid_len;
-	}
+
+	priv->user_scan_cfg->num_ssids = request->n_ssids;
+	priv->user_scan_cfg->ssid_list = request->ssids;
+
 	for (i = 0; i < request->n_channels; i++) {
 		chan = request->channels[i];
 		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index c826200..fc4ffee 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -852,11 +852,6 @@ struct mwifiex_user_scan_chan {
 	u32 scan_time;
 } __packed;
 
-struct mwifiex_user_scan_ssid {
-	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 max_len;
-} __packed;
-
 struct mwifiex_user_scan_cfg {
 	/*
 	 *  BSS mode to be sent in the firmware command
@@ -867,8 +862,9 @@ struct mwifiex_user_scan_cfg {
 	u8 reserved;
 	/* BSSID filter sent in the firmware command to limit the results */
 	u8 specific_bssid[ETH_ALEN];
-	/* SSID filter list used in the to limit the scan results */
-	struct mwifiex_user_scan_ssid ssid_list[MWIFIEX_MAX_SSID_LIST_LENGTH];
+	/* SSID filter list used in the firmware to limit the scan results */
+	struct cfg80211_ssid *ssid_list;
+	u8 num_ssids;
 	/* Variable number (fixed maximum) of channels to scan up */
 	struct mwifiex_user_scan_chan chan_list[MWIFIEX_USER_SCAN_CHAN_MAX];
 } __packed;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 67422f6..fd0302f 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -737,7 +737,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 	u16 scan_dur;
 	u8 channel;
 	u8 radio_type;
-	u32 ssid_idx;
+	int i;
 	u8 ssid_filter;
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
 	u32 rates_size;
@@ -792,14 +792,8 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		       user_scan_in->specific_bssid,
 		       sizeof(scan_cfg_out->specific_bssid));
 
-		for (ssid_idx = 0;
-		     ((ssid_idx < ARRAY_SIZE(user_scan_in->ssid_list))
-		      && (*user_scan_in->ssid_list[ssid_idx].ssid
-			  || user_scan_in->ssid_list[ssid_idx].max_len));
-		     ssid_idx++) {
-
-			ssid_len = strlen(user_scan_in->ssid_list[ssid_idx].
-					  ssid) + 1;
+		for (i = 0; i < user_scan_in->num_ssids; i++) {
+			ssid_len = user_scan_in->ssid_list[i].ssid_len;
 
 			wildcard_ssid_tlv =
 				(struct mwifiex_ie_types_wildcard_ssid_params *)
@@ -810,19 +804,26 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 				(u16) (ssid_len + sizeof(wildcard_ssid_tlv->
 							 max_ssid_length)));
 
-			/* max_ssid_length = 0 tells firmware to perform
-			   specific scan for the SSID filled */
-			wildcard_ssid_tlv->max_ssid_length = 0;
+			/*
+			 * max_ssid_length = 0 tells firmware to perform
+			 * specific scan for the SSID filled, whereas
+			 * max_ssid_length = IEEE80211_MAX_SSID_LEN is for
+			 * wildcard scan.
+			 */
+			if (ssid_len)
+				wildcard_ssid_tlv->max_ssid_length = 0;
+			else
+				wildcard_ssid_tlv->max_ssid_length =
+							IEEE80211_MAX_SSID_LEN;
 
 			memcpy(wildcard_ssid_tlv->ssid,
-			       user_scan_in->ssid_list[ssid_idx].ssid,
-			       ssid_len);
+			       user_scan_in->ssid_list[i].ssid, ssid_len);
 
 			tlv_pos += (sizeof(wildcard_ssid_tlv->header)
 				+ le16_to_cpu(wildcard_ssid_tlv->header.len));
 
-			dev_dbg(adapter->dev, "info: scan: ssid_list[%d]: %s, %d\n",
-				ssid_idx, wildcard_ssid_tlv->ssid,
+			dev_dbg(adapter->dev, "info: scan: ssid[%d]: %s, %d\n",
+				i, wildcard_ssid_tlv->ssid,
 				wildcard_ssid_tlv->max_ssid_length);
 
 			/* Empty wildcard ssid with a maxlen will match many or
@@ -831,7 +832,6 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 			   filtered. */
 			if (!ssid_len && wildcard_ssid_tlv->max_ssid_length)
 				ssid_filter = false;
-
 		}
 
 		/*
@@ -840,7 +840,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		 *  truncate scan results.  That is not an issue with an SSID
 		 *  or BSSID filter applied to the scan results in the firmware.
 		 */
-		if ((ssid_idx && ssid_filter)
+		if ((i && ssid_filter)
 		    || memcmp(scan_cfg_out->specific_bssid, &zero_mac,
 			      sizeof(zero_mac)))
 			*filtered_scan = true;
@@ -1876,8 +1876,8 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 		return -ENOMEM;
 	}
 
-	memcpy(scan_cfg->ssid_list[0].ssid, req_ssid->ssid,
-	       req_ssid->ssid_len);
+	scan_cfg->ssid_list = req_ssid;
+	scan_cfg->num_ssids = 1;
 
 	ret = mwifiex_scan_networks(priv, scan_cfg);
 
-- 
1.7.0.2

