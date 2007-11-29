Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:18673 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbXK2QJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 11:09:46 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1882088nfb
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2007 08:09:45 -0800 (PST)
Message-ID: <6cf6b73e0711290809q7c8a2050x6daf97b5eb954cbe@mail.gmail.com> (sfid-20071129_160950_242841_B38B4515)
Date: Thu, 29 Nov 2007 17:09:41 +0100
From: "Adel Gadllah" <adel.gadllah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: rate limit wep decrypt failed messages
Cc: johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The attached patch rate limits "WEP decrypt failed (ICV)" to avoid
flooding the logfiles.

Signed-off-by: Adel Gadllah <adel.gadllah@gmx.net>

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 9bf0e1c..b5f3413 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -265,7 +265,8 @@ int ieee80211_wep_decrypt(struct ieee80211_local
*local, struct sk_buff *skb,
 	if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
 				       skb->data + hdrlen + WEP_IV_LEN,
 				       len)) {
-		printk(KERN_DEBUG "WEP decrypt failed (ICV)\n");
+		if (net_ratelimit())
+			printk(KERN_DEBUG "WEP decrypt failed (ICV)\n");
 		ret = -1;
 	}
-
