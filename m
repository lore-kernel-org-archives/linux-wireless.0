Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51427 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbcCIJ3w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 04:29:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: allow same PN for AMSDU sub-frames
Date: Wed,  9 Mar 2016 11:29:45 +0200
Message-Id: <1457515785-18795-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_102957_273369_D8765A06)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Some hardware (iwlwifi an example) de-aggregate AMSDUs and
copy the IV as is to the generated MPDUs, so the same PN
appears in multiple packets without being a replay attack.
Do not increment the PN until all the sub-frames are received
to accommodate to that.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/wpa.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 7e4f265..7ba66b3 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -542,8 +542,9 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 				    skb->data + skb->len - mic_len, mic_len))
 				return RX_DROP_UNUSABLE;
 		}
-
-		memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+		if (!(status->flag & RX_FLAG_AMSDU_MORE))
+			memcpy(key->u.ccmp.rx_pn[queue], pn,
+			       IEEE80211_CCMP_PN_LEN);
 	}
 
 	/* Remove CCMP header and MIC */
@@ -769,8 +770,9 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 				    IEEE80211_GCMP_MIC_LEN))
 				return RX_DROP_UNUSABLE;
 		}
-
-		memcpy(key->u.gcmp.rx_pn[queue], pn, IEEE80211_GCMP_PN_LEN);
+		if (!(status->flag & RX_FLAG_AMSDU_MORE))
+			memcpy(key->u.gcmp.rx_pn[queue], pn,
+			       IEEE80211_GCMP_PN_LEN);
 	}
 
 	/* Remove GCMP header and MIC */
-- 
2.5.0

