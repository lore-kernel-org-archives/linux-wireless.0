Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46982 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727597AbeIEJev (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 05:34:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Sep 2018 08:06:14 +0300
Message-Id: <20180905050614.23273-10-luca@coelho.fi> (sfid-20180905_070635_679617_6AB82F9F)
In-Reply-To: <20180905050614.23273-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180905050614.23273-1-luca@coelho.fi>
Subject: [RESEND PATCH v2 9/9] mac80211: Don't wake up from PS for offchannel TX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Otherwise the offchannel frame might be queued due to
IEEE80211_QUEUE_STOP_REASON_PS and later dropped (in
ieee80211_tx_frags()).  Anyway, it doesn't make much sense to wake up
the device during ROC.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1c9ef0755bc0..7e8730c55ec9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -214,6 +214,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_if_managed *ifmgd;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 
 	/* driver doesn't support power save */
 	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS))
@@ -242,6 +243,9 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	if (tx->sdata->vif.type != NL80211_IFTYPE_STATION)
 		return TX_CONTINUE;
 
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_OFFCHAN_TX_OK))
+		return TX_CONTINUE;
+
 	ifmgd = &tx->sdata->u.mgd;
 
 	/*
-- 
2.18.0
