Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19593 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763120AbXJSVRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 17:17:32 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: Fix SSID matching in AP selection
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Fri, 19 Oct 2007 17:14:36 -0400
Message-Id: <200710191714.36200.flamingice@sourmilk.net> (sfid-20071019_221736_647584_37E41D58)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The length of the SSID desired should also be compared in addition to
the memcmp of the SSIDs.

Thanks to Andrea Merello <andreamrl@tiscali.it> for finding this issue.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---
This should also go to stable.

 net/mac80211/ieee80211_sta.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 7c93f29..dd5415d 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2098,7 +2098,8 @@ static int ieee80211_sta_match_ssid(struct ieee80211_if_sta *ifsta,
 {
 	int tmp, hidden_ssid;
 
-	if (!memcmp(ifsta->ssid, ssid, ssid_len))
+	if (ssid_len == ifsta->ssid_len &&
+	    !memcmp(ifsta->ssid, ssid, ssid_len))
 		return 1;
 
 	if (ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL)


