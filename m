Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2744 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1HOICo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 04:02:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 2/4] ath6kl: Avoid finding bss presence in cfg80211 scan list
Date: Mon, 15 Aug 2011 01:04:01 -0700
Message-ID: <1313395443-5392-3-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110815_100248_828336_E15E0DD1)
In-Reply-To: <1313395443-5392-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1313395443-5392-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Connect event handler function is always reporting BSS info
to CFG80211 layer first and then followed by connect event is passed.

Before these steps, BSS presence is retrieved from CFG80211 layer,
but it is not used. Hence, removing that part.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 201398e..e88b519 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -425,8 +425,6 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 	unsigned char *ptr_ie_buf = ie_buf;
 	unsigned char *ieeemgmtbuf = NULL;
 	u8 source_mac[ETH_ALEN];
-	u16 capa_mask;
-	u16 capa_val;
 
 	/* capinfo + listen interval */
 	u8 assoc_req_ie_offset = sizeof(u16) + sizeof(u16);
@@ -459,24 +457,6 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 		}
 	}
 
-	if (nw_type & ADHOC_NETWORK) {
-		capa_mask = WLAN_CAPABILITY_IBSS;
-		capa_val = WLAN_CAPABILITY_IBSS;
-	} else {
-		capa_mask = WLAN_CAPABILITY_ESS;
-		capa_val = WLAN_CAPABILITY_ESS;
-	}
-
-	/* Before informing the join/connect event, make sure that
-	 * bss entry is present in scan list, if it not present
-	 * construct and insert into scan list, otherwise that
-	 * event will be dropped on the way by cfg80211, due to
-	 * this keys will not be plumbed in case of WEP and
-	 * application will not be aware of join/connect status. */
-	bss = cfg80211_get_bss(ar->wdev->wiphy, NULL, bssid,
-			       ar->wdev->ssid, ar->wdev->ssid_len,
-			       capa_mask, capa_val);
-
 	/*
 	 * Earlier we were updating the cfg about bss by making a beacon frame
 	 * only if the entry for bss is not there. This can have some issue if
@@ -527,7 +507,6 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 	ieeemgmtbuf = kzalloc(size, GFP_ATOMIC);
 	if (!ieeemgmtbuf) {
 		ath6kl_err("ieee mgmt buf alloc error\n");
-		cfg80211_put_bss(bss);
 		return;
 	}
 
-- 
1.7.1

