Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751966AbdFLHpI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 03:45:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 12 Jun 2017 10:44:58 +0300
Message-Id: <20170612074458.8897-1-luca@coelho.fi> (sfid-20170612_094512_184014_BD33E03B)
Subject: [PATCH] mac80211: Fix incorrect condition when checking rx timestamp
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

If the driver reports the rx timestamp at PLCP start, mac80211 can
only handle legacy encoding, but the code checks that the encoding
is not legacy. Fix this.

Fixes: da6a4352e7c8 ("mac80211: separate encoding/bandwidth from flags")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 392fbab73c04..2197c62a0a6e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1523,7 +1523,7 @@ ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
 		return true;
 	/* can't handle non-legacy preamble yet */
 	if (status->flag & RX_FLAG_MACTIME_PLCP_START &&
-	    status->encoding != RX_ENC_LEGACY)
+	    status->encoding == RX_ENC_LEGACY)
 		return true;
 	return false;
 }
-- 
2.11.0
