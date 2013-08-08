Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39774 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab3HHNXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 09:23:20 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so2406541lbh.37
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2013 06:23:17 -0700 (PDT)
From: Johan Almbladh <ja@anyfi.net>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Johan Almbladh <ja@anyfi.net>
Subject: [RFC] mac80211: add support for split-MAC implementations
Date: Thu,  8 Aug 2013 15:21:56 +0200
Message-Id: <1375968116-24331-1-git-send-email-ja@anyfi.net> (sfid-20130808_152323_403398_02DCB2EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables power save processing for encrypted frames even if the
encryption key is not set. This is a requirement when implementing split-MAC
systems like Anyfi.net [1] and CAPWAP [2] on mac80211 using monitor frame
injection and reception. The mac80211 RX handlers are reordered slightly so
that the power save handler is invoked before the decryption handler.

The patch is minimal in the sense that it provides the required functionality
with a minimal change, but I am open to suggestions if this change is too
intrusive. Please let me know what you think.

[1] http://anyfi.net/documentation#architecture
[2] http://tools.ietf.org/html/rfc5416

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

