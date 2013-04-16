Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56798 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab3DPKwU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 06:52:20 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/2] ath9k: always set common->macaddr to the MAC adress of a virtual interface
Date: Tue, 16 Apr 2013 12:51:57 +0200
Message-Id: <1366109517-64645-2-git-send-email-nbd@openwrt.org> (sfid-20130416_125224_866185_80C078F3)
In-Reply-To: <1366109517-64645-1-git-send-email-nbd@openwrt.org>
References: <1366109517-64645-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases it can be useful to change the MAC address of a virtual
interface to something that's completely different from the EEPROM
stored MAC address. In this case it is a bad idea to use the EEPROM MAC
address for calculating the BSSID mask, as that would make it too wide.

In one case a few devices have been observed to send ACKs for many
packets on the channel not directed at them, which results in a neat
Denial of Service attack on the channel.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 7 +++----
 drivers/net/wireless/ath/ath9k/main.c  | 9 +++++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 86d3572..1915f12 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -658,11 +658,10 @@ enum sc_op_flags {
 struct ath_rate_table;
 
 struct ath9k_vif_iter_data {
-	const u8 *hw_macaddr; /* phy's hardware address, set
-			       * before starting iteration for
-			       * valid bssid mask.
-			       */
+	u8 hw_macaddr[ETH_ALEN]; /* address of the first vif */
 	u8 mask[ETH_ALEN]; /* bssid mask */
+	bool has_hw_macaddr;
+
 	int naps;      /* number of AP vifs */
 	int nmeshes;   /* number of mesh vifs */
 	int nstations; /* number of station vifs */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a383483..6963862 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -839,10 +839,14 @@ static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath9k_vif_iter_data *iter_data = data;
 	int i;
 
-	if (iter_data->hw_macaddr)
+	if (iter_data->has_hw_macaddr) {
 		for (i = 0; i < ETH_ALEN; i++)
 			iter_data->mask[i] &=
 				~(iter_data->hw_macaddr[i] ^ mac[i]);
+	} else {
+		memcpy(iter_data->hw_macaddr, mac, ETH_ALEN);
+		iter_data->has_hw_macaddr = true;
+	}
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
@@ -891,7 +895,6 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 	 * together with the BSSID mask when matching addresses.
 	 */
 	memset(iter_data, 0, sizeof(*iter_data));
-	iter_data->hw_macaddr = common->macaddr;
 	memset(&iter_data->mask, 0xff, ETH_ALEN);
 
 	if (vif)
@@ -901,6 +904,8 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 	ieee80211_iterate_active_interfaces_atomic(
 		sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 		ath9k_vif_iter, iter_data);
+
+	memcpy(common->macaddr, iter_data->hw_macaddr, ETH_ALEN);
 }
 
 /* Called with sc->mutex held. */
-- 
1.8.0.2

