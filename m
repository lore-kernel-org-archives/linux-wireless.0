Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5071 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932468AbaKMKzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 05:55:42 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 5/6] mwifiex: support for parsing TDLS discovery frames
Date: Thu, 13 Nov 2014 21:54:17 +0530
Message-ID: <1415895858-4007-6-git-send-email-patila@marvell.com> (sfid-20141113_115544_976754_FE8075EB)
In-Reply-To: <1415895858-4007-1-git-send-email-patila@marvell.com>
References: <1415895858-4007-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for parsing TDLS discovery
frames. After parsing, we update peer RSSI information.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/util.c | 38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index ec79c49..a113ef8 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -141,6 +141,38 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int
+mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
+			  struct rxpd *rx_pd)
+{
+	u16 stype;
+	u8 category, action_code;
+	struct ieee80211_hdr *ieee_hdr = (void *)payload;
+
+	stype =  (cpu_to_le16(ieee_hdr->frame_control) & IEEE80211_FCTL_STYPE);
+
+	switch (stype) {
+	case IEEE80211_STYPE_ACTION:
+		category = *(payload + sizeof(struct ieee80211_hdr));
+		action_code = *(payload + sizeof(struct ieee80211_hdr) + 1);
+		if (category == WLAN_CATEGORY_PUBLIC &&
+		    action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
+			dev_dbg(priv->adapter->dev,
+				"TDLS discovery response %pM nf=%d, snr=%d\n",
+				ieee_hdr->addr2, rx_pd->nf, rx_pd->snr);
+			mwifiex_auto_tdls_update_peer_signal(priv,
+							     ieee_hdr->addr2,
+							     rx_pd->snr,
+							     rx_pd->nf);
+		}
+		break;
+	default:
+		dev_dbg(priv->adapter->dev,
+			"unknown mgmt frame subytpe %#x\n", stype);
+	}
+
+	return 0;
+}
 /*
  * This function processes the received management packet and send it
  * to the kernel.
@@ -151,6 +183,7 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 {
 	struct rxpd *rx_pd;
 	u16 pkt_len;
+	struct ieee80211_hdr *ieee_hdr;
 
 	if (!skb)
 		return -1;
@@ -162,6 +195,11 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 
 	pkt_len = le16_to_cpu(rx_pd->rx_pkt_length);
 
+	ieee_hdr = (void *)skb->data;
+	if (ieee80211_is_mgmt(ieee_hdr->frame_control)) {
+		mwifiex_parse_mgmt_packet(priv, (u8 *)ieee_hdr,
+					  pkt_len, rx_pd);
+	}
 	/* Remove address4 */
 	memmove(skb->data + sizeof(struct ieee80211_hdr_3addr),
 		skb->data + sizeof(struct ieee80211_hdr),
-- 
1.8.1.4

