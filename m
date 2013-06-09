Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48828 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3FIGNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 02:13:16 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/6] wil6210: Derive IE's for AP
Date: Sun, 9 Jun 2013 09:12:53 +0300
Message-ID: <1370758375-16867-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130609_081319_172933_567490CF)
In-Reply-To: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When starting secure AP, in some cases wpa_s provides probe template but not
probe/assoc IE's. In this case, derive missing IE's from probe.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 4eb05d0..189c307 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -402,6 +402,30 @@ static int wil_cfg80211_set_default_key(struct wiphy *wiphy,
 	return 0;
 }
 
+static int wil_fix_bcon(struct wil6210_priv *wil,
+			struct cfg80211_beacon_data *bcon)
+{
+	struct ieee80211_mgmt *f = (struct ieee80211_mgmt *)bcon->probe_resp;
+	size_t hlen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+	int rc = 0;
+
+	if (bcon->probe_resp_len <= hlen)
+		return 0;
+
+	if (!bcon->proberesp_ies) {
+		bcon->proberesp_ies = f->u.probe_resp.variable;
+		bcon->proberesp_ies_len = bcon->probe_resp_len - hlen;
+		rc = 1;
+	}
+	if (!bcon->assocresp_ies) {
+		bcon->assocresp_ies = f->u.probe_resp.variable;
+		bcon->assocresp_ies_len = bcon->probe_resp_len - hlen;
+		rc = 1;
+	}
+
+	return rc;
+}
+
 static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 				 struct net_device *ndev,
 				 struct cfg80211_ap_settings *info)
@@ -423,6 +447,9 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	print_hex_dump_bytes("SSID ", DUMP_PREFIX_OFFSET,
 			     info->ssid, info->ssid_len);
 
+	if (wil_fix_bcon(wil, bcon))
+		wil_dbg_misc(wil, "Fixed bcon\n");
+
 	rc = wil_reset(wil);
 	if (rc)
 		return rc;
-- 
1.8.1.2

