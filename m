Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56025 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977Ab3HHIIb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 04:08:31 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 2/3] ath10k: clean up HTT tx tid handling
Date: Thu, 8 Aug 2013 10:08:17 +0200
Message-ID: <1375949298-7159-3-git-send-email-michal.kazior@tieto.com> (sfid-20130808_100842_382226_CB2504BE)
In-Reply-To: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tids weren't mapped really properly. This
doesn't fix any known bug but seems the right
thing to do.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h |    6 ++++--
 drivers/net/wireless/ath/ath10k/mac.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 318be46..de45d02 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -106,8 +106,10 @@ enum htt_data_tx_desc_flags1 {
 };
 
 enum htt_data_tx_ext_tid {
-	HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST = 16,
-	HTT_DATA_TX_EXT_TID_MGMT                = 17,
+	HTT_DATA_TX_EXT_TID_NON_QOS_UNICAST     = 16,
+	HTT_DATA_TX_EXT_TID_UNUSED              = 17,
+	HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST = 18,
+	HTT_DATA_TX_EXT_TID_MGMT                = 19,
 	HTT_DATA_TX_EXT_TID_INVALID             = 31
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cf2ba4d..fb1f24f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1726,12 +1726,14 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	/* we must calculate tid before we apply qos workaround
 	 * as we'd lose the qos control field */
-	tid = HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
 	if (ieee80211_is_data_qos(hdr->frame_control) &&
 	    is_unicast_ether_addr(ieee80211_get_DA(hdr))) {
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-	}
+	} else if (is_unicast_ether_addr(ieee80211_get_DA(hdr)))
+		tid = HTT_DATA_TX_EXT_TID_NON_QOS_UNICAST;
+	else
+		tid = HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
 
 	/* it makes no sense to process injected frames like that */
 	if (info->control.vif &&
-- 
1.7.9.5

