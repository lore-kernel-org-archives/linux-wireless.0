Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35049 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbdBHOlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 09:41:50 -0500
Received: by mail-wm0-f46.google.com with SMTP id v186so50092172wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 06:40:44 -0800 (PST)
From: Koen Vandeputte <koen.vandeputte@ncentric.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Piotr Gawlowicz <gawlowicz@tkn.tu-berlin.de>,
        =?UTF-8?q?Miko=C5=82aj=20Chwalisz?= <chwalisz@tkn.tu-berlin.de>
Subject: [PATCH] mac80211: fix CSA in IBSS mode
Date: Wed,  8 Feb 2017 15:32:05 +0100
Message-Id: <1486564325-14251-1-git-send-email-koen.vandeputte@ncentric.com> (sfid-20170208_154234_171021_DE7F57CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the missing IBSS capability flag during capability init as it needs
to be inserted into the generated beacon in order for CSA to work.

Signed-off-by: Piotr Gawlowicz <gawlowicz@tkn.tu-berlin.de>
Signed-off-by: Mikołaj Chwalisz <chwalisz@tkn.tu-berlin.de>
Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
---
 net/mac80211/ibss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a31d307..98999d3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -487,14 +487,14 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *presp, *old_presp;
 	struct cfg80211_bss *cbss;
 	const struct cfg80211_bss_ies *ies;
-	u16 capability = 0;
+	u16 capability = WLAN_CAPABILITY_IBSS;
 	u64 tsf;
 	int ret = 0;
 
 	sdata_assert_lock(sdata);
 
 	if (ifibss->privacy)
-		capability = WLAN_CAPABILITY_PRIVACY;
+		capability |= WLAN_CAPABILITY_PRIVACY;
 
 	cbss = cfg80211_get_bss(sdata->local->hw.wiphy, ifibss->chandef.chan,
 				ifibss->bssid, ifibss->ssid,
-- 
2.7.4
