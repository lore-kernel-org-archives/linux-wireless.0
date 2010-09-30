Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50348 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab0I3VjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 17:39:21 -0400
Received: by qwh6 with SMTP id 6so1050490qwh.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 14:39:20 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 17:39:20 -0400
Message-ID: <AANLkTi=CySU4wUoiexZggp9jXco=UMt=Etkm4wp9nAL9@mail.gmail.com>
Subject: [PATCH] mac80211: fix for WDS interfaces
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Splitting previous patch as requested.

This patch initializes the rate table for a WDS interface, and
adds tests to allow WDS packets to pass the xmit and receive
tests.

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 net/mac80211/iface.c |    3 +++
 net/mac80211/main.c  |    3 +++
 net/mac80211/rx.c    |    1 +
 net/mac80211/tx.c    |    3 +++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6678573..1e91984 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -24,6 +24,7 @@
 #include "led.h"
 #include "driver-ops.h"
 #include "wme.h"
+#include "rate.h"

 /**
  * DOC: Interface list locking
@@ -301,6 +302,8 @@ static int ieee80211_do_open(struct net_device
*dev, bool coming_up)
 			/* STA has been freed */
 			goto err_del_interface;
 		}
+
+		rate_control_rate_init(sta);
 	}

 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e24fa5b..4ea88dd 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -201,6 +201,8 @@ void ieee80211_bss_info_change_notify(struct
ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
+	else if (sdata->vif.type == NL80211_IFTYPE_WDS)
+		sdata->vif.bss_conf.bssid = NULL;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		sdata->vif.bss_conf.bssid = zero;
 	} else {
@@ -211,6 +213,7 @@ void ieee80211_bss_info_change_notify(struct
ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MESH_POINT:
 		break;
 	default:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0b0e83e..b3e161f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -819,6 +819,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	if (unlikely((ieee80211_is_data(hdr->frame_control) ||
 		      ieee80211_is_pspoll(hdr->frame_control)) &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
 		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
 		if ((!ieee80211_has_fromds(hdr->frame_control) &&
 		     !ieee80211_has_tods(hdr->frame_control) &&
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e1733dc..258fbdb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -273,6 +273,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		 */
 		return TX_DROP;

+	if (tx->sdata->vif.type == NL80211_IFTYPE_WDS)
+		return TX_CONTINUE;
+
 	if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 		return TX_CONTINUE;

-- 
1.7.2.3
