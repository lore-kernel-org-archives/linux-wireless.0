Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4713 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaIJNf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:29 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	"Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/22] wil6210: fix race condition of disconnect while BACK event
Date: Wed, 10 Sep 2014 16:34:40 +0300
Message-ID: <1410356091-19219-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153559_865917_F5FA1BDC)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

This race condition was causing double free of tid_ampdu_rx structures

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 97909f0..c71657b 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -597,16 +597,18 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 		return;
 	}
 
+	mutex_lock(&wil->mutex);
+
 	cid = wil->vring2cid_tid[evt->ringid][0];
 	if (cid >= WIL6210_MAX_CID) {
 		wil_err(wil, "invalid CID %d for vring %d\n", cid, evt->ringid);
-		return;
+		goto out;
 	}
 
 	sta = &wil->sta[cid];
 	if (sta->status == wil_sta_unused) {
 		wil_err(wil, "CID %d unused\n", cid);
-		return;
+		goto out;
 	}
 
 	wil_dbg_wmi(wil, "BACK for CID %d %pM\n", cid, sta->addr);
@@ -618,6 +620,9 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 			sta->tid_rx[i] = wil_tid_ampdu_rx_alloc(wil,
 						evt->agg_wsize, 0);
 	}
+
+out:
+	mutex_unlock(&wil->mutex);
 }
 
 static const struct {
-- 
1.9.1

