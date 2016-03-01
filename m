Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbcCARSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 12:18:49 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 14/15] wil6210: pass is_go flag to firmware
Date: Tue,  1 Mar 2016 19:18:17 +0200
Message-Id: <1456852698-26808-15-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160301_181904_584345_D3D4FFA8)
In-Reply-To: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

When starting a PCP, pass the is_go flag to firmware in
wmi_pcp_start. This flag indicates whether we started
a PCP which is also a GO(P2P group owner) or just a regular
PCP.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 9 ++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h  | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c      | 3 ++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 33e5451..12cae3c 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1055,10 +1055,17 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	int rc;
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
+	u8 is_go = (wdev->iftype == NL80211_IFTYPE_P2P_GO);
 
 	if (pbss)
 		wmi_nettype = WMI_NETTYPE_P2P;
 
+	wil_dbg_misc(wil, "%s: is_go=%d\n", __func__, is_go);
+	if (is_go && !pbss) {
+		wil_err(wil, "%s: P2P GO must be in PBSS\n", __func__);
+		return -ENOTSUPP;
+	}
+
 	wil_set_recovery_state(wil, fw_recovery_idle);
 
 	mutex_lock(&wil->mutex);
@@ -1083,7 +1090,7 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	netif_carrier_on(ndev);
 
-	rc = wmi_pcp_start(wil, bi, wmi_nettype, chan, hidden_ssid);
+	rc = wmi_pcp_start(wil, bi, wmi_nettype, chan, hidden_ssid, is_go);
 	if (rc)
 		goto err_pcp_start;
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a23dcee..d18c448 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -802,7 +802,7 @@ void wil_p2p_wdev_free(struct wil6210_priv *wil);
 
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
 int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
-		  u8 chan, u8 hidden_ssid);
+		  u8 chan, u8 hidden_ssid, u8 is_go);
 int wmi_pcp_stop(struct wil6210_priv *wil);
 void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 			u16 reason_code, bool from_event);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index f076175..3cc4462 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -962,7 +962,7 @@ int wmi_set_mac_address(struct wil6210_priv *wil, void *addr)
 }
 
 int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
-		  u8 chan, u8 hidden_ssid)
+		  u8 chan, u8 hidden_ssid, u8 is_go)
 {
 	int rc;
 
@@ -973,6 +973,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype,
 		.channel = chan - 1,
 		.pcp_max_assoc_sta = max_assoc_sta,
 		.hidden_ssid = hidden_ssid,
+		.is_go = is_go,
 	};
 	struct {
 		struct wmi_cmd_hdr wmi;
-- 
1.8.5.2

