Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59329 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965078Ab0GPLBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 07:01:32 -0400
Received: by wyb42 with SMTP id 42so1627206wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jul 2010 04:01:29 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: skip HT parsing if HW does not support HT
Date: Fri, 16 Jul 2010 13:01:24 +0200
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
References: <201007142343.33937.chunkeey@googlemail.com> <4C3E311B.7070402@openwrt.org>
In-Reply-To: <4C3E311B.7070402@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007161301.24940.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will also fix the odd freeze which occurred
when minstrel_ht connects to an 802.11n network with
legacy hardware.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
John,

As you know Felix has favored the alternative.
Therefore, can you please ignore
[PATCH] minstrel_ht: fix freeze with legacy hardware
and use this one instead?

Regards,
	Chr
---
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index be928ef..9d101fb 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -29,7 +29,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 
 	memset(ht_cap, 0, sizeof(*ht_cap));
 
-	if (!ht_cap_ie)
+	if (!ht_cap_ie || !sband->ht_cap.ht_supported)
 		return;
 
 	ht_cap->ht_supported = true;
