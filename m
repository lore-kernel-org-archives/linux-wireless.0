Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64264 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1KJHfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 02:35:21 -0500
Received: by wwh12 with SMTP id 12so1904331wwh.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 23:35:19 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: make sure hw_key exists before checking its flags
Date: Thu, 10 Nov 2011 09:35:13 +0200
Message-Id: <1320910513-31886-1-git-send-email-arik@wizery.com> (sfid-20111110_083525_013082_3C80537F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes a bug introduced in:

commit 077a9154898b374f20555adc3f620cccd02581d6
Author: Arik Nemtsov <arik@wizery.com>
Date:   Sun Oct 23 08:21:41 2011 +0200

Reported-by: Arend van Spriel <arend@broadcom.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/wpa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 13efab5..106e15a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -415,7 +415,8 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	memmove(pos, pos + CCMP_HDR_LEN, hdrlen);
 
 	/* the HW only needs room for the IV, but not the actual IV */
-	if (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)
+	if (info->control.hw_key &&
+	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
 		return 0;
 
 	hdr = (struct ieee80211_hdr *) pos;
-- 
1.7.5.4

