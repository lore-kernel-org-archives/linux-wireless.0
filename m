Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:56262 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaCUN6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:58:09 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so1857757eek.32
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:58:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/7] cfg80211: fix radar_detect combination checking
Date: Fri, 21 Mar 2014 14:52:15 +0100
Message-Id: <1395409941-26303-2-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145814_447718_8A233EF1)
In-Reply-To: <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
 <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All bits from radar_detect must match combination
radar bitmask. Otherwise it is theoretically
possible to lead into an invalid combination
provided a driver reports strange combinations.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * patch added

 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7fa3503..b534dc2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1301,7 +1301,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 			}
 		}
 
-		if (radar_detect && !(c->radar_detect_widths & radar_detect))
+		if (radar_detect != (c->radar_detect_widths & radar_detect))
 			goto cont;
 
 		/* Finally check that all iftypes that we're currently
-- 
1.8.5.3

