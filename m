Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45312 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727654AbeHaMiB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:38:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 31 Aug 2018 11:31:07 +0300
Message-Id: <20180831083130.15525-6-luca@coelho.fi> (sfid-20180831_103152_424092_958FB1E3)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 05/28] mac80211: use le16_encode_bits() instead of open-coding
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of open-coding the equivalent of le16_encode_bits(),
just use that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 134bbbc9cd6e..f988609e1283 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -549,7 +549,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 	if (status->encoding == RX_ENC_HE &&
 	    status->flag & RX_FLAG_RADIOTAP_HE) {
-#define HE_PREP(f, val)	cpu_to_le16(FIELD_PREP(IEEE80211_RADIOTAP_HE_##f, val))
+#define HE_PREP(f, val)	le16_encode_bits(val, IEEE80211_RADIOTAP_HE_##f)
 
 		if (status->enc_flags & RX_ENC_FLAG_STBC_MASK) {
 			he.data6 |= HE_PREP(DATA6_NSTS,
-- 
2.18.0
