Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51110 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3ARXkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 18:40:33 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so1965059eek.10
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2013 15:40:32 -0800 (PST)
Subject: [RFC] iwl4965: report A-MPDU status
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 19 Jan 2013 00:30:11 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201301190030.11771.chunkeey@googlemail.com> (sfid-20130119_004037_956066_34B3CA0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the firmware will give us an A-MPDU bit and
only a single PHY information packet for all the
subframes in an A-MPDU, we can easily report the
minimal A-MPDU information for radiotap.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Just two things.

1. This patch [including commit msg] is a copy of:
   commit 12bf6f45d17038589e0eaa8adeb7ee8169c0e4de
   Author: Johannes Berg <johannes.berg@intel.com>
   Date:   Thu Jul 5 13:05:08 2012 +0200
      iwlwifi: report A-MPDU status

2. RX_RES_PHY_FLAGS_ANTENNA_MSK
   I had the chance to test this with a real 4965.
   As far as I can tell, the hardware has just 3
   antenna connectors. But I have seen frames, which
   apparently have been received on 4 antennas?!

   Note: iwlwifi had this problem as well. It was
   fixed by:
     commit 362b0563b28506d534a82d9c6cd5fdf58783fda6
     Author: Johannes Berg <johannes.berg@intel.com>
     Date:   Fri Aug 24 11:13:17 2012 +0200
        iwlwifi: fix antenna bitmask
   I suppose 4965 also uses the 4th bit as the AMPDU
   indicator. It would be very helpful if someone
   could confirm this assumption. [Otherwise the
   whole AMPDU status feature patch has little use].

(BTW: wireshark 1.9.0+ already supports the AMPDU_DETAILS
radiotap extension.)

Regards

Christian
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   12 ++++++++++++
 drivers/net/wireless/iwlegacy/commands.h |    3 ++-
 drivers/net/wireless/iwlegacy/common.h   |    1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 10fc249..cb64126 100644
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
@@ -736,6 +747,7 @@ il4965_hdl_rx_phy(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	il->_4965.last_phy_res_valid = true;
+	il->_4965.ampdu_ref++;
 	memcpy(&il->_4965.last_phy_res, pkt->u.raw,
 	       sizeof(struct il_rx_phy_res));
 }
diff --git a/drivers/net/wireless/iwlegacy/commands.h b/drivers/net/wireless/iwlegacy/commands.h
index 25dd7d2..3b6c994 100644
--- a/drivers/net/wireless/iwlegacy/commands.h
+++ b/drivers/net/wireless/iwlegacy/commands.h
@@ -1134,8 +1134,9 @@ struct il_wep_cmd {
 #define RX_RES_PHY_FLAGS_MOD_CCK_MSK		cpu_to_le16(1 << 1)
 #define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
 #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
-#define RX_RES_PHY_FLAGS_ANTENNA_MSK		0xf0
+#define RX_RES_PHY_FLAGS_ANTENNA_MSK		0x70
 #define RX_RES_PHY_FLAGS_ANTENNA_POS		4
+#define RX_RES_PHY_FLAGS_AGG_MSK		cpu_to_le16(1 << 7)
 
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

