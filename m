Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50661 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3AZVgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 16:36:44 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so755243eek.29
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2013 13:36:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 18 Jan 2013 23:47:19 +0100
Subject: [PATCH 2/2] iwl4965: report A-MPDU status
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, John Linville <linville@tuxdriver.com>
Message-Id: <E1TzDQV-0001Fa-Sp@debian64.localnet> (sfid-20130126_223654_767976_F5E367D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is based on "iwlwifi: report A-MPDU status".
(12bf6f45d1703858)

Since the firmware will give us an A-MPDU bit and
only a single PHY information packet for all the
subframes in an A-MPDU, we can easily report the
minimal A-MPDU information for radiotap.

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   11 +++++++++++
 drivers/net/wireless/iwlegacy/commands.h |    1 +
 drivers/net/wireless/iwlegacy/common.h   |    1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index f1dc040..2afc548 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -725,6 +725,16 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status.flag |= RX_FLAG_SHORT_GI;
 
+	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_AGG_MSK) {
+		/* We know which subframes of an A-MPDU belong
+		 * together since we get a single PHY response
+		 * from the firmware for all of them.
+		 */
+
+		rx_status.flag |= RX_FLAG_AMPDU_DETAILS;
+		rx_status.ampdu_reference = il->_4965.ampdu_ref;
+	}
+
 	il4965_pass_packet_to_mac80211(il, header, len, ampdu_status, rxb,
 				       &rx_status);
 }
@@ -736,6 +746,7 @@ il4965_hdl_rx_phy(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	il->_4965.last_phy_res_valid = true;
+	il->_4965.ampdu_ref++;
 	memcpy(&il->_4965.last_phy_res, pkt->u.raw,
 	       sizeof(struct il_rx_phy_res));
 }
diff --git a/drivers/net/wireless/iwlegacy/commands.h b/drivers/net/wireless/iwlegacy/commands.h
index 829d3b9..3b6c994 100644
--- a/drivers/net/wireless/iwlegacy/commands.h
+++ b/drivers/net/wireless/iwlegacy/commands.h
@@ -1136,6 +1136,7 @@ struct il_wep_cmd {
 #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
 #define RX_RES_PHY_FLAGS_ANTENNA_MSK		0x70
 #define RX_RES_PHY_FLAGS_ANTENNA_POS		4
+#define RX_RES_PHY_FLAGS_AGG_MSK	cpu_to_le16(1 << 7)
 
 #define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
 #define RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 37fe553..96f2025 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1356,6 +1356,7 @@ struct il_priv {
 		struct {
 			struct il_rx_phy_res last_phy_res;
 			bool last_phy_res_valid;
+			u32 ampdu_ref;
 
 			struct completion firmware_loading_complete;
 
-- 
1.7.10.4

