Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58777 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934397Ab3DGWES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:04:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 6/7] ath9k: detect more kinds of invalid descriptors
Date: Mon,  8 Apr 2013 00:04:12 +0200
Message-Id: <1365372253-32782-6-git-send-email-nbd@openwrt.org> (sfid-20130408_000422_512800_0707C9C3)
In-Reply-To: <1365372253-32782-5-git-send-email-nbd@openwrt.org>
References: <1365372253-32782-1-git-send-email-nbd@openwrt.org>
 <1365372253-32782-2-git-send-email-nbd@openwrt.org>
 <1365372253-32782-3-git-send-email-nbd@openwrt.org>
 <1365372253-32782-4-git-send-email-nbd@openwrt.org>
 <1365372253-32782-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If AR_CRCErr, AR_PHYErr, AR_DecryptCRCErr or AR_MichaelErr is indicated
in the rx status word, but AR_RxFrameOK is also set, the descriptor
contents are typically invalid. This can show up as a warning about
invalid MCS rates in a frame. Even with those checks in place, a
descriptor with invalid MCS rates can still sometimes make it through to
the driver (mostly on older hardware like AR91xx).

Detect such errors in the last descriptor of a frame and discard the
whole frame if present.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c  | 8 ++++++++
 drivers/net/wireless/ath/ath9k/mac.h  | 1 +
 drivers/net/wireless/ath/ath9k/recv.c | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 811007e..498fee0 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -615,6 +615,14 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
+	} else {
+		if (ads.ds_rxstatus8 &
+		    (AR_CRCErr | AR_PHYErr | AR_DecryptCRCErr | AR_MichaelErr))
+			rs->rs_status |= ATH9K_RXERR_CORRUPT_DESC;
+
+		/* Only up to MCS16 supported, everything above is invalid */
+		if (rs->rs_rate >= 0x90)
+			rs->rs_status |= ATH9K_RXERR_CORRUPT_DESC;
 	}
 
 	if (ads.ds_rxstatus8 & AR_KeyMiss)
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 1ff8170..5865f92 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -183,6 +183,7 @@ struct ath_htc_rx_status {
 #define ATH9K_RXERR_DECRYPT       0x08
 #define ATH9K_RXERR_MIC           0x10
 #define ATH9K_RXERR_KEYMISS       0x20
+#define ATH9K_RXERR_CORRUPT_DESC  0x40
 
 #define ATH9K_RX_MORE             0x01
 #define ATH9K_RX_MORE_AGGR        0x02
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0c6dc28..703c82c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1312,6 +1312,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			sc->rx.frag = skb;
 			goto requeue;
 		}
+		if (rs.rs_status & ATH9K_RXERR_CORRUPT_DESC)
+			goto requeue_drop_frag;
 
 		if (sc->rx.frag) {
 			int space = skb->len - skb_tailroom(hdr_skb);
-- 
1.8.0.2

