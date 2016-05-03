Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39604 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932903AbcECM76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 08:59:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: emmanuel.grumbach@intel.com, Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  3 May 2016 15:59:44 +0300
Message-Id: <1462280384-19764-1-git-send-email-luca@coelho.fi> (sfid-20160503_150001_588665_0B18B363)
Subject: [PATCH v2] mac80211: allow same PN for AMSDU sub-frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Some hardware (iwlwifi an example) de-aggregate AMSDUs and copy the IV
as is to the generated MPDUs, so the same PN appears in multiple
packets without being a replay attack.  Allow driver to explicitly
indicate that a frame is allowed to have the same PN as the previous
frame.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h |  6 +++++-
 net/mac80211/wpa.c     | 16 ++++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 07ef937..ce2f6e3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1068,6 +1068,9 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_RADIOTAP_VENDOR_DATA: This frame contains vendor-specific
  *	radiotap data in the skb->data (before the frame) as described by
  *	the &struct ieee80211_vendor_radiotap.
+ * @RX_FLAG_ALLOW_SAME_PN: Allow the same PN as same packet before.
+ *	This is used for AMSDU subframes which can have the same PN as
+ *	the first subframe.
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -1101,7 +1104,8 @@ enum mac80211_rx_flags {
 	RX_FLAG_5MHZ			= BIT(29),
 	RX_FLAG_AMSDU_MORE		= BIT(30),
 	RX_FLAG_RADIOTAP_VENDOR_DATA	= BIT(31),
-	RX_FLAG_MIC_STRIPPED            = BIT_ULL(32),
+	RX_FLAG_MIC_STRIPPED		= BIT_ULL(32),
+	RX_FLAG_ALLOW_SAME_PN		= BIT_ULL(33),
 };
 
 #define RX_FLAG_STBC_SHIFT		26
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 7e4f265..b48c1e1 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -519,12 +519,16 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 		return RX_DROP_UNUSABLE;
 
 	if (!(status->flag & RX_FLAG_PN_VALIDATED)) {
+		int res;
+
 		ccmp_hdr2pn(pn, skb->data + hdrlen);
 
 		queue = rx->security_idx;
 
-		if (memcmp(pn, key->u.ccmp.rx_pn[queue],
-			   IEEE80211_CCMP_PN_LEN) <= 0) {
+		res = memcmp(pn, key->u.ccmp.rx_pn[queue],
+			     IEEE80211_CCMP_PN_LEN);
+		if (res < 0 ||
+		    (!res && !(status->flag & RX_FLAG_ALLOW_SAME_PN))) {
 			key->u.ccmp.replays++;
 			return RX_DROP_UNUSABLE;
 		}
@@ -745,12 +749,16 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 		return RX_DROP_UNUSABLE;
 
 	if (!(status->flag & RX_FLAG_PN_VALIDATED)) {
+		int res;
+
 		gcmp_hdr2pn(pn, skb->data + hdrlen);
 
 		queue = rx->security_idx;
 
-		if (memcmp(pn, key->u.gcmp.rx_pn[queue],
-			   IEEE80211_GCMP_PN_LEN) <= 0) {
+		res = memcmp(pn, key->u.gcmp.rx_pn[queue],
+			     IEEE80211_GCMP_PN_LEN);
+		if (res < 0 ||
+		    (!res && !(status->flag & RX_FLAG_ALLOW_SAME_PN))) {
 			key->u.gcmp.replays++;
 			return RX_DROP_UNUSABLE;
 		}
-- 
2.8.0.rc3

