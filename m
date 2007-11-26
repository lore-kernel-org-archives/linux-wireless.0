Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:22213 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbXKZRf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 12:35:27 -0500
Received: by py-out-1112.google.com with SMTP id u77so1493823pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 09:35:25 -0800 (PST)
Message-ID: <f6ca9fed0711260935n30f42c3ch5d9debd12a02ebc2@mail.gmail.com> (sfid-20071126_173530_686302_83A4301A)
Date: Mon, 26 Nov 2007 18:35:24 +0100
From: dragoran <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: [PATCH] rate limit wep decrypt failed messages
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>, "Jouni Malinen" <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Zhu Yi" <yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 26, 2007 6:01 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > looking at the code seems not:
> > ---
> >     if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
> >                        skb->data + hdrlen + WEP_IV_LEN,
> >                        len)) {
> >         printk(KERN_DEBUG "WEP decrypt failed (ICV)\n");
> >         ret = -1;
> >     }
> > ---
>
> Huh I thought they were. Of course they need to be rate limited then.
> Can you send a patch?
>
sure attached.
----
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
