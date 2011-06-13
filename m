Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16158 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1FMPjr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 11:39:47 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 08:39:13 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] cfg80211: skip checking of SSID for maintaining scan list
Date: Mon, 13 Jun 2011 21:09:40 +0530
Message-ID: <1307979580-11360-1-git-send-email-mshajakhan@atheros.com> (sfid-20110613_173950_964758_FD24D5AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

when we connect to hidden SSID AP's we maintain two entries
for the same AP and we update all the parameters for the hidden
SSID entry rather than the associated entry, this is because we
have the SSID check in updating/adding new entries in scanlist.
by skipping the SSID check we will maintain a single entry for
the hidden SSID and also update the associated entry for the
same.
  will this break something if I skip SSID check for the sake
of hidden SSID AP's or is there someother IE's I can check for.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/wireless/scan.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7a6c676..eace508 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -348,15 +348,8 @@ static int cmp_bss(struct cfg80211_bss *a,
 			       b->len_information_elements);
 	}
 
-	r = memcmp(a->bssid, b->bssid, ETH_ALEN);
-	if (r)
-		return r;
-
-	return cmp_ies(WLAN_EID_SSID,
-		       a->information_elements,
-		       a->len_information_elements,
-		       b->information_elements,
-		       b->len_information_elements);
+	return memcmp(a->bssid, b->bssid, ETH_ALEN);
+
 }
 
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
-- 
1.7.0.4

