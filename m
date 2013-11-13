Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63326 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3KMNSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 08:18:06 -0500
Received: by mail-wi0-f179.google.com with SMTP id fb10so770136wid.6
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 05:18:04 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] squash! mac80211: minstrel_ht: add basic support for VHT rates <= 80MHz
Date: Wed, 13 Nov 2013 14:17:32 +0100
Message-Id: <1384348652-11738-1-git-send-email-karl.beldan@gmail.com> (sfid-20131113_141810_060623_2862CE6A)
In-Reply-To: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
References: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

For v2:
- In case vht is supported but CONFIG_MAC80211_RC_MINSTREL_VHT is not
  set or the sta vht tx map has no rate supported (not sure the latter
  can happen) set vht_only to 0 to not fallback to legacy.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index a1f3f75..88c932e 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -985,7 +985,13 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) != MINSTREL_GROUPS_NB);
 
 	/* For the moment be less verbose and disable ht rates for a vht sta */
-	vht_only = vht_cap->vht_supported;
+#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
+       if (vht_cap->vht_supported)
+               vht_only = vht_cap->vht_mcs.tx_mcs_map != cpu_to_le16(~0);
+       else
+#endif
+	vht_only = 0;
+
 
 	msp->is_ht = true;
 	memset(mi, 0, sizeof(*mi));
-- 
1.8.2

