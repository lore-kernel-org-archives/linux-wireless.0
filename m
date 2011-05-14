Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53452 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab1ENAmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 20:42:43 -0400
Received: by fxm17 with SMTP id 17so2085806fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 17:42:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] carl9170: advertise interface combinations
Date: Sat, 14 May 2011 02:42:38 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <201105140035.06559.chunkeey@googlemail.com> <201105140139.34401.chunkeey@googlemail.com> <1305330515.680.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1305330515.680.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201105140242.38763.chunkeey@googlemail.com> (sfid-20110514_024248_220651_6D2B2DE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to provide multiple interfaces for a single device,
the driver will be required to advertise all possible
interface configurations to the stack.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
v1 -> v2
	fix commit log - currently there's no restriction, yet!
	drop IBSS from the combination lists

iw now says this:
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * P2P-client
                 * P2P-GO
        software interface modes (can always be added):
                 * AP/VLAN
                 * monitor
        valid interface combinations:
                 * #{ managed, AP, P2P-client, P2P-GO } <= 2,
                   total <= 2, #channels <= 1

[mesh can be added at any time, question is: will it make sense... in fact, does
it make sense to have multiple STAs/P2P-client either, think of
DFS & TSF sync problems 11.1.1.1?]
---
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 71d6d07..dbce999 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -287,6 +287,10 @@ struct ar9170 {
 		unsigned int tx_seq_table;
 	} fw;
 
+	/* interface configuration combinations */
+	struct ieee80211_iface_limit if_comb_limits[1];
+	struct ieee80211_iface_combination if_combs[1];
+
 	/* reset / stuck frames/queue detection */
 	struct work_struct restart_work;
 	struct work_struct ping_work;
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 9517ede..221957c 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -151,6 +151,7 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 	const struct carl9170fw_chk_desc *chk_desc;
 	const struct carl9170fw_last_desc *last_desc;
 	const struct carl9170fw_txsq_desc *txsq_desc;
+	u16 if_comb_types;
 
 	last_desc = carl9170_fw_find_desc(ar, LAST_MAGIC,
 		sizeof(*last_desc), CARL9170FW_LAST_DESC_CUR_VER);
@@ -268,6 +269,9 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 	if (SUPP(CARL9170FW_WOL))
 		device_set_wakeup_enable(&ar->udev->dev, true);
 
+	if_comb_types = BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_P2P_CLIENT);
+
 	ar->fw.vif_num = otus_desc->vif_num;
 	ar->fw.cmd_bufs = otus_desc->cmd_bufs;
 	ar->fw.address = le32_to_cpu(otus_desc->fw_address);
@@ -294,12 +298,25 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
 
 		if (SUPP(CARL9170FW_WLANTX_CAB)) {
-			ar->hw->wiphy->interface_modes |=
+			if_comb_types |=
 				BIT(NL80211_IFTYPE_AP) |
 				BIT(NL80211_IFTYPE_P2P_GO);
 		}
 	}
 
+	ar->if_comb_limits[0].max = ar->fw.vif_num;
+	ar->if_comb_limits[0].types = if_comb_types;
+
+	ar->if_combs[0].num_different_channels = 1;
+	ar->if_combs[0].max_interfaces = ar->fw.vif_num;
+	ar->if_combs[0].limits = ar->if_comb_limits;
+	ar->if_combs[0].n_limits = ARRAY_SIZE(ar->if_comb_limits);
+
+	ar->hw->wiphy->iface_combinations = ar->if_combs;
+	ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ar->if_combs);
+
+	ar->hw->wiphy->interface_modes |= if_comb_types;
+
 	txsq_desc = carl9170_fw_find_desc(ar, TXSQ_MAGIC,
 		sizeof(*txsq_desc), CARL9170FW_TXSQ_DESC_CUR_VER);
 
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index a975f5d..c45ce42 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1674,14 +1674,8 @@ void *carl9170_alloc(size_t priv_size)
 	INIT_LIST_HEAD(&ar->vif_list);
 	init_completion(&ar->tx_flush);
 
-	/*
-	 * Note:
-	 * IBSS/ADHOC and AP mode are only enabled, if the firmware
-	 * supports these modes. The code which will add the
-	 * additional interface_modes is in fw.c.
-	 */
-	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				     BIT(NL80211_IFTYPE_P2P_CLIENT);
+	/* firmware decides which modes we support */
+	hw->wiphy->interface_modes = 0;
 
 	hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS |
