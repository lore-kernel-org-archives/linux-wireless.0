Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:46509 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754437Ab2B1GFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 01:05:55 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/6] mwifiex: remove BSS entry before specific SSID scan
Date: Mon, 27 Feb 2012 22:04:16 -0800
Message-Id: <1330409056-4399-7-git-send-email-bzhao@marvell.com> (sfid-20120228_070558_572954_B2EED4D1)
In-Reply-To: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
References: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Driver performs specific SSID scan operation when "iw dev <devname>
scan ssid <ssid>" command is fired.
Sometimes even if driver could not find the AP with requested SSID
in scanning, it is displayed in scan results based on history,
because scan table entries are valid in cfg80211 stack for 15 seconds.

This patch adds code to remove respective scan table entry before
performing specific SSID scan to make sure that correct scan results
are displayed to user.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index fd0302f..bb3b3ee 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -742,6 +742,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
 	u32 rates_size;
 	struct mwifiex_ie_types_htcap *ht_cap;
+	struct wiphy *wiphy = priv->wdev->wiphy;
 
 	/* The tlv_buf_len is calculated for each scan command.  The TLVs added
 	   in this routine will be preserved since the routine that sends the
@@ -793,7 +794,24 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		       sizeof(scan_cfg_out->specific_bssid));
 
 		for (i = 0; i < user_scan_in->num_ssids; i++) {
-			ssid_len = user_scan_in->ssid_list[i].ssid_len;
+			struct cfg80211_bss *bss;
+			const struct cfg80211_ssid *ssid =
+					&user_scan_in->ssid_list[i];
+
+			ssid_len = ssid->ssid_len;
+
+			/* Delete an entry for given SSID in scan table */
+			if (ssid_len) {
+				u32 capa =
+				    (priv->bss_mode == NL80211_IFTYPE_STATION) ?
+				    WLAN_CAPABILITY_ESS : WLAN_CAPABILITY_IBSS;
+
+				bss = cfg80211_get_bss(wiphy, NULL, NULL,
+						       ssid->ssid, ssid_len,
+						       capa, capa);
+				if (bss)
+					cfg80211_unlink_bss(wiphy, bss);
+			}
 
 			wildcard_ssid_tlv =
 				(struct mwifiex_ie_types_wildcard_ssid_params *)
@@ -816,8 +834,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 				wildcard_ssid_tlv->max_ssid_length =
 							IEEE80211_MAX_SSID_LEN;
 
-			memcpy(wildcard_ssid_tlv->ssid,
-			       user_scan_in->ssid_list[i].ssid, ssid_len);
+			memcpy(wildcard_ssid_tlv->ssid, ssid->ssid, ssid_len);
 
 			tlv_pos += (sizeof(wildcard_ssid_tlv->header)
 				+ le16_to_cpu(wildcard_ssid_tlv->header.len));
-- 
1.7.0.2

