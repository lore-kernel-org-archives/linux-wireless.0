Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7288 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQNep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:45 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 03/21] wil6210: enable scan while connected
Date: Mon, 17 Mar 2014 15:34:07 +0200
Message-ID: <1395063265-6522-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_145649_983089_B545FDDD)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New firmware do support scan while connected. Enable it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 8 ++------
 drivers/net/wireless/ath/wil6210/main.c     | 2 --
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 7439303..b1bc007 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -282,7 +282,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 
 	/* FW don't support scan after connection attempt */
 	if (test_bit(wil_status_dontscan, &wil->status)) {
-		wil_err(wil, "Scan after connect attempt not supported\n");
+		wil_err(wil, "Can't scan now\n");
 		return -EBUSY;
 	}
 
@@ -402,10 +402,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 
 	memcpy(conn.bssid, bss->bssid, ETH_ALEN);
 	memcpy(conn.dst_mac, bss->bssid, ETH_ALEN);
-	/*
-	 * FW don't support scan after connection attempt
-	 */
-	set_bit(wil_status_dontscan, &wil->status);
+
 	set_bit(wil_status_fwconnecting, &wil->status);
 
 	rc = wmi_send(wil, WMI_CONNECT_CMDID, &conn, sizeof(conn));
@@ -414,7 +411,6 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 		mod_timer(&wil->connect_timer,
 			  jiffies + msecs_to_jiffies(2000));
 	} else {
-		clear_bit(wil_status_dontscan, &wil->status);
 		clear_bit(wil_status_fwconnecting, &wil->status);
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f10a0b2..4cc1b78 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -113,8 +113,6 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 						GFP_KERNEL);
 		}
 		clear_bit(wil_status_fwconnecting, &wil->status);
-		wil_dbg_misc(wil, "clear_bit(wil_status_dontscan)\n");
-		clear_bit(wil_status_dontscan, &wil->status);
 		break;
 	default:
 		/* AP-like interface and monitor:
-- 
1.8.3.2

