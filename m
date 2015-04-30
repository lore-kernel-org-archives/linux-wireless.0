Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12278 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbbD3NZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2015 09:25:25 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 4/7] wil6210: fix for probe_resp IE's
Date: Thu, 30 Apr 2015 16:25:08 +0300
Message-Id: <1430400311-3861-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150430_152530_834957_EEDAEF8C)
In-Reply-To: <1430400311-3861-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1430400311-3861-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parameters for the start_ap and change_bcon contains
probe response template and probe response IE's.

supplicant puts in the proberesp_ies only WPS related IE's,
while firmware need all IE's, most notable is RSN that is not
included in the proberesp_ies.

Always use IE's provided by the bcon->probe_resp

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 31 +++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index ea331e4..f53a190 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -669,11 +669,6 @@ static int wil_fix_bcon(struct wil6210_priv *wil,
 	if (bcon->probe_resp_len <= hlen)
 		return 0;
 
-	if (!bcon->proberesp_ies) {
-		bcon->proberesp_ies = f->u.probe_resp.variable;
-		bcon->proberesp_ies_len = bcon->probe_resp_len - hlen;
-		rc = 1;
-	}
 	if (!bcon->assocresp_ies) {
 		bcon->assocresp_ies = f->u.probe_resp.variable;
 		bcon->assocresp_ies_len = bcon->probe_resp_len - hlen;
@@ -688,9 +683,19 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 				      struct cfg80211_beacon_data *bcon)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct ieee80211_mgmt *f = (struct ieee80211_mgmt *)bcon->probe_resp;
+	size_t hlen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+	const u8 *pr_ies = NULL;
+	size_t pr_ies_len = 0;
 	int rc;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
+	wil_print_bcon_data(bcon);
+
+	if (bcon->probe_resp_len > hlen) {
+		pr_ies = f->u.probe_resp.variable;
+		pr_ies_len = bcon->probe_resp_len - hlen;
+	}
 
 	if (wil_fix_bcon(wil, bcon)) {
 		wil_dbg_misc(wil, "Fixed bcon\n");
@@ -703,9 +708,7 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 	 * wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->beacon_ies_len,
 	 * bcon->beacon_ies);
 	 */
-	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_RESP,
-			bcon->proberesp_ies_len,
-			bcon->proberesp_ies);
+	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_RESP, pr_ies_len, pr_ies);
 	if (rc) {
 		wil_err(wil, "set_ie(PROBE_RESP) failed\n");
 		return rc;
@@ -733,6 +736,10 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	struct cfg80211_beacon_data *bcon = &info->beacon;
 	struct cfg80211_crypto_settings *crypto = &info->crypto;
 	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
+	struct ieee80211_mgmt *f = (struct ieee80211_mgmt *)bcon->probe_resp;
+	size_t hlen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+	const u8 *pr_ies = NULL;
+	size_t pr_ies_len = 0;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
@@ -752,6 +759,11 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	wil_print_bcon_data(bcon);
 	wil_print_crypto(wil, crypto);
 
+	if (bcon->probe_resp_len > hlen) {
+		pr_ies = f->u.probe_resp.variable;
+		pr_ies_len = bcon->probe_resp_len - hlen;
+	}
+
 	if (wil_fix_bcon(wil, bcon)) {
 		wil_dbg_misc(wil, "Fixed bcon\n");
 		wil_print_bcon_data(bcon);
@@ -779,8 +791,7 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	 * wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->beacon_ies_len,
 	 * bcon->beacon_ies);
 	 */
-	wmi_set_ie(wil, WMI_FRAME_PROBE_RESP, bcon->proberesp_ies_len,
-		   bcon->proberesp_ies);
+	wmi_set_ie(wil, WMI_FRAME_PROBE_RESP, pr_ies_len, pr_ies);
 	wmi_set_ie(wil, WMI_FRAME_ASSOC_RESP, bcon->assocresp_ies_len,
 		   bcon->assocresp_ies);
 
-- 
2.1.0

