Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:39297 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZFPKy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 06:54:58 -0400
Received: by bwz9 with SMTP id 9so3942518bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 03:55:00 -0700 (PDT)
From: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
To: linux-wireless@vger.kernel.org
Cc: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Subject: [PATCH] wireless: Compare ethernet addresses by unaligned safe way
Date: Tue, 16 Jun 2009 13:54:32 +0300
Message-Id: <1245149672-18063-1-git-send-email-yauhen.kharuzhy@promwad.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we try to run RTL8187 driver on AD BlackFin platform, we got
messages from kernel about unaligned memory access at
compare_ether_addr() calls.

Replacing of compare_ether_addr() by memcmp() fixes this problem.

Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
---
 net/mac80211/ibss.c |    2 +-
 net/wireless/scan.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 0b30277..bcbb1ae 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -395,7 +395,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 		return NULL;
 	}
 
-	if (compare_ether_addr(bssid, sdata->u.ibss.bssid))
+	if (memcmp(bssid, sdata->u.ibss.bssid, ETH_ALEN))
 		return NULL;
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e95b638..6ad9b59 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -134,7 +134,7 @@ static bool is_bss(struct cfg80211_bss *a,
 {
 	const u8 *ssidie;
 
-	if (bssid && compare_ether_addr(a->bssid, bssid))
+	if (bssid && memcmp(a->bssid, bssid, ETH_ALEN))
 		return false;
 
 	if (!ssid)
-- 
1.6.3.1

