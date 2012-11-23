Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:58488 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab2KWKvG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 05:51:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id 8E7E88B757E
	for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2012 11:50:55 +0100 (CET)
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [RFC 1/1] ath9k: Add radiotap vendor specific data example
Date: Fri, 23 Nov 2012 11:46:05 +0100
Message-Id: <1353667565-4212-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20121123_115242_843402_5FE9C369)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As an exmaple of vendor specific data we can extract rssi
and evm values for all the chains so one can see them on
per packet basis. More can be added depending on the needs i.e.
noise floor, Ness, STBC, key miss, etc.
AtheorsC OUI is used in this example but it should be replaced
by own when in use.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6aafbb7..02c36c4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1246,6 +1246,39 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx == 3)
 			ath_ant_comb_scan(sc, &rs);
 
+#if 0
+		/*TODO: Replace oui and vendor sub namespace with valid data
+		 * and add/remove fields below
+		 */
+		if( skb_headroom(skb) >  22 ) {
+			int8_t* vendor_data;
+
+			vendor_data = skb_push(skb, 22);
+
+			rxs->vendor_radiotap_len = 22;
+			rxs->vendor_radiotap_align = 4;
+			rxs->vendor_radiotap_oui[0] = 0x0;
+			rxs->vendor_radiotap_oui[1] = 0x3;
+			rxs->vendor_radiotap_oui[2] = 0x7f;
+			rxs->vendor_radiotap_subns = 0;
+			rxs->vendor_radiotap_bitmap = 0x00000001;
+
+			/* count bytes below and put it as the length*/
+			*vendor_data++ = rs.rs_rssi;
+			*vendor_data++ = rs.rs_rssi_ctl0;
+			*vendor_data++ = rs.rs_rssi_ctl1;
+			*vendor_data++ = rs.rs_rssi_ctl2;
+			put_unaligned_le32(rs.evm0, vendor_data);
+			vendor_data += 4;
+			put_unaligned_le32(rs.evm1, vendor_data);
+			vendor_data += 4;
+			put_unaligned_le32(rs.evm2, vendor_data);
+			vendor_data += 4;
+			put_unaligned_le32(rs.evm3, vendor_data);
+			vendor_data += 4;
+			put_unaligned_le16(rs.evm4, vendor_data);
+		}
+#endif
 		ieee80211_rx(hw, skb);
 
 requeue_drop_frag:
-- 
1.7.10.4

