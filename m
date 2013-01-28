Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54326 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3A1Qib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:31 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/14] wil6210: Fix "don't scan after connect" logic
Date: Mon, 28 Jan 2013 18:31:03 +0200
Message-ID: <1359390669-9310-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173834_727651_F92DC461)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When connect times out, scan was not re-enabled.

Strictly say, it is firmware issue - it should issue "disconnect"
event but it does not. Compensate in the driver.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c |    2 ++
 drivers/net/wireless/ath/wil6210/wmi.c  |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 90786df..3e9a71f 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -85,6 +85,8 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++)
 		wil_vring_fini_tx(wil, i);
+
+	clear_bit(wil_status_dontscan, &wil->status);
 }
 
 static void wil_disconnect_worker(struct work_struct *work)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d109c3f..dffb002 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -459,7 +459,6 @@ static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
 	wil->sinfo_gen++;
 
 	wil6210_disconnect(wil, evt->bssid);
-	clear_bit(wil_status_dontscan, &wil->status);
 }
 
 static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
-- 
1.7.10.4

