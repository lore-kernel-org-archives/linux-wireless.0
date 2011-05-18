Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49415 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab1ERVnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 17:43:51 -0400
Received: by mail-ew0-f45.google.com with SMTP id 24so711397ewy.4
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 14:43:50 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	stable@kernel.org
Subject: [PATCH] nl80211: fix check for valid SSID size in scan operations
Date: Thu, 19 May 2011 00:43:38 +0300
Message-Id: <1305755018-11297-1-git-send-email-coelho@ti.com> (sfid-20110518_234355_148403_358331D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In both trigger_scan and sched_scan operations, we were checking for
the SSID length before assigning the value correctly.  Since the
memory was just kzalloc'ed, the check was always failing and SSID with
over 32 characters were allowed to go through.

This was causing a buffer overflow when copying the actual SSID to the
proper place.

This bug has been there since 2.6.29-rc4.

Cc: stable@kernel.org
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/wireless/nl80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d24f5c1..1c57036 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3412,12 +3412,12 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
+			request->ssids[i].ssid_len = nla_len(attr);
 			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
 			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
-			request->ssids[i].ssid_len = nla_len(attr);
 			i++;
 		}
 	}
@@ -3578,6 +3578,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS],
 				    tmp) {
+			request->ssids[i].ssid_len = nla_len(attr);
 			if (request->ssids[i].ssid_len >
 			    IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
@@ -3585,7 +3586,6 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 			}
 			memcpy(request->ssids[i].ssid, nla_data(attr),
 			       nla_len(attr));
-			request->ssids[i].ssid_len = nla_len(attr);
 			i++;
 		}
 	}
-- 
1.7.1

