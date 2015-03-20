Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43161 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbbCTPY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 11:24:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: drop 4-addr VLAN frames earlier if not connected
Date: Fri, 20 Mar 2015 16:24:22 +0100
Message-Id: <1426865064-17707-3-git-send-email-johannes@sipsolutions.net> (sfid-20150320_162436_357911_FFEE28CD)
In-Reply-To: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net>
References: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there's no station on the 4-addr VLAN interface, then frames
cannot be transmitted. Drop such frames earlier, before setting
up all the information for them.

We should keep the old check though since that code might be used
for other internally-generated frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dcf60ee38b93..1d6344679bf1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1842,6 +1842,9 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			wme_sta = sta->sta.wme;
 			have_station = true;
+		} else if (sdata->wdev.use_4addr) {
+			ret = -ENOLINK;
+			goto free;
 		}
 		ap_sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
 					u.ap);
-- 
2.1.4

