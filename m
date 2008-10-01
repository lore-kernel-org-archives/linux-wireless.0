Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50408 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYJACXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 22:23:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/5] wireless: remove NETWORK_EMPTY_ESSID flag
Date: Tue, 30 Sep 2008 22:15:49 -0400
Message-Id: <1222827352-1978-3-git-send-email-linville@tuxdriver.com> (sfid-20081001_042403_290743_C3AFA639)
In-Reply-To: <1222827352-1978-2-git-send-email-linville@tuxdriver.com>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-2-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is unnecessary and of questionable value.  Also remove
is_empty_ssid, as it is also unnecessary.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2200.c |   23 +----------------------
 include/net/ieee80211.h        |    1 -
 include/net/lib80211.h         |   16 ----------------
 net/ieee80211/ieee80211_rx.c   |   15 ++-------------
 net/ieee80211/ieee80211_wx.c   |   12 +++---------
 net/wireless/lib80211.c        |    5 -----
 6 files changed, 6 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 41f9e46..e6f77dd 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -5443,16 +5443,6 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 		return 0;
 	}
 
-	/* If we do not have an ESSID for this AP, we can not associate with
-	 * it */
-	if (network->flags & NETWORK_EMPTY_ESSID) {
-		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
-				"because of hidden ESSID.\n",
-				escape_ssid(network->ssid, network->ssid_len),
-				print_mac(mac, network->bssid));
-		return 0;
-	}
-
 	if (unlikely(roaming)) {
 		/* If we are roaming, then ensure check if this is a valid
 		 * network to try and roam to */
@@ -5658,16 +5648,6 @@ static int ipw_best_network(struct ipw_priv *priv,
 		return 0;
 	}
 
-	/* If we do not have an ESSID for this AP, we can not associate with
-	 * it */
-	if (network->flags & NETWORK_EMPTY_ESSID) {
-		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
-				"because of hidden ESSID.\n",
-				escape_ssid(network->ssid, network->ssid_len),
-				print_mac(mac, network->bssid));
-		return 0;
-	}
-
 	if (unlikely(roaming)) {
 		/* If we are roaming, then ensure check if this is a valid
 		 * network to try and roam to */
@@ -6892,8 +6872,7 @@ static int ipw_qos_handle_probe_response(struct ipw_priv *priv,
 	if ((priv->status & STATUS_ASSOCIATED) &&
 	    (priv->ieee->iw_mode == IW_MODE_ADHOC) && (active_network == 0)) {
 		if (memcmp(network->bssid, priv->bssid, ETH_ALEN))
-			if ((network->capability & WLAN_CAPABILITY_IBSS) &&
-			    !(network->flags & NETWORK_EMPTY_ESSID))
+			if (network->capability & WLAN_CAPABILITY_IBSS)
 				if ((network->ssid_len ==
 				     priv->assoc_network->ssid_len) &&
 				    !memcmp(network->ssid,
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index c638239..7b0a505 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -729,7 +729,6 @@ struct ieee80211_txb {
 
 #define MAX_WPA_IE_LEN 64
 
-#define NETWORK_EMPTY_ESSID    (1<<0)
 #define NETWORK_HAS_OFDM       (1<<1)
 #define NETWORK_HAS_CCK        (1<<2)
 
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index 91a64f3..ce49a30 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -12,20 +12,4 @@
  * messages. It should never be used for passing ssid to user space. */
 const char *escape_ssid(const char *ssid, u8 ssid_len);
 
-static inline int is_empty_ssid(const char *ssid, int ssid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (ssid_len == 1 && ssid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire ssid is 0, we assume it is hidden */
-	while (ssid_len) {
-		ssid_len--;
-		if (ssid[ssid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
 #endif /* LIB80211_H */
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index 34239db..15c65da 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -1167,12 +1167,6 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 
 		switch (info_element->id) {
 		case MFIE_TYPE_SSID:
-			if (is_empty_ssid(info_element->data,
-					  info_element->len)) {
-				network->flags |= NETWORK_EMPTY_ESSID;
-				break;
-			}
-
 			network->ssid_len = min(info_element->len,
 						(u8) IW_ESSID_MAX_SIZE);
 			memcpy(network->ssid, info_element->data,
@@ -1182,7 +1176,8 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 				       IW_ESSID_MAX_SIZE - network->ssid_len);
 
 			IEEE80211_DEBUG_MGMT("MFIE_TYPE_SSID: '%s' len=%d.\n",
-					     network->ssid, network->ssid_len);
+					     escape_ssid(network->ssid),
+					     network->ssid_len);
 			break;
 
 		case MFIE_TYPE_RATES:
@@ -1412,9 +1407,6 @@ static int ieee80211_handle_assoc_resp(struct ieee80211_device *ieee, struct iee
 			network->mode |= IEEE_B;
 	}
 
-	if (is_empty_ssid(network->ssid, network->ssid_len))
-		network->flags |= NETWORK_EMPTY_ESSID;
-
 	memcpy(&network->stats, stats, sizeof(network->stats));
 
 	if (ieee->handle_assoc_response != NULL)
@@ -1486,9 +1478,6 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 		return 1;
 	}
 
-	if (is_empty_ssid(network->ssid, network->ssid_len))
-		network->flags |= NETWORK_EMPTY_ESSID;
-
 	memcpy(&network->stats, stats, sizeof(network->stats));
 
 	return 0;
diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index c338279..db79e6c 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -65,15 +65,9 @@ static char *ieee80211_translate_scan(struct ieee80211_device *ieee,
 	/* Add the ESSID */
 	iwe.cmd = SIOCGIWESSID;
 	iwe.u.data.flags = 1;
-	if (network->flags & NETWORK_EMPTY_ESSID) {
-		iwe.u.data.length = sizeof("<hidden>");
-		start = iwe_stream_add_point(info, start, stop,
-					     &iwe, "<hidden>");
-	} else {
-		iwe.u.data.length = min(network->ssid_len, (u8) 32);
-		start = iwe_stream_add_point(info, start, stop,
-					     &iwe, network->ssid);
-	}
+	iwe.u.data.length = min(network->ssid_len, (u8) 32);
+	start = iwe_stream_add_point(info, start, stop,
+				     &iwe, network->ssid);
 
 	/* Add the protocol name */
 	iwe.cmd = SIOCGIWNAME;
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index b22d271..872cc8d 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -24,11 +24,6 @@ const char *escape_ssid(const char *ssid, u8 ssid_len)
 	const char *s = ssid;
 	char *d = escaped;
 
-	if (is_empty_ssid(ssid, ssid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
 	ssid_len = min_t(u8, ssid_len, IEEE80211_MAX_SSID_LEN);
 	while (ssid_len--) {
 		if (*s == '\0') {
-- 
1.5.4.3

