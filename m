Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40766 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbcDYM6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 08:58:15 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 2/7] wil6210: support regular scan on P2P_DEVICE interface
Date: Mon, 25 Apr 2016 15:57:53 +0300
Message-Id: <1461589078-29854-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160425_145826_428869_B6A856E9)
In-Reply-To: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

P2P search can only run on the social channel (channel 2).
When issuing a scan request on the P2P_DEVICE interface,
driver ignored the channels argument and always performed a P2P
search.
Fix this by checking the channels argument, if it is
not specified (meaning full scan) or if a non-social channel
was specified, perform a regular scan and not a P2P search.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 5 +++--
 drivers/net/wireless/ath/wil6210/p2p.c      | 6 ++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 12cae3c..49eb2e2 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -375,8 +375,9 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
-	/* scan on P2P_DEVICE is handled as p2p search */
-	if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE) {
+	/* social scan on P2P_DEVICE is handled as p2p search */
+	if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
+	    wil_p2p_is_social_scan(request)) {
 		wil->scan_request = request;
 		wil->radio_wdev = wdev;
 		rc = wil_p2p_search(wil, request);
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index 2c1b895..1c91538 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -22,6 +22,12 @@
 #define P2P_SEARCH_DURATION_MS 500
 #define P2P_DEFAULT_BI 100
 
+bool wil_p2p_is_social_scan(struct cfg80211_scan_request *request)
+{
+	return (request->n_channels == 1) &&
+	       (request->channels[0]->hw_value == P2P_DMG_SOCIAL_CHANNEL);
+}
+
 void wil_p2p_discovery_timer_fn(ulong x)
 {
 	struct wil6210_priv *wil = (void *)x;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 5dee909..b6fc256 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -776,6 +776,7 @@ void wil_disable_irq(struct wil6210_priv *wil);
 void wil_enable_irq(struct wil6210_priv *wil);
 
 /* P2P */
+bool wil_p2p_is_social_scan(struct cfg80211_scan_request *request);
 void wil_p2p_discovery_timer_fn(ulong x);
 int wil_p2p_search(struct wil6210_priv *wil,
 		   struct cfg80211_scan_request *request);
-- 
1.8.5.2

