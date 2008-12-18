Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38071 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbYLRMlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 07:41:01 -0500
Received: from jm (a91-155-82-88.elisa-laajakaista.fi [91.155.82.88])
	(authenticated bits=0)
	by jmalinen.user.openhosting.com (8.13.8/8.13.8) with ESMTP id mBICevIK013445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 07:40:58 -0500
Date: Thu, 18 Dec 2008 14:40:57 +0200
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: Add an RX flag to skip Michael MIC verification
Message-ID: <20081218124057.GC32267@jm.kir.nu> (sfid-20081218_134107_532732_2FB720A4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 used to allow drivers to indicate that Michael MIC has already
been verified in received frames to allow the somewhat heavy operation
of validating this in software to be avoided. This disappeared as part
of hardware crypto flag rework (commit
7848ba7d7a010ccb265617fc2bc053e2bdf06f48). The changes below propose a
bit different mechanism for achieving the same benefit for host CPU with
wlan designs that can verify Michael MIC for unfragmented frames in
hardware.

I'm also including a patch to ath9k to start using this new mechanism
and move Michael MIC processing to hardware for both TX and RX whenever
possible. It seems to work based on minimal testing, but I do not want
to submit it to be merged before more thorough testing has taken place.


Some hardware acceleration designs for TKIP take care of Michael MIC
verification in received frames (well, at least for frames that were
not fragmented). Add an RX status flag to allow the expensive software
validation of the Michael MIC to be skipped in cases where it has
already been verified in hardware.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/net/mac80211.h |    3 +++
 net/mac80211/wpa.c     |    4 ++++
 2 files changed, 7 insertions(+)

--- wireless-testing.orig/include/net/mac80211.h	2008-12-18 13:48:45.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2008-12-18 13:49:08.000000000 +0200
@@ -439,6 +439,8 @@ ieee80211_tx_info_clear_status(struct ie
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
  * @RX_FLAG_SHORT_GI: Short guard interval was used
+ * @RX_FLAG_MMIC_VERIFIED: the hardware has verified the Michael MIC, but the
+ *	MIC has not been stripped off this frame.
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -453,6 +455,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_HT		= 1<<9,
 	RX_FLAG_40MHZ		= 1<<10,
 	RX_FLAG_SHORT_GI	= 1<<11,
+	RX_FLAG_MMIC_VERIFIED	= 1<<12,
 };
 
 /**
--- wireless-testing.orig/net/mac80211/wpa.c	2008-12-18 13:48:45.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2008-12-18 13:49:08.000000000 +0200
@@ -99,6 +99,9 @@ ieee80211_rx_h_michael_mic_verify(struct
 	    !ieee80211_is_data_present(hdr->frame_control))
 		return RX_CONTINUE;
 
+	if (rx->status->flag & RX_FLAG_MMIC_VERIFIED)
+		goto remove_mic;
+
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (skb->len < hdrlen + MICHAEL_MIC_LEN)
 		return RX_DROP_UNUSABLE;
@@ -125,6 +128,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 		return RX_DROP_UNUSABLE;
 	}
 
+remove_mic:
 	/* remove Michael MIC from payload */
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 



ath9k: Michael MIC in hardware

Remove request for mac80211 to calculate Michael MIC when TKIP is used
since that is not needed with any hardware revisions supported by
ath9k. Only fragmented frames need Michael MIC processing in the stack
and that will be taken care of automatically without driver
request. Mark received frames that that hardware decrypted to have
passed Michael MIC verification if they were not fragmented
(fragmented frames will continue to be verified in mac80211).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    3 ---
 drivers/net/wireless/ath9k/recv.c |   11 +++++++++++
 drivers/net/wireless/ath9k/xmit.c |    8 ++++++++
 3 files changed, 19 insertions(+), 3 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2008-12-18 14:12:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2008-12-18 14:13:01.000000000 +0200
@@ -2366,10 +2366,7 @@ static int ath9k_set_key(struct ieee8021
 		ret = ath_key_config(sc, addr, key);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
-			/* push IV and Michael MIC generation to stack */
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-			if (key->alg == ALG_TKIP)
-				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
 			ret = 0;
 		}
 		break;
--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2008-12-18 14:12:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2008-12-18 14:13:01.000000000 +0200
@@ -594,6 +594,17 @@ int ath_rx_tasklet(struct ath_softc *sc,
 				rx_status.flag |= RX_FLAG_DECRYPTED;
 		}
 
+		if (rx_status.flag & RX_FLAG_DECRYPTED) {
+			/* Hardware verifies Michael MIC in unfragmented
+			 * frames, so there is no need to do software
+			 * verification for them. */
+			__le16 fc = hdr->frame_control;
+			u16 sc = le16_to_cpu(hdr->seq_ctrl);
+			if (!ieee80211_has_morefrags(fc) &&
+			    (sc & IEEE80211_SCTL_FRAG) == 0)
+				rx_status.flag |= RX_FLAG_MMIC_VERIFIED;
+		}
+
 		/* Send the frame to mac80211 */
 		__ieee80211_rx(sc->hw, skb, &rx_status);
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/xmit.c	2008-12-18 14:13:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/xmit.c	2008-12-18 14:23:23.000000000 +0200
@@ -1711,6 +1711,14 @@ static int ath_tx_setup_buffer(struct at
 
 	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
 		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
+		if (bf->bf_keytype == ATH9K_KEY_TYPE_TKIP &&
+		    !ieee80211_has_morefrags(fc)) {
+			u16 sc = le16_to_cpu(hdr->seq_ctrl);
+			if ((sc & IEEE80211_SCTL_FRAG) == 0) {
+				 /* Michael MIC in hardware */
+				bf->bf_frmlen += 8;
+			}
+		}
 		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
 	} else {
 		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;

-- 
Jouni Malinen                                            PGP id EFC895FA
