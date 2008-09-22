Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbYIVOKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 10:10:15 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1] mac80211: fix led behavior in IBSS
Date: Mon, 22 Sep 2008 17:10:10 +0300
Message-Id: <1222092610-25374-1-git-send-email-tomas.winkler@intel.com> (sfid-20080922_161021_132282_6A58AABD)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes the led behavior in IBSS. After we joined an IBSS cell we
need to inform the led that we got associated. Although there is no 802.11
association in IBSS mode, the semantic of "There is a link" is relevant.
This allows the led to blink in IBSS mode (at least this solves a bug for
iwlwifi).

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2e55208..2bae226 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1483,6 +1483,8 @@ static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	ifsta->state = IEEE80211_STA_MLME_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
+	ieee80211_led_assoc(local, true);
+
 	memset(&wrqu, 0, sizeof(wrqu));
 	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
 	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

