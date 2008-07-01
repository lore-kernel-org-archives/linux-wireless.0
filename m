Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:1927 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYGAIlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 04:41:25 -0400
Received: by nf-out-0910.google.com with SMTP id d3so557532nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 01:41:23 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Don't request encryption for proble response
Date: Tue, 1 Jul 2008 10:45:13 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807011045.13870.IvDoorn@gmail.com> (sfid-20080701_104129_232583_452DD447)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Probe responses shouldn't be encrypted, and mac80211 doesn't
set the crypto key accordingly. However it didn't set the
IEEE80211_TX_CTL_DO_NOT_ENCRYPT flag which means drivers
could make an attempt to encrypt it, and causing a NULL
pointer dereference when accessing the provided hw_key field.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7b4d4d4..fd28cd8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2531,6 +2531,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 			control->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control->flags |= IEEE80211_TX_CTL_NO_ACK;
+		control->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
 		control->control.retry_limit = 1;
 
 		ifsta->probe_resp = skb_copy(skb, GFP_ATOMIC);
