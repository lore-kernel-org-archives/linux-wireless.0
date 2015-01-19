Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59581 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbbASNNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 08:13:39 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so15489599wiv.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 05:13:33 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix nullfunc workaround
Date: Mon, 19 Jan 2015 14:12:57 +0100
Message-Id: <1421673177-2245-1-git-send-email-michal.kazior@tieto.com> (sfid-20150119_141343_030936_2948DC52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The workaround couldn't work correctly because the
802.11 header wasn't properly stripped of QoS Data
bit so it wasn't recognized in the later parts of
tx path as NullFunc frame and ended up in HTT Tx
instead of HTT Mgmt Tx.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9524bc5..82c567d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2145,6 +2145,7 @@ static void ath10k_tx_h_nwifi(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * used only for CQM purposes (e.g. hostapd station keepalive ping) so
 	 * it is safe to downgrade to NullFunc.
 	 */
+	hdr = (void *)skb->data;
 	if (ieee80211_is_qos_nullfunc(hdr->frame_control)) {
 		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		cb->htt.tid = HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
-- 
1.8.5.3

