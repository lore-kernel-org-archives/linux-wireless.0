Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31597 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089AbbFAMeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 08:34:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t51CSiQk017094
	for <linux-wireless@vger.kernel.org>; Mon, 1 Jun 2015 05:34:01 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1upunhwk5n-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 05:34:01 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv4 13/17] mwifiex: drop block-ack action frames
Date: Mon, 1 Jun 2015 23:32:11 +0530
Message-ID: <1433181735-15712-14-git-send-email-patila@marvell.com> (sfid-20150601_150351_236189_4FAA0151)
In-Reply-To: <1433181735-15712-1-git-send-email-patila@marvell.com>
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We often see ADDBA request packets coming to driver because driver
has registered for action frame subtype. We dont process BA action
frames in host; drop such frames.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Xinmin Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/util.c | 43 +++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 2e3dc07..790e619 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -329,7 +329,7 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 			  struct rxpd *rx_pd)
 {
 	u16 stype;
-	u8 category, action_code;
+	u8 category, action_code, *addr2;
 	struct ieee80211_hdr *ieee_hdr = (void *)payload;
 
 	stype = (le16_to_cpu(ieee_hdr->frame_control) & IEEE80211_FCTL_STYPE);
@@ -337,21 +337,35 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 	switch (stype) {
 	case IEEE80211_STYPE_ACTION:
 		category = *(payload + sizeof(struct ieee80211_hdr));
-		action_code = *(payload + sizeof(struct ieee80211_hdr) + 1);
-		if (category == WLAN_CATEGORY_PUBLIC &&
-		    action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
+		switch (category) {
+		case WLAN_CATEGORY_PUBLIC:
+			action_code = *(payload + sizeof(struct ieee80211_hdr)
+					+ 1);
+			if (action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
+				addr2 = ieee_hdr->addr2;
+				mwifiex_dbg(priv->adapter, INFO,
+					    "TDLS discovery response %pM nf=%d, snr=%d\n",
+					    addr2, rx_pd->nf, rx_pd->snr);
+				mwifiex_auto_tdls_update_peer_signal(priv,
+								     addr2,
+								     rx_pd->snr,
+								     rx_pd->nf);
+			}
+			break;
+		case WLAN_CATEGORY_BACK:
+			/*we dont indicate BACK action frames to cfg80211*/
+			mwifiex_dbg(priv->adapter, INFO,
+				    "drop BACK action frames");
+			return -1;
+		default:
 			mwifiex_dbg(priv->adapter, INFO,
-				    "TDLS discovery response %pM nf=%d, snr=%d\n",
-				    ieee_hdr->addr2, rx_pd->nf, rx_pd->snr);
-			mwifiex_auto_tdls_update_peer_signal(priv,
-							     ieee_hdr->addr2,
-							     rx_pd->snr,
-							     rx_pd->nf);
+				    "unknown public action frame category %d\n",
+				    category);
 		}
-		break;
 	default:
 		mwifiex_dbg(priv->adapter, INFO,
-			    "unknown mgmt frame subtype %#x\n", stype);
+		    "unknown mgmt frame subtype %#x\n", stype);
+		return 0;
 	}
 
 	return 0;
@@ -387,8 +401,9 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 
 	ieee_hdr = (void *)skb->data;
 	if (ieee80211_is_mgmt(ieee_hdr->frame_control)) {
-		mwifiex_parse_mgmt_packet(priv, (u8 *)ieee_hdr,
-					  pkt_len, rx_pd);
+		if (mwifiex_parse_mgmt_packet(priv, (u8 *)ieee_hdr,
+					      pkt_len, rx_pd))
+			return -1;
 	}
 	/* Remove address4 */
 	memmove(skb->data + sizeof(struct ieee80211_hdr_3addr),
-- 
1.8.1.4

