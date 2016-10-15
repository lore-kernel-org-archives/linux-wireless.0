Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:50663 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753574AbcJOL22 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Oct 2016 07:28:28 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Felix Fietkau <nbd@openwrt.org>
Subject: [PATCHv5 2/2] mac80211: fix A-MSDU outer SA/DA
Date: Sat, 15 Oct 2016 13:28:19 +0200
Message-Id: <1476530899-24241-2-git-send-email-michael-dev@fami-braun.de> (sfid-20161015_132832_793403_14FB6470)
In-Reply-To: <1476530899-24241-1-git-send-email-michael-dev@fami-braun.de>
References: <1476530899-24241-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE 802.11-2012 section 8.3.2 table 8-19, the outer SA/DA
of A-MSDU frames need to be changed depending on FromDS/ToDS values.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

--
v5:
 - single out amsdu_hdr to ptr conversion before
v4:
 - h_80211_src/dst has been memmove'd and thus needs to be fixed
v3:
 - write to outer 802.11 header instead of inner amsdu subframe header
v2:
 - avoid the extra write to amsdu_hdr
 - avoid copy of asmdu_hdr into skb, use ptr instead
---
 net/mac80211/tx.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 56a883b..7fcd4b6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3051,6 +3051,7 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	int subframe_len = skb->len - hdr_len;
 	void *data;
 	u8 *qc, *h_80211_src, *h_80211_dst;
+	const u8 *bssid;
 
 	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 		return false;
@@ -3074,6 +3075,28 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	ether_addr_copy(amsdu_hdr->h_source, h_80211_src);
 	ether_addr_copy(amsdu_hdr->h_dest, h_80211_dst);
 
+	/* according to IEEE 802.11-2012 8.3.2 table 8-19, the outer SA/DA
+	 * fields needs to be changed to BSSID for A-MSDU frames depending
+	 * on FromDS/ToDS values.
+	 */
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
+	if (bssid && ieee80211_has_fromds(hdr->frame_control))
+		memcpy(h_80211_src, bssid, ETH_ALEN);
+
+	if (bssid && ieee80211_has_tods(hdr->frame_control))
+		memcpy(h_80211_dst, bssid, ETH_ALEN);
+
 	qc = ieee80211_get_qos_ctl(hdr);
 	*qc |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
-- 
2.1.4
