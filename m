Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:35100 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbYEEQfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 12:35:04 -0400
Received: by ug-out-1314.google.com with SMTP id h2so95220ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 09:35:03 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC] mac80211: Don't encrypt beacons
Date: Mon, 5 May 2008 18:41:51 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805051841.51408.IvDoorn@gmail.com> (sfid-20080505_183426_433521_B121C9C6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

This patch is intended to for your experimental patch:
	019-mac80211-tx-info-skb-cb.patch

Beacons shouldn't be encryped, so mac80211 should set
the IEEE80211_TX_CTL_DO_NOT_ENCRYPT flag in tx info flags.
Otherwise the driver will cause a NULL pointer dereference
when it tries to access the info->control.hw_key which isn't
configured.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a359b9a..3b3592f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1856,6 +1856,7 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 		info->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
 	info->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 	info->flags |= IEEE80211_TX_CTL_NO_ACK;
+	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
 	info->control.retry_limit = 1;
 	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	(*num_beacons)++;
