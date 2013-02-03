Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:43400 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3BCBDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 20:03:30 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so2187966dak.33
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2013 17:03:30 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/3] mac80211: generate mesh probe requests
Date: Sat,  2 Feb 2013 17:02:20 -0800
Message-Id: <1359853341-29237-3-git-send-email-thomas@cozybit.com> (sfid-20130203_020338_435702_B0005E3D)
In-Reply-To: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
References: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A mesh probe request must include the mesh ID IE and a
wildcard SSID IE. Add this and transpose the SSID scan
list into mesh IDs for mesh interfaces.

Also allow the user to specify a mesh ID IE in the user
scan IEs, since additional SSID IEs seem to be allowed.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/tx.c   |   15 +++++++++++----
 net/mac80211/util.c |    1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 01dc001..9f3e9ba 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2622,11 +2622,18 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 	memcpy(hdr->addr2, vif->addr, ETH_ALEN);
 	eth_broadcast_addr(hdr->addr3);
 
-	pos = skb_put(skb, ie_ssid_len);
-	*pos++ = WLAN_EID_SSID;
+	if (ieee80211_vif_is_mesh(vif)) {
+		pos = skb_put(skb, 2 + 2 + ssid_len);
+		*pos++ = WLAN_EID_SSID;
+		*pos++ = 0;
+		/* NOTE: mesh ID will be out of order */
+		*pos++ = WLAN_EID_MESH_ID;
+	} else {
+		pos = skb_put(skb, 2 + ssid_len);
+		*pos++ = WLAN_EID_SSID;
+	}
 	*pos++ = ssid_len;
-	if (ssid_len)
-		memcpy(pos, ssid, ssid_len);
+	memcpy(pos, ssid, ssid_len);
 	pos += ssid_len;
 
 	return skb;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 139ad9b..aeb0f88 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1181,6 +1181,7 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	if (ie && ie_len) {
 		static const u8 before_ht[] = {
 			WLAN_EID_SSID,
+			WLAN_EID_MESH_ID,
 			WLAN_EID_SUPP_RATES,
 			WLAN_EID_REQUEST,
 			WLAN_EID_EXT_SUPP_RATES,
-- 
1.7.10.4

