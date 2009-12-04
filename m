Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44593 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000AbZLDRKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 12:10:41 -0500
Date: Fri, 4 Dec 2009 19:10:34 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Check all local addresses for TX Ack status
Message-ID: <20091204171034.GA16505@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since mac80211_hwsim supports multiple virtual interfaces, we need to
iterate through all active interfaces when figuring out whether there
is a match during TX Ack status checking. This fixes TX status
reporting for cases where secondary interfaces are used.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/mac80211_hwsim.c |   35 ++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

--- uml.orig/drivers/net/wireless/mac80211_hwsim.c	2009-12-04 18:29:52.000000000 +0200
+++ uml/drivers/net/wireless/mac80211_hwsim.c	2009-12-04 18:48:32.000000000 +0200
@@ -482,6 +482,38 @@ static bool hwsim_ps_rx_ok(struct mac802
 }
 
 
+struct mac80211_hwsim_addr_match_data {
+	bool ret;
+	const u8 *addr;
+};
+
+static void mac80211_hwsim_addr_iter(void *data, u8 *mac,
+				     struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_addr_match_data *md = data;
+	if (memcmp(mac, md->addr, ETH_ALEN) == 0)
+		md->ret = true;
+}
+
+
+static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
+				      const u8 *addr)
+{
+	struct mac80211_hwsim_addr_match_data md;
+
+	if (memcmp(addr, data->hw->wiphy->perm_addr, ETH_ALEN) == 0)
+		return true;
+
+	md.ret = false;
+	md.addr = addr;
+	ieee80211_iterate_active_interfaces_atomic(data->hw,
+						   mac80211_hwsim_addr_iter,
+						   &md);
+
+	return md.ret;
+}
+
+
 static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 				    struct sk_buff *skb)
 {
@@ -534,8 +566,7 @@ static bool mac80211_hwsim_tx_frame(stru
 		if (nskb == NULL)
 			continue;
 
-		if (memcmp(hdr->addr1, data2->hw->wiphy->perm_addr,
-			   ETH_ALEN) == 0)
+		if (mac80211_hwsim_addr_match(data2, hdr->addr1))
 			ack = true;
 		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
 		ieee80211_rx_irqsafe(data2->hw, nskb);

-- 
Jouni Malinen                                            PGP id EFC895FA
