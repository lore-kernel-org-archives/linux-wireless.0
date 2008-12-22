Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13309 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYLVGd6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 01:33:58 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2008 22:33:58 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <jouni.Malinen@atheros.com>,
	<linville@tuxdriver.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH] [RFC v2] mac80211: Scale down to non-HT association with TKIP/WEP as pairwise cipher
Date: Mon, 22 Dec 2008 12:01:37 +0530
Message-ID: <1229927497-30923-1-git-send-email-vasanth@atheros.com> (sfid-20081222_073402_551762_800BDF95)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As TKIP is not updated to new security needs which arise when
TKIP is used to encrypt A-MPDU aggregated data frames, IEEE802.11n
does not allow any cipher other than CCMP (Which has new extensions
defined) as pairwise cipher between HT peers.

When such configuration (TKIP/WEP in HT) is forced, we still
associate in non-HT mode (11a/b/g).

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/iface.c       |    3 ++-
 net/mac80211/mlme.c        |    9 ++++++++-
 net/mac80211/wext.c        |   12 +++++++++++-
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a7dabae..dcc0d18 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -258,6 +258,7 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
 #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
 #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
+#define IEEE80211_STA_TKIP_WEP_USED	BIT(14)
 /* flags for MLME request */
 #define IEEE80211_STA_REQ_SCAN 0
 #define IEEE80211_STA_REQ_DIRECT_PROBE 1
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5abbc3f..19cfc0a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -459,7 +459,8 @@ static int ieee80211_stop(struct net_device *dev)
 		synchronize_rcu();
 		skb_queue_purge(&sdata->u.sta.skb_queue);
 
-		sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
+		sdata->u.sta.flags &= ~(IEEE80211_STA_PRIVACY_INVOKED |
+					IEEE80211_STA_TKIP_WEP_USED);
 		kfree(sdata->u.sta.extra_ie);
 		sdata->u.sta.extra_ie = NULL;
 		sdata->u.sta.extra_ie_len = 0;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 829cdf8..6f69eee 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -391,10 +391,17 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* wmm support is a must to HT */
+	/*
+	 * IEEE802.11n does not allow TKIP/WEP as pairwise
+	 * ciphers in HT mode. We still associate in non-ht
+	 * mode (11a/b/g) if any one of these ciphers is
+	 * configured as pairwise.
+	 */
 	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
 	    sband->ht_cap.ht_supported &&
 	    (ht_ie = ieee80211_bss_get_ie(bss, WLAN_EID_HT_INFORMATION)) &&
-	    ht_ie[1] >= sizeof(struct ieee80211_ht_info)) {
+	    ht_ie[1] >= sizeof(struct ieee80211_ht_info) &&
+	    (!(ifsta->flags & IEEE80211_STA_TKIP_WEP_USED))) {
 		struct ieee80211_ht_info *ht_info =
 			(struct ieee80211_ht_info *)(ht_ie + 2);
 		u16 cap = sband->ht_cap.cap;
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 1542804..ce089e7 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -873,12 +873,22 @@ static int ieee80211_ioctl_siwauth(struct net_device *dev,
 
 	switch (data->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
-	case IW_AUTH_CIPHER_PAIRWISE:
 	case IW_AUTH_CIPHER_GROUP:
 	case IW_AUTH_WPA_ENABLED:
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 	case IW_AUTH_KEY_MGMT:
 		break;
+	case IW_AUTH_CIPHER_PAIRWISE:
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			if (data->value & (IW_AUTH_CIPHER_WEP40 |
+			    IW_AUTH_CIPHER_WEP104 | IW_AUTH_CIPHER_TKIP))
+				sdata->u.sta.flags |=
+					IEEE80211_STA_TKIP_WEP_USED;
+			else
+				sdata->u.sta.flags &=
+					~IEEE80211_STA_TKIP_WEP_USED;
+		}
+		break;
 	case IW_AUTH_DROP_UNENCRYPTED:
 		sdata->drop_unencrypted = !!data->value;
 		break;
-- 
1.5.5.1

