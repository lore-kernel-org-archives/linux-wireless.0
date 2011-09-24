Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58522 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1IXQs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 12:48:27 -0400
Received: by vws1 with SMTP id 1so4837918vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Sep 2011 09:48:26 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 24 Sep 2011 18:48:26 +0200
Message-ID: <CAA2SeNLpVQTSEtNnbD+E9kVuc3OJ9Bro4rya4JnE6gR+ik=Nxg@mail.gmail.com> (sfid-20110924_184830_763976_2D65E176)
Subject: [PATCH] mac80211: max_tp_rate2 management of minstrel_ht
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed a possible issue in the max_tp_rate2 management of
minstrel_ht. In particular, if we look up just among max_tp_rate2 of
each group it will be possible that the selected rate will not be the
mcs with second maximum throughput. I wrote this simple patch.

Regards

Lorenzo

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -281,6 +281,8 @@

 		mr = minstrel_get_ratestats(mi, mg->max_tp_rate);
 		if (cur_tp < mr->cur_tp) {
+			mi->max_tp_rate2 = mi->max_tp_rate;
+			cur_tp2 = cur_tp;
 			mi->max_tp_rate = mg->max_tp_rate;
 			cur_tp = mr->cur_tp;
 		}
--
