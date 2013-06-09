Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25298 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3FIGNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 02:13:25 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/6] wil6210: Send EAPOL frames using normal Tx queue
Date: Sun, 9 Jun 2013 09:12:54 +0300
Message-ID: <1370758375-16867-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130609_081328_743878_EA2D6FC0)
In-Reply-To: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No more need for special processing of EAPOL, FW can now send EAPOL frames
using normal Tx queue for TID 0

This fixes "schedule while atomic" bug - start_xmit called in softirq context;
while WMI mechanism that was used may sleep.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c    | 20 ++++++++----------
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 -
 drivers/net/wireless/ath/wil6210/wmi.c     | 34 ------------------------------
 3 files changed, 9 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 00dffed..e1c492b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -768,18 +768,16 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		wil_err(wil, "Xmit in monitor mode not supported\n");
 		goto drop;
 	}
-	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
-		rc = wmi_tx_eapol(wil, skb);
-	} else {
-		/* find vring */
-		vring = wil_find_tx_vring(wil, skb);
-		if (!vring) {
-			wil_err(wil, "No Tx VRING available\n");
-			goto drop;
-		}
-		/* set up vring entry */
-		rc = wil_tx_vring(wil, vring, skb);
+
+	/* find vring */
+	vring = wil_find_tx_vring(wil, skb);
+	if (!vring) {
+		wil_err(wil, "No Tx VRING available\n");
+		goto drop;
 	}
+	/* set up vring entry */
+	rc = wil_tx_vring(wil, vring, skb);
+
 	switch (rc) {
 	case 0:
 		/* statistics will be updated on the tx_complete */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 373cf65..44fdab5 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -329,7 +329,6 @@ int wmi_set_ssid(struct wil6210_priv *wil, u8 ssid_len, const void *ssid);
 int wmi_get_ssid(struct wil6210_priv *wil, u8 *ssid_len, void *ssid);
 int wmi_set_channel(struct wil6210_priv *wil, int channel);
 int wmi_get_channel(struct wil6210_priv *wil, int *channel);
-int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb);
 int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
 		       const void *mac_addr);
 int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index ac4d26b..dc8059a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -839,40 +839,6 @@ int wmi_p2p_cfg(struct wil6210_priv *wil, int channel)
 	return wmi_send(wil, WMI_P2P_CFG_CMDID, &cmd, sizeof(cmd));
 }
 
-int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb)
-{
-	struct wmi_eapol_tx_cmd *cmd;
-	struct ethhdr *eth;
-	u16 eapol_len = skb->len - ETH_HLEN;
-	void *eapol = skb->data + ETH_HLEN;
-	uint i;
-	int rc;
-
-	skb_set_mac_header(skb, 0);
-	eth = eth_hdr(skb);
-	wil_dbg_wmi(wil, "EAPOL %d bytes to %pM\n", eapol_len, eth->h_dest);
-	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
-		if (memcmp(wil->dst_addr[i], eth->h_dest, ETH_ALEN) == 0)
-			goto found_dest;
-	}
-
-	return -EINVAL;
-
- found_dest:
-	/* find out eapol data & len */
-	cmd = kzalloc(sizeof(*cmd) + eapol_len, GFP_KERNEL);
-	if (!cmd)
-		return -EINVAL;
-
-	memcpy(cmd->dst_mac, eth->h_dest, ETH_ALEN);
-	cmd->eapol_len = cpu_to_le16(eapol_len);
-	memcpy(cmd->eapol, eapol, eapol_len);
-	rc = wmi_send(wil, WMI_EAPOL_TX_CMDID, cmd, sizeof(*cmd) + eapol_len);
-	kfree(cmd);
-
-	return rc;
-}
-
 int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
 		       const void *mac_addr)
 {
-- 
1.8.1.2

