Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32016 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYKUO2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 09:28:20 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 06:28:20 -0800
Date: Fri, 21 Nov 2008 20:01:48 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Look out for some other AP when disassoc is
	received.
Message-ID: <20081122040148.GA4201@myhost.users.atheros.com> (sfid-20081121_152824_360434_B8238486)
References: <20081120000322.GA2828@myhost.users.atheros.com> <1227095716.26243.20.camel@johannes.berg> <8e92b4100811190433l24ab5043nd4e14ff7c7124e20@mail.gmail.com> <1227186290.14852.8.camel@johannes.berg> <8e92b4100811210346r125519d0gb5a71108719e1768@mail.gmail.com> <1227268340.3766.112.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1227268340.3766.112.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vivek Natarajan <vnatarajan@atheros.com>
Date: Fri, 21 Nov 2008 11:15:19 +0530
Subject: [PATCH] mac80211: Look out for some other AP when disassoc is received.

When a disassoc packet is received with a reason code of
'AP leaving the BSS', mac80211 should start looking for some
other AP instead of trying to associate with the same AP.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/mlme.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 90ad5a4..ee15e75 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -808,6 +808,10 @@ static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
 
+/*
+ * The disassoc 'reason' argument can be either our own reason
+ * if self disconnected or a reason code from the AP.
+ */
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_if_sta *ifsta, bool deauth,
 				   bool self_disconnected, u16 reason)
@@ -854,7 +858,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_sta_send_apinfo(sdata, ifsta);
 
-	if (self_disconnected)
+	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT)
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 
 	sta_info_unlink(&sta);
@@ -1175,7 +1179,7 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, false, false, 0);
+	ieee80211_set_disassoc(sdata, ifsta, false, false, reason_code);
 }
 
 
-- 
1.5.6.4

