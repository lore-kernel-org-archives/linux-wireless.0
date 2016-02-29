Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42548 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbcB2Vc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 16:32:59 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 02/15] wil6210: AP: prevent connecting to already connected station
Date: Mon, 29 Feb 2016 23:32:37 +0200
Message-Id: <1456781570-16552-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160229_223303_542875_5376F53E)
In-Reply-To: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wmi_evt_connect doesn't check if the connect event is received for
an already connected station.
This can lead to memory leak as a new vring is allocated without
freeing the previously allocated vring and to unexpected behavior
of nl80211 layer due to unexpected notification of a new station.

Add a check in wmi_evt_connect in AP mode to verify that the requested
CID is not associated to an already connected station.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 493e721..fb09035 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -487,6 +487,14 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 			return;
 		}
 		del_timer_sync(&wil->connect_timer);
+	} else if ((wdev->iftype == NL80211_IFTYPE_AP) ||
+		   (wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
+		if (wil->sta[evt->cid].status != wil_sta_unused) {
+			wil_err(wil, "%s: AP: Invalid status %d for CID %d\n",
+				__func__, wil->sta[evt->cid].status, evt->cid);
+			mutex_unlock(&wil->mutex);
+			return;
+		}
 	}
 
 	/* FIXME FW can transmit only ucast frames to peer */
-- 
1.8.5.2

