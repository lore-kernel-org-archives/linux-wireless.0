Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58275 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFMVk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 17:40:26 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so1568866wiv.14
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2014 14:40:25 -0700 (PDT)
Message-ID: <539B6FC6.8000803@gmail.com> (sfid-20140613_234031_465454_42D56A91)
Date: Fri, 13 Jun 2014 23:40:22 +0200
From: Mathy Vanhoef <vanhoefm@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ath5k-devel@lists.ath5k.org
Subject: [PATCH 1/2] ath5k: support for FIF_FCSFAIL filter
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Currently ath5k can't report frames with CRC errors. In ath5k_configure_filter
it actually sets the hardware filter properly when the FIF_FCSFAIL flag is set.
However, in other functions the necessary checks weren't being done.

This patch fixes that.
--
From: "Mathy Vanhoef" <vanhoefm@gmail.com>

When the FIF_FCSFAIL filter flag is set, pass frames with CRC errors.

Signed-off-by: Mathy Vanhoef <vanhoefm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |  1 +
 drivers/net/wireless/ath/ath5k/base.c         | 16 ++++++++++++++--
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |  2 ++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index d03e4dd..1054f19 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1285,6 +1285,7 @@ struct ath5k_hw {
 #define ATH_STAT_STARTED	3		/* opened & irqs enabled */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
+	unsigned int		fif_filter_flags; /* Current FIF_* filter flags */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
 
 	u16			nvifs;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e9aed98..39ba642 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1382,6 +1382,9 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 	rxs->flag = 0;
 	if (unlikely(rs->rs_status & AR5K_RXERR_MIC))
 		rxs->flag |= RX_FLAG_MMIC_ERROR;
+	if (unlikely(rs->rs_status & AR5K_RXERR_CRC))
+		rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
+
 
 	/*
 	 * always extend the mac timestamp, since this information is
@@ -1449,6 +1452,8 @@ ath5k_receive_frame_ok(struct ath5k_hw *ah, struct ath5k_rx_status *rs)
 	ah->stats.rx_bytes_count += rs->rs_datalen;
 
 	if (unlikely(rs->rs_status)) {
+		unsigned int filters;
+
 		if (rs->rs_status & AR5K_RXERR_CRC)
 			ah->stats.rxerr_crc++;
 		if (rs->rs_status & AR5K_RXERR_FIFO)
@@ -1480,8 +1485,15 @@ ath5k_receive_frame_ok(struct ath5k_hw *ah, struct ath5k_rx_status *rs)
 			return true;
 		}
 
-		/* reject any frames with non-crypto errors */
-		if (rs->rs_status & ~(AR5K_RXERR_DECRYPT))
+		/*
+		 * Reject any frames with non-crypto errors, and take into account the
+		 * current FIF_* filters.
+		 */
+		filters = AR5K_RXERR_DECRYPT;
+		if (ah->fif_filter_flags & FIF_FCSFAIL)
+			filters |= AR5K_RXERR_CRC;
+
+		if (rs->rs_status & ~filters)
 			return false;
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index afb23b3..b65c38f 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -473,6 +473,8 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	/* Set the cached hw filter flags, this will later actually
 	 * be set in HW */
 	ah->filter_flags = rfilt;
+	/* Store current FIF filter flags */
+	ah->fif_filter_flags = *new_flags;
 
 	mutex_unlock(&ah->lock);
 }
-- 
1.8.1.2

