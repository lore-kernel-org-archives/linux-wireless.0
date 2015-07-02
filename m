Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12347 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239AbbGBNJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 09:09:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t62D4UTH028555
	for <linux-wireless@vger.kernel.org>; Thu, 2 Jul 2015 06:09:05 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1vbggrqgaq-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 06:09:05 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix for p2p broken link
Date: Thu, 2 Jul 2015 06:07:02 -0700
Message-ID: <1435842422-15608-1-git-send-email-akarwar@marvell.com> (sfid-20150702_150917_796180_51548D9C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aniket Nagarnaik <aniketn@marvell.com>

This patch fixes following issues in p2p code paths.

1) bss role, bss type and connection type was not set correctly
for p2p GO and p2p client at couple of places.
2) Driver appends a proprietary header to management frames
which will be parsed by our firmware. Later while informing
TX status to cfg80211, modified frame buffer was passed to
cfg80211_mgmt_tx_status() instead of original one.

Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  5 ++++-
 drivers/net/wireless/mwifiex/sta_cmd.c  |  6 ++++--
 drivers/net/wireless/mwifiex/txrx.c     | 22 +++++++++++++++++++++-
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 93e40d0..3cac40d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -831,10 +831,13 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
-	case NL80211_IFTYPE_P2P_GO:
 		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
 		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
+	case NL80211_IFTYPE_P2P_GO:
+		priv->bss_role =  MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
+		break;
 	case NL80211_IFTYPE_AP:
 		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 36cb6bd..a49a80d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1997,10 +1997,12 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		if (priv->bss_mode == NL80211_IFTYPE_ADHOC)
 			cmd_ptr->params.bss_mode.con_type =
 				CONNECTION_TYPE_ADHOC;
-		else if (priv->bss_mode == NL80211_IFTYPE_STATION)
+		else if (priv->bss_mode == NL80211_IFTYPE_STATION ||
+			 priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT)
 			cmd_ptr->params.bss_mode.con_type =
 				CONNECTION_TYPE_INFRA;
-		else if (priv->bss_mode == NL80211_IFTYPE_AP)
+		else if (priv->bss_mode == NL80211_IFTYPE_AP ||
+			 priv->bss_mode == NL80211_IFTYPE_P2P_GO)
 			cmd_ptr->params.bss_mode.con_type = CONNECTION_TYPE_AP;
 		cmd_ptr->size = cpu_to_le16(sizeof(struct
 				host_cmd_ds_set_bss_mode) + S_DS_GEN);
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 5ed9b79..8b1e5b5 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -370,8 +370,28 @@ void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 			/* consumes ack_skb */
 			skb_complete_wifi_ack(ack_skb, !tx_status->status);
 		} else {
+			/* Remove broadcast address which was added by driver */
+			memmove(ack_skb->data +
+				sizeof(struct ieee80211_hdr_3addr) +
+				MWIFIEX_MGMT_FRAME_HEADER_SIZE + sizeof(u16),
+				ack_skb->data +
+				sizeof(struct ieee80211_hdr_3addr) +
+				MWIFIEX_MGMT_FRAME_HEADER_SIZE + sizeof(u16) +
+				ETH_ALEN, ack_skb->len -
+				(sizeof(struct ieee80211_hdr_3addr) +
+				MWIFIEX_MGMT_FRAME_HEADER_SIZE + sizeof(u16) +
+				ETH_ALEN));
+			ack_skb->len = ack_skb->len - ETH_ALEN;
+			/* Remove driver's proprietary header including 2 bytes
+			 * of packet length and pass actual management frame buffer
+			 * to cfg80211.
+			 */
 			cfg80211_mgmt_tx_status(&priv->wdev, tx_info->cookie,
-						ack_skb->data, ack_skb->len,
+						ack_skb->data +
+						MWIFIEX_MGMT_FRAME_HEADER_SIZE +
+						sizeof(u16), ack_skb->len -
+						(MWIFIEX_MGMT_FRAME_HEADER_SIZE
+						 + sizeof(u16)),
 						!tx_status->status, GFP_ATOMIC);
 			dev_kfree_skb_any(ack_skb);
 		}
-- 
1.8.1.4

