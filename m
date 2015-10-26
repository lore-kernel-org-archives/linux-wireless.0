Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5807 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbbJZF4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 01:56:00 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Marty Faltesek <mfaltesek@google.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2] mwifiex: toggle carrier state in start_ap/stop_ap.
Date: Sun, 25 Oct 2015 22:54:01 -0700
Message-ID: <1445838841-20253-1-git-send-email-akarwar@marvell.com> (sfid-20151026_065608_281856_A42E8EC2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marty Faltesek <mfaltesek@google.com>

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
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Move only netdev queue status change code to start/stop AP
handlers. Discarded other changes in v1 which had side effects
(Avinash Patil)
---
 drivers/net/wireless/mwifiex/cfg80211.c  | 8 ++++++++
 drivers/net/wireless/mwifiex/uap_event.c | 7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b7ac45f..4073116 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1821,6 +1821,10 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		return -1;
 	}
 
+	if (netif_carrier_ok(priv->netdev))
+		netif_carrier_off(priv->netdev);
+	mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
+
 	return 0;
 }
 
@@ -1925,6 +1929,10 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	if (mwifiex_set_mgmt_ies(priv, &params->beacon))
 		return -1;
 
+	if (!netif_carrier_ok(priv->netdev))
+		netif_carrier_on(priv->netdev);
+	mwifiex_wake_up_net_dev_queue(priv->netdev, priv->adapter);
+
 	memcpy(&priv->bss_cfg, bss_cfg, sizeof(priv->bss_cfg));
 	kfree(bss_cfg);
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 078834c..86ff542 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -179,19 +179,12 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 	case EVENT_UAP_BSS_IDLE:
 		priv->media_connected = false;
 		priv->port_open = false;
-		if (netif_carrier_ok(priv->netdev))
-			netif_carrier_off(priv->netdev);
-		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
-
 		mwifiex_clean_txrx(priv);
 		mwifiex_del_all_sta_list(priv);
 		break;
 	case EVENT_UAP_BSS_ACTIVE:
 		priv->media_connected = true;
 		priv->port_open = true;
-		if (!netif_carrier_ok(priv->netdev))
-			netif_carrier_on(priv->netdev);
-		mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 		break;
 	case EVENT_UAP_BSS_START:
 		mwifiex_dbg(adapter, EVENT,
-- 
1.8.1.4

