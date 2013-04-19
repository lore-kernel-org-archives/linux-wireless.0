Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59873 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3DSUBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 16:01:03 -0400
Received: by mail-yh0-f74.google.com with SMTP id q10so469746yhf.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 13:01:01 -0700 (PDT)
Received: from clearcreek.mtv.corp.google.com (clearcreek.mtv.corp.google.com [172.22.73.104])
	by corp2gmr1-1.hot.corp.google.com (Postfix) with ESMTP id 0CB0E31C0F7
	for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 12:53:14 -0700 (PDT)
From: Paul Stewart <pstew@chromium.org>
Date: Fri, 19 Apr 2013 08:37:46 -0700
Subject: [PATCH] mwifiex: Start P2P devices in P2P mode
To: linux-wireless@vger.kernel.org
Message-Id: <20130419195313.9C63F200742@clearcreek.mtv.corp.google.com> (sfid-20130419_220109_751206_64093224)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p2p devices should identify themselves as such to userspace at
startup, so the connection manager can decide which interface
to start wpa_supplicant instances on.

Signed-off-by: Paul Stewart <pstew@chromium.org>
Reviewed-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4701294..8c468c3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2136,10 +2136,9 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 		/* At start-up, wpa_supplicant tries to change the interface
 		 * to NL80211_IFTYPE_STATION if it is not managed mode.
-		 * So, we initialize it to STA mode.
 		 */
-		wdev->iftype = NL80211_IFTYPE_STATION;
-		priv->bss_mode = NL80211_IFTYPE_STATION;
+		wdev->iftype = NL80211_IFTYPE_P2P_CLIENT;
+		priv->bss_mode = NL80211_IFTYPE_P2P_CLIENT;
 
 		/* Setting bss_type to P2P tells firmware that this interface
 		 * is receiving P2P peers found during find phase and doing
-- 
1.8.2.1

