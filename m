Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55368 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYKSK3z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 05:29:55 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 02:29:55 -0800
Date: Wed, 19 Nov 2008 16:03:23 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Look out for some other AP when disassoc is
	received.
Message-ID: <20081120000322.GA2828@myhost.users.atheros.com> (sfid-20081119_113000_488824_99355D56)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a disassoc packet is received with a reason code of 'AP leaving the BSS',
mac80211 should start looking for some other AP instead of trying to
associate with the same AP.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/mlme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6d5ed9c..8d0f995 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -855,7 +855,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_sta_send_apinfo(sdata, ifsta);
 
-	if (self_disconnected)
+	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT)
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 
 	sta_info_unlink(&sta);
@@ -1174,7 +1174,7 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, false, false, 0);
+	ieee80211_set_disassoc(sdata, ifsta, false, false, reason_code);
 }
 
 
-- 
1.6.0.1

