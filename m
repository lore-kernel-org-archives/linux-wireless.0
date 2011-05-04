Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58637 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab1EDTz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 15:55:57 -0400
Received: by pzk9 with SMTP id 9so647750pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 12:55:57 -0700 (PDT)
Message-ID: <4DC1AF49.7080204@lwfinger.net> (sfid-20110504_215600_352107_FAC3642B)
Date: Wed, 04 May 2011 14:55:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: WARNING from mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes and John,

A regression in recent versions of mac80211 are generating the WARNING at 
net/mac80211/wep.c:101, because the skb headroom is less than WEP_IV_LEN or the 
tailroom is less than WEP_ICV_LEN. My testing indicates that it is a headroom 
problem as the following hack "fixes" it:

Index: wireless-testing-new/net/mac80211/tx.c
===================================================================
--- wireless-testing-new.orig/net/mac80211/tx.c
+++ wireless-testing-new/net/mac80211/tx.c
@@ -1935,6 +1935,8 @@ netdev_tx_t ieee80211_subif_start_xmit(s
                 head_need += IEEE80211_ENCRYPT_HEADROOM;
                 head_need += local->tx_headroom;
                 head_need = max_t(int, 0, head_need);
+               if (head_need < WEP_IV_LEN)
+                       head_need = WEP_IV_LEN;
                 if (ieee80211_skb_resize(local, skb, head_need, true))
                         goto fail;
         }

I'm certain that this is too simple minded, but it at least points to a place to 
look. I have not bisected the problem to see which commit caused the regression, 
but I can if you want.

Larry
