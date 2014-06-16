Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4183 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaFPQif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:35 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 13/25] wil6210: debug print when scan request state changes
Date: Mon, 16 Jun 2014 19:37:11 +0300
Message-ID: <1402936643-31819-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190457_773810_86DDDC6A)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 1 +
 drivers/net/wireless/ath/wil6210/main.c     | 2 ++
 drivers/net/wireless/ath/wil6210/wmi.c      | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index a3042cd..850a2f1 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -287,6 +287,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
+	wil_dbg_misc(wil, "Start scan_request 0x%p\n", request);
 	wil->scan_request = request;
 	mod_timer(&wil->scan_timer, jiffies + WIL6210_SCAN_TO);
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 11e6d9d..33b89d1 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -552,6 +552,8 @@ static int __wil_down(struct wil6210_priv *wil)
 	napi_disable(&wil->napi_tx);
 
 	if (wil->scan_request) {
+		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
+			     wil->scan_request);
 		del_timer_sync(&wil->scan_timer);
 		cfg80211_scan_done(wil->scan_request, true);
 		wil->scan_request = NULL;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 1c5e6e9..281a28f 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -362,6 +362,9 @@ static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 		bool aborted = (data->status != WMI_SCAN_SUCCESS);
 
 		wil_dbg_wmi(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
+		wil_dbg_misc(wil, "Complete scan_request 0x%p aborted %d\n",
+			     wil->scan_request, aborted);
+
 		del_timer_sync(&wil->scan_timer);
 		cfg80211_scan_done(wil->scan_request, aborted);
 		wil->scan_request = NULL;
-- 
1.9.1

