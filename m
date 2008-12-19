Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20360 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYLSNMj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 08:12:39 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 05:12:39 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <Jouni.Malinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP as pairwise cipher
Date: Fri, 19 Dec 2008 18:40:35 +0530
Message-ID: <1229692235-21734-1-git-send-email-vasanth@atheros.com> (sfid-20081219_141244_167603_2DBD43AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE802.11n does not allow TKIP/WEP as pairwise cipher in HT mode.
Connect in non-ht mode if either of these ciphers is cofigured as
pairwise.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    9 ++++++++-
 net/mac80211/wext.c        |    5 ++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a7dabae..5d78d2e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -314,6 +314,7 @@ struct ieee80211_if_sta {
 	unsigned int auth_algs; /* bitfield of allowed auth algs */
 	int auth_alg; /* currently used IEEE 802.11 authentication algorithm */
 	int auth_transaction;
+	u32 ucast_cipher;
 
 	unsigned long ibss_join_req;
 	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 829cdf8..8a8c48c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -391,10 +391,17 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* wmm support is a must to HT */
+	/*
+	 * IEEE802.11n does not allow TKIP/WEP as pairwise
+	 * ciphers in HT mode. Connect in non-ht mode if any
+	 * one of these ciphers is configured as pairwise.
+	 */
 	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
 	    sband->ht_cap.ht_supported &&
 	    (ht_ie = ieee80211_bss_get_ie(bss, WLAN_EID_HT_INFORMATION)) &&
-	    ht_ie[1] >= sizeof(struct ieee80211_ht_info)) {
+	    ht_ie[1] >= sizeof(struct ieee80211_ht_info) &&
+	    (ifsta->ucast_cipher & (IW_AUTH_CIPHER_NONE |
+	    IW_AUTH_CIPHER_CCMP))) {
 		struct ieee80211_ht_info *ht_info =
 			(struct ieee80211_ht_info *)(ht_ie + 2);
 		u16 cap = sband->ht_cap.cap;
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 1542804..385b322 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -873,12 +873,15 @@ static int ieee80211_ioctl_siwauth(struct net_device *dev,
 
 	switch (data->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
-	case IW_AUTH_CIPHER_PAIRWISE:
 	case IW_AUTH_CIPHER_GROUP:
 	case IW_AUTH_WPA_ENABLED:
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 	case IW_AUTH_KEY_MGMT:
 		break;
+	case IW_AUTH_CIPHER_PAIRWISE:
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			sdata->u.sta.ucast_cipher = data->value;
+		break;
 	case IW_AUTH_DROP_UNENCRYPTED:
 		sdata->drop_unencrypted = !!data->value;
 		break;
-- 
1.5.5.1

