Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:46295 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaAXWsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:48:43 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <simon@open-mesh.com>
Subject: [PATCH] mac80211: send ibss probe responses with noack flag
Date: Fri, 24 Jan 2014 23:48:29 +0100
Message-Id: <1390603709-8041-1-git-send-email-sw@simonwunderlich.de> (sfid-20140124_234846_895744_E7A8105C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <simon@open-mesh.com>

Responding to probe requests for scanning clients will often create
excessive rtries, as it happens quite often that the scanning client
already left the channel. Therefore do it like hostapd and send probe
responses for broadcast SSID only once by using the noack flag.

Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
---
 net/mac80211/ibss.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ed7eec3..e22eb95 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1465,6 +1465,11 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	memcpy(((struct ieee80211_mgmt *) skb->data)->da, mgmt->sa, ETH_ALEN);
 	ibss_dbg(sdata, "Sending ProbeResp to %pM\n", mgmt->sa);
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+
+	/* avoid excessive retries for probe request to wildcard SSIDs */
+	if (pos[1] == 0)
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_NO_ACK;
+
 	ieee80211_tx_skb(sdata, skb);
 }
 
-- 
1.7.10.4

