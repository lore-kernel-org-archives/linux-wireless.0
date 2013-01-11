Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64823 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3AKTdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 14:33:25 -0500
Received: by mail-bk0-f53.google.com with SMTP id j5so1130414bkw.26
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2013 11:33:24 -0800 (PST)
Subject: [RFC] ath9k: report A-MPDU status
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>, senthilb@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, Adrian Chadd <adrian@freebsd.org>
Date: Fri, 11 Jan 2013 20:33:18 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201301112033.19437.chunkeey@googlemail.com> (sfid-20130111_203329_596845_B7471BCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k hardware reports whenever an frame was part
of an A-MPDU. MAC80211 already provides the necessary
API to pass this additional information along to
whomever needs it.

---
Knowing whenever a received frame was part of an A-MPDU
allows mac80211 to react to A-MPDUs which have no valid
BA agreement in place.

This patch (together with the mac80211 part in:
<http://www.spinics.net/lists/linux-wireless/msg101717.html>)
helps to improve network stability. The new code implements
parts of the recommendations from 802.11-2012 10.5.4
"Error recovery upon a peer failure".

While this patch works OK, I think it still needs be
improved further:
 - ath9k_apply_ampdu_details is a separate subroutine
   and it is called a bit 'late'. However, I'm not 
   sure if moving it to a different place like 
		ath9k_rx_skb_preprocess
   would be any better. it's because we need to have
   access to ampdu_ref, which is currently stored in
   ath_softc.rx.

 - What about the MPDU delimiter crc?
   Is it possible to retrieve it from the rx header,
   or is it lost?

 - (How to handle zero length subframes?
   This would be a nice to have feature [i.e.: if
   someone wants to check if a HT peer really
   cares about the ampdu density]. However it
   should be disabled unless we have a running
   monitor interface.)

BTW: Support for the AMPDU_DETAILS radiotap 
extension has already been added to wireshark.
Just make sure you get the latest svn/git
source (1.9.0).

Regards,
	Chr
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath/ath9k/recv.c  |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 094a932..262fb71 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -320,6 +320,8 @@ struct ath_rx {
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
 	struct sk_buff *frag;
+
+	u32 ampdu_ref;
 };
 
 int ath_startrecv(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 45f2d47..775cafd 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1128,6 +1128,24 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 #endif
 }
 
+static void ath9k_apply_ampdu_details(struct ath_softc *sc,
+	struct ath_rx_status *rs, struct ieee80211_rx_status *rxs)
+{
+	if (rs->rs_isaggr) {
+		rxs->flag |= RX_FLAG_AMPDU_DETAILS | RX_FLAG_AMPDU_LAST_KNOWN;
+
+		rxs->ampdu_reference = sc->rx.ampdu_ref;
+
+		if (!rs->rs_moreaggr) {
+			rxs->flag |= RX_FLAG_AMPDU_IS_LAST;
+			sc->rx.ampdu_ref++;
+		}
+
+		if (rs->rs_flags & ATH9K_RX_DELIM_CRC_PRE)
+			rxs->flag |= RX_FLAG_AMPDU_DELIM_CRC_ERROR;
+	}
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
@@ -1343,6 +1362,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx == 3)
 			ath_ant_comb_scan(sc, &rs);
 
+		ath9k_apply_ampdu_details(sc, &rs, rxs);
+
 		ieee80211_rx(hw, skb);
 
 requeue_drop_frag:
-- 
1.7.10.4

