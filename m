Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:33175 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2HZPex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 11:34:53 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 2/2] mac80211: reply to AUTH frame with a DEAUTH if sta allocation fails
Date: Sun, 26 Aug 2012 17:34:33 +0200
Message-Id: <1345995273-27358-2-git-send-email-ordex@autistici.org> (sfid-20120826_173546_502474_97D999A4)
In-Reply-To: <1345995273-27358-1-git-send-email-ordex@autistici.org>
References: <1345995273-27358-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever a host gets an AUTH frame it first allocates a new station and then
replies with another AUTH frame. However, if sta allocations fails the host
should send a DEAUTH frame instead to tell the other end that something went
wrong

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/mac80211/ibss.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a9d9328..7c08251 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -332,11 +332,27 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	return ieee80211_ibss_finish_sta(sta, auth);
 }
 
+static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
+					  struct ieee80211_mgmt *mgmt,
+					  size_t len)
+{
+	u16 reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+
+	if (len < IEEE80211_DEAUTH_FRAME_LEN)
+		return;
+
+	ibss_dbg(sdata, "RX DeAuth SA=%pM DA=%pM BSSID=%pM (reason: %d)\n",
+		 mgmt->sa, mgmt->da, mgmt->bssid, reason);
+	sta_info_destroy_addr(sdata, mgmt->sa);
+}
+
 static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_mgmt *mgmt,
 					size_t len)
 {
 	u16 auth_alg, auth_transaction;
+	struct sta_info *sta;
+	u8 deauth_frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -352,10 +368,22 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 		 "RX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=%d)\n",
 		 mgmt->sa, mgmt->da, mgmt->bssid, auth_transaction);
 	sta_info_destroy_addr(sdata, mgmt->sa);
-	ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
+	sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
 	rcu_read_unlock();
 
 	/*
+	 * if we have any problem in allocating the new station, we reply with a
+	 * DEAUTH frame to tell the other end that we had a problem
+	 */
+	if (!sta) {
+		ieee80211_send_deauth_disassoc(sdata, sdata->u.ibss.bssid,
+					       IEEE80211_STYPE_DEAUTH,
+					       WLAN_REASON_UNSPECIFIED, true,
+					       deauth_frame_buf);
+		return;
+	}
+
+	/*
 	 * IEEE 802.11 standard does not require authentication in IBSS
 	 * networks and most implementations do not seem to use it.
 	 * However, try to reply to authentication attempts if someone
@@ -902,6 +930,9 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_STYPE_AUTH:
 		ieee80211_rx_mgmt_auth_ibss(sdata, mgmt, skb->len);
 		break;
+	case IEEE80211_STYPE_DEAUTH:
+		ieee80211_rx_mgmt_deauth_ibss(sdata, mgmt, skb->len);
+		break;
 	}
 
  mgmt_out:
-- 
1.7.12

