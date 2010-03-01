Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:46774 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751192Ab0CAL7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 06:59:08 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0293864744
	for <linux-wireless@vger.kernel.org>; Mon,  1 Mar 2010 20:59:07 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 1/5] ath5k: fix injection in monitor mode
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 01 Mar 2010 20:59:03 +0900
Message-ID: <20100301115903.13996.95024.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

injected frames have to use AR5K_PKT_TYPE_NORMAL, otherwise the hardware thinks
it can mess with the contents of the frame - e.g. update the TSF of an injected
beacon. injected frames should be sent as they are provided.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 drivers/net/wireless/ath/ath5k/base.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 2468c64..904d7f0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1285,6 +1285,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	u16 cts_rate = 0;
 	u16 duration = 0;
 	u8 rc_flags;
+	enum ath5k_pkt_type pkt_type;
 
 	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
 
@@ -1322,9 +1323,17 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
 			sc->vif, pktlen, info));
 	}
+
+	/* we don't want the hardware to mess with injected frames in monitor
+	 * mode (e.g. update TSF in beacons) */
+	if (sc->opmode == NL80211_IFTYPE_MONITOR)
+		pkt_type = AR5K_PKT_TYPE_NORMAL;
+	else
+		pkt_type = get_hw_packet_type(skb);
+
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb),
-		get_hw_packet_type(skb),
+		pkt_type,
 		(sc->power_level * 2),
 		hw_rate,
 		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,

