Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61306 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3FIGNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 02:13:20 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/6] wil6210: Init Rx vring right after reset
Date: Sun, 9 Jun 2013 09:12:55 +0300
Message-ID: <1370758375-16867-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130609_081323_463409_C4620668)
In-Reply-To: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

at the vring initialisation, memory pool get allocated in the FW.
Make it 1-st because FW need this memory pool to precess
next commands

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 7 +++++--
 drivers/net/wireless/ath/wil6210/main.c     | 8 +++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 189c307..61c302a 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -454,6 +454,11 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (rc)
 		return rc;
 
+	/* Rx VRING. */
+	rc = wil_rx_init(wil);
+	if (rc)
+		return rc;
+
 	rc = wmi_set_ssid(wil, info->ssid_len, info->ssid);
 	if (rc)
 		return rc;
@@ -482,8 +487,6 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (rc)
 		return rc;
 
-	/* Rx VRING. After MAC and beacon */
-	rc = wil_rx_init(wil);
 
 	netif_carrier_on(ndev);
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c97b864..8cafa45 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -295,6 +295,11 @@ static int __wil_up(struct wil6210_priv *wil)
 	if (rc)
 		return rc;
 
+	/* Rx VRING. After MAC and beacon */
+	rc = wil_rx_init(wil);
+	if (rc)
+		return rc;
+
 	/* FIXME Firmware works now in PBSS mode(ToDS=0, FromDS=0) */
 	wmi_nettype = wil_iftype_nl2wmi(NL80211_IFTYPE_ADHOC);
 	switch (wdev->iftype) {
@@ -356,9 +361,6 @@ static int __wil_up(struct wil6210_priv *wil)
 			return rc;
 	}
 
-	/* Rx VRING. After MAC and beacon */
-	wil_rx_init(wil);
-
 	napi_enable(&wil->napi_rx);
 	napi_enable(&wil->napi_tx);
 
-- 
1.8.1.2

