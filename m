Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63162 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZGAVSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 17:18:06 -0400
Date: Wed, 01 Jul 2009 16:18:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] net: remove skb->do_not_encrypt from skbuff.c
Message-ID: <4a4bd294.Hac6+C1W4gkNIlOX%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 38ba8fb67d6be3258a ("net: remove unused skb->do_not_encrypt")
removed the variable from struct skbuff, but the usage in net/core/skbuff.c
crept back in, probably in the merge between mainline and wireless-testing.

Signed-off-by: Larry.Finger <Larry.Finger@lwfinger.net>
---

John,

This fixes the build problem I reported earlier.

Larry
---

Index: wireless-testing/net/core/skbuff.c
===================================================================
--- wireless-testing.orig/net/core/skbuff.c
+++ wireless-testing/net/core/skbuff.c
@@ -559,9 +559,6 @@ static void __copy_skb_header(struct sk_
 #endif
 #endif
 	new->vlan_tci		= old->vlan_tci;
-#if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
-	new->do_not_encrypt	= old->do_not_encrypt;
-#endif
 
 	skb_copy_secmark(new, old);
 }
