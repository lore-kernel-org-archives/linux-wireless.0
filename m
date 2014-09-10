Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58844 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaIJNfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:38 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Dedy Lansky <qca_dlansky@qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/22] wil6210: add change_beacon() driver callback
Date: Wed, 10 Sep 2014 16:34:44 +0300
Message-ID: <1410356091-19219-16-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153543_538735_CA0B5F52)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows updating IEs (e.g. from hostapd) when AP is already started

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 40 +++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c1ff330..61eaf20 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -640,6 +640,45 @@ static int wil_fix_bcon(struct wil6210_priv *wil,
 	return rc;
 }
 
+static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
+				      struct net_device *ndev,
+				      struct cfg80211_beacon_data *bcon)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	if (wil_fix_bcon(wil, bcon)) {
+		wil_dbg_misc(wil, "Fixed bcon\n");
+		wil_print_bcon_data(bcon);
+	}
+
+	/* FW do not form regular beacon, so bcon IE's are not set
+	 * For the DMG bcon, when it will be supported, bcon IE's will
+	 * be reused; add something like:
+	 * wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->beacon_ies_len,
+	 * bcon->beacon_ies);
+	 */
+	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_RESP,
+			bcon->proberesp_ies_len,
+			bcon->proberesp_ies);
+	if (rc) {
+		wil_err(wil, "set_ie(PROBE_RESP) failed\n");
+		return rc;
+	}
+
+	rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_RESP,
+			bcon->assocresp_ies_len,
+			bcon->assocresp_ies);
+	if (rc) {
+		wil_err(wil, "set_ie(ASSOC_RESP) failed\n");
+		return rc;
+	}
+
+	return 0;
+}
+
 static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 				 struct net_device *ndev,
 				 struct cfg80211_ap_settings *info)
@@ -764,6 +803,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.del_key = wil_cfg80211_del_key,
 	.set_default_key = wil_cfg80211_set_default_key,
 	/* AP mode */
+	.change_beacon = wil_cfg80211_change_beacon,
 	.start_ap = wil_cfg80211_start_ap,
 	.stop_ap = wil_cfg80211_stop_ap,
 	.del_station = wil_cfg80211_del_station,
-- 
1.9.1

