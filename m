Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46587 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbcESPem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 11:34:42 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix fast_tx header alignment
Date: Thu, 19 May 2016 17:34:38 +0200
Message-Id: <1463672078-7982-1-git-send-email-nbd@nbd.name> (sfid-20160519_173445_960518_F6198102)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The header field is defined as u8[] but also accessed as struct
ieee80211_hdr. Enforce an alignment of 2 to prevent unnecessary
unaligned accesses, which can be very harmful for performance on many
platforms.

Fixes: e495c24731a2 ("mac80211: extend fast-xmit for more ciphers")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/sta_info.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 62193f4..ba7ce53 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -275,7 +275,7 @@ struct ieee80211_fast_tx {
 	u8 sa_offs, da_offs, pn_offs;
 	u8 band;
 	u8 hdr[30 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
-	       sizeof(rfc1042_header)];
+	       sizeof(rfc1042_header)] __aligned(2);
 
 	struct rcu_head rcu_head;
 };
-- 
2.2.2

