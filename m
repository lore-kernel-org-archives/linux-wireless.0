Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36422 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbbJSStn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 14:49:43 -0400
Received: by qkca6 with SMTP id a6so13348759qkc.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 11:49:42 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Denton Gentry <dgentry@google.com>,
	Avery Pennarun <apenwarr@google.com>,
	Marty Faltesek <mfaltesek@google.com>
Subject: [PATCH] mwifiex: toggle carrier state in start_ap/stop_ap.
Date: Mon, 19 Oct 2015 14:49:10 -0400
Message-Id: <1445280550-13673-1-git-send-email-mfaltesek@google.com> (sfid-20151019_204946_729089_A5D7AD78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In uap mode the carrier is not enabled until after the first STA joins.
The carrier triggers the bridge to start its state machine, and if STP
is enabled, it takes 4 seconds as it transitions from disabled to
forwarding. During this time the bridge drops all traffic, and the EAPOL
handshake times out after 3 seconds, preventing stations from joining.

Follow the logic used in mac80211 and start the carrier in start_ap
and disable it in stop_ap. This has a nice benefit of allowing the
first station connection time to be reduced by up to 75% when STP is
in use.

Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  | 12 ++++++++++++
 drivers/net/wireless/mwifiex/uap_event.c | 11 -----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 495621f..275ce3c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1765,6 +1765,13 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		return -1;
 	}
 
+	priv->media_connected = false;
+	if (netif_carrier_ok(priv->netdev))
+		netif_carrier_off(priv->netdev);
+	mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
+	mwifiex_clean_txrx(priv);
+	mwifiex_del_all_sta_list(priv);
+
 	return 0;
 }
 
@@ -1863,6 +1870,11 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	if (mwifiex_set_mgmt_ies(priv, &params->beacon))
 		return -1;
 
+	priv->media_connected = true;
+	if (!netif_carrier_ok(priv->netdev))
+		netif_carrier_on(priv->netdev);
+	mwifiex_wake_up_net_dev_queue(priv->netdev, priv->adapter);
+
 	memcpy(&priv->bss_cfg, bss_cfg, sizeof(priv->bss_cfg));
 	kfree(bss_cfg);
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index f4794cd..c5bb6ee 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -113,19 +113,8 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		mwifiex_del_sta_entry(priv, deauth_mac);
 		break;
 	case EVENT_UAP_BSS_IDLE:
-		priv->media_connected = false;
-		if (netif_carrier_ok(priv->netdev))
-			netif_carrier_off(priv->netdev);
-		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
-
-		mwifiex_clean_txrx(priv);
-		mwifiex_del_all_sta_list(priv);
 		break;
 	case EVENT_UAP_BSS_ACTIVE:
-		priv->media_connected = true;
-		if (!netif_carrier_ok(priv->netdev))
-			netif_carrier_on(priv->netdev);
-		mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 		break;
 	case EVENT_UAP_BSS_START:
 		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
-- 
2.6.0.rc2.230.g3dd15c0

