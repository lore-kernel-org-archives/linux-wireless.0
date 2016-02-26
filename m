Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42826 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbcBZOGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 09:06:43 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] mac80211_hwsim: Support a hw scan request for a specific BSSID
Date: Fri, 26 Feb 2016 16:06:06 +0200
Message-ID: <1456495566-14272-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20160226_150653_965928_D6FA9057)
In-Reply-To: <1456495566-14272-1-git-send-email-jouni@qca.qualcomm.com>
References: <1456495566-14272-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the hw scan request specifies a single BSSID, use that value instead
of the wildcard BSSID in the Probe Request frames.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a723a85..281c6b7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1909,6 +1909,7 @@ static void hw_scan_work(struct work_struct *work)
 		/* send probes */
 		for (i = 0; i < req->n_ssids; i++) {
 			struct sk_buff *probe;
+			struct ieee80211_mgmt *mgmt;
 
 			probe = ieee80211_probereq_get(hwsim->hw,
 						       hwsim->scan_addr,
@@ -1918,6 +1919,10 @@ static void hw_scan_work(struct work_struct *work)
 			if (!probe)
 				continue;
 
+			mgmt = (struct ieee80211_mgmt *) probe->data;
+			memcpy(mgmt->da, req->bssid, ETH_ALEN);
+			memcpy(mgmt->bssid, req->bssid, ETH_ALEN);
+
 			if (req->ie_len)
 				memcpy(skb_put(probe, req->ie_len), req->ie,
 				       req->ie_len);
-- 
1.9.1

