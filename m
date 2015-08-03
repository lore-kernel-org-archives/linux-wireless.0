Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33433 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbHCJQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 05:16:14 -0400
Received: by lbbyj8 with SMTP id yj8so74261146lbb.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 02:16:13 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: reject 11b tx fragmentation configuration
Date: Mon,  3 Aug 2015 11:16:43 +0200
Message-Id: <1438593403-316-2-git-send-email-michal.kazior@tieto.com> (sfid-20150803_111621_162367_1C1C87DF)
In-Reply-To: <1438593403-316-1-git-send-email-michal.kazior@tieto.com>
References: <1438593403-316-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even though there's a WMI enum for fragmentation
threshold no known firmware actually implements
it. Moreover it is not possible to rely frame
fragmentation to mac80211 because firmware clears
the "more fragments" bit in frame control making
it impossible for remote devices to reassemble
frames.

Hence implement a dummy callback just to say
fragmentation isn't supported. This effectively
prevents mac80211 from doing frame fragmentation
in software.

This fixes Tx becoming broken after setting
fragmentation threshold.

Fixes: 1010ba4c5d1c ("ath10k: unregister and remove frag_threshold callback")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    This somewhat depends on:
      http://thread.gmane.org/gmane.linux.kernel.wireless.general/140549
    
    Without the above user will not know that the callback failed.

 drivers/net/wireless/ath/ath10k/mac.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 879af9c3bd4a..e0bbb6c543c7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5563,6 +5563,21 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return ret;
 }
 
+static int ath10k_mac_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	/* Even though there's a WMI enum for fragmentation threshold no known
+	 * firmware actually implements it. Moreover it is not possible to rely
+	 * frame fragmentation to mac80211 because firmware clears the "more
+	 * fragments" bit in frame control making it impossible for remote
+	 * devices to reassemble frames.
+	 *
+	 * Hence implement a dummy callback just to say fragmentation isn't
+	 * supported. This effectively prevents mac80211 from doing frame
+	 * fragmentation in software.
+	 */
+	return -EOPNOTSUPP;
+}
+
 static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 u32 queues, bool drop)
 {
@@ -6405,6 +6420,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.remain_on_channel		= ath10k_remain_on_channel,
 	.cancel_remain_on_channel	= ath10k_cancel_remain_on_channel,
 	.set_rts_threshold		= ath10k_set_rts_threshold,
+	.set_frag_threshold		= ath10k_mac_op_set_frag_threshold,
 	.flush				= ath10k_flush,
 	.tx_last_beacon			= ath10k_tx_last_beacon,
 	.set_antenna			= ath10k_set_antenna,
-- 
2.1.4

