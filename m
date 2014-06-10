Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbaFJRDr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 13:03:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Max Stepanov <Max.Stepanov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: WEP extra head/tail room in ieee80211_send_auth
Date: Tue, 10 Jun 2014 20:00:08 +0300
Message-Id: <1402419608-11892-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140610_190350_996213_E94CE0E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

After skb allocation and call to ieee80211_wep_encrypt in ieee80211_send_auth
the flow fails with a warning in ieee80211_wep_add_iv on verification of
available head/tailroom needed for WEP_IV and WEP_ICV.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4a0f3ae..1cc4d82 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1125,11 +1125,12 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	int err;
 
 	/* 24 + 6 = header + auth_algo + auth_transaction + status_code */
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24 + 6 + extra_len);
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + IEEE80211_WEP_IV_LEN +
+			    24 + 6 + extra_len + IEEE80211_WEP_ICV_LEN);
 	if (!skb)
 		return;
 
-	skb_reserve(skb, local->hw.extra_tx_headroom);
+	skb_reserve(skb, local->hw.extra_tx_headroom + IEEE80211_WEP_IV_LEN);
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24 + 6);
 	memset(mgmt, 0, 24 + 6);
-- 
1.9.1

