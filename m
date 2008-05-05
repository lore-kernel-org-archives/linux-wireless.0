Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:31214 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762435AbYEESds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 14:33:48 -0400
Received: by fg-out-1718.google.com with SMTP id 19so205101fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 11:33:46 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH] mac80211: Don't encrypt beacons
Date: Mon, 5 May 2008 20:40:35 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805052040.35511.IvDoorn@gmail.com> (sfid-20080505_203342_174815_2E534843)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 should set the IEEE80211_TX_CTL_DO_NOT_ENCRYPT flag in tx_control
structure to inform drivers not to encrypt the beacon. Drivers that only check
for that flag before accessing the hw_key field, will otherwise cause a NULL
pointer dereference since that field is not configured for beacons.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f35eaea..28d8bd5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1898,6 +1898,7 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 			control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
+		control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 		control->retry_limit = 1;
 		control->flags |= IEEE80211_TXCTL_CLEAR_PS_FILT;
 	}
