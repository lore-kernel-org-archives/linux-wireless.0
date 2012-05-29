Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:58630 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752728Ab2E2Wj3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:39:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] cfg80211: use sme_state in ibss start/join path
Date: Tue, 29 May 2012 15:39:06 -0700
Message-Id: <1338331146-13540-3-git-send-email-bzhao@marvell.com> (sfid-20120530_003943_184809_FFE847E8)
In-Reply-To: <1338331146-13540-1-git-send-email-bzhao@marvell.com>
References: <1338331146-13540-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

CFG80211_DEV_WARN_ON() at "net/wireless/ibss.c line 63"
is unnecessarily triggered even after successful connection,
when cfg80211_ibss_joined() is called by driver inside
.join_ibss handler.

This patch fixes the problem by changing 'sme_state' in ibss path
and having WARN_ON() check for 'sme_state' similar to infra
association.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 net/wireless/ibss.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 30f20fe..3d0930d 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -42,6 +42,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
 	cfg80211_hold_bss(bss_from_pub(bss));
 	wdev->current_bss = bss_from_pub(bss);
 
+	wdev->sme_state = CFG80211_SME_CONNECTED;
 	cfg80211_upload_connect_keys(wdev);
 
 	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid,
@@ -60,7 +61,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
-	CFG80211_DEV_WARN_ON(!wdev->ssid_len);
+	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTING);
 
 	ev = kzalloc(sizeof(*ev), gfp);
 	if (!ev)
@@ -115,9 +116,11 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.channel = params->channel;
 #endif
+	wdev->sme_state = CFG80211_SME_CONNECTING;
 	err = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
 	if (err) {
 		wdev->connect_keys = NULL;
+		wdev->sme_state = CFG80211_SME_IDLE;
 		return err;
 	}
 
@@ -169,6 +172,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 	}
 
 	wdev->current_bss = NULL;
+	wdev->sme_state = CFG80211_SME_IDLE;
 	wdev->ssid_len = 0;
 #ifdef CONFIG_CFG80211_WEXT
 	if (!nowext)
-- 
1.7.0.2

