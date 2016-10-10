Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:41068 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752715AbcJJQwp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 12:52:45 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [PATCH] mac80211: fix A-MSDU outer SA/DA
Date: Mon, 10 Oct 2016 18:52:40 +0200
Message-Id: <1476118360-29009-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161010_185248_820348_E0F2CCD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE 802.11-2012 section 8.3.2 table 8-19, the outer SA/DA
of A-MSDU frames need to be changed depending on FromDS/ToDS values.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/tx.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5023966..acd334c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3050,7 +3050,7 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	int hdr_len = fast_tx->hdr_len - sizeof(rfc1042_header);
 	int subframe_len = skb->len - hdr_len;
 	void *data;
-	u8 *qc;
+	u8 *qc, *bssid;
 
 	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 		return false;
@@ -3062,10 +3062,32 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 					 &subframe_len))
 		return false;
 
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		bssid = sdata->u.mgd.bssid;
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		bssid = sdata->vif.addr;
+		break;
+	default:
+		bssid = NULL;
+	}
+
 	amsdu_hdr.h_proto = cpu_to_be16(subframe_len);
 	memcpy(amsdu_hdr.h_source, skb->data + fast_tx->sa_offs, ETH_ALEN);
 	memcpy(amsdu_hdr.h_dest, skb->data + fast_tx->da_offs, ETH_ALEN);
 
+	/* according to IEEE 802.11-2012 8.3.2 table 8-19, the outer SA/DA
+	 * fields needs to be changed to BSSID for A-MSDU frames depending
+	 * on FromDS/ToDS values.
+	 */
+	hdr = data;
+	if (bssid && ieee80211_has_fromds(hdr->frame_control))
+		memcpy(amsdu_hdr.h_source, bssid, ETH_ALEN);
+	if (bssid && ieee80211_has_tods(hdr->frame_control))
+		memcpy(amsdu_hdr.h_dest, bssid, ETH_ALEN);
+
 	data = skb_push(skb, sizeof(amsdu_hdr));
 	memmove(data, data + sizeof(amsdu_hdr), hdr_len);
 	memcpy(data + hdr_len, &amsdu_hdr, sizeof(amsdu_hdr));
-- 
2.1.4
