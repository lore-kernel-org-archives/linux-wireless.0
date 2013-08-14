Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:50461 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab3HNNat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 09:30:49 -0400
Received: by mail-la0-f48.google.com with SMTP id er20so439792lab.21
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 06:30:46 -0700 (PDT)
From: Johan Almbladh <ja@anyfi.net>
To: johannes@sipsolutions.net
Cc: ordex@autistici.org, linux-wireless@vger.kernel.org,
	Johan Almbladh <ja@anyfi.net>
Subject: [PATCHv2 1/2] mac80211: perform power save processing before decryption
Date: Wed, 14 Aug 2013 15:29:46 +0200
Message-Id: <1376486987-23224-1-git-send-email-ja@anyfi.net> (sfid-20130814_153052_222746_81256D18)
In-Reply-To: <1376323275.11514.26.camel@jlt4.sipsolutions.net>
References: <1376323275.11514.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch decouples the power save processing from the frame decryption
by running the decrypt rx handler after sta_process. In the case where
the decryption failed for some reason, the stack used to not process
the PM and MOREDATA bits for that frame. The stack now always performs
power save processing regardless of the decryption result. That means that
encrypted data frames and NULLFUNC frames are now handled in the same way
regarding power save processing, making the stack more robust.

Tested-by: Johan Almbladh <ja@anyfi.net>
Signed-off-by: Johan Almbladh <ja@anyfi.net>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6b85f95..0f0017d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2939,10 +2939,10 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 		 */
 		rx->skb = skb;
 
-		CALL_RXH(ieee80211_rx_h_decrypt)
 		CALL_RXH(ieee80211_rx_h_check_more_data)
 		CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll)
 		CALL_RXH(ieee80211_rx_h_sta_process)
+		CALL_RXH(ieee80211_rx_h_decrypt)
 		CALL_RXH(ieee80211_rx_h_defragment)
 		CALL_RXH(ieee80211_rx_h_michael_mic_verify)
 		/* must be after MMIC verify so header is counted in MPDU mic */
-- 
1.7.9.5

