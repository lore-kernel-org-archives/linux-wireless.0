Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45401 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaDIIOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 04:14:36 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so1552729eek.13
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 01:14:35 -0700 (PDT)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 1/2] mac80211: add option to generate CCMP IVs only for mgmt frames
Date: Wed,  9 Apr 2014 10:14:02 +0200
Message-Id: <1397031243-24388-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140409_101443_556497_E5236DFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chips can encrypt managment frames in HW, but
require generated IV in the frame. Add a key flag
that allows us to achieve this.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 include/net/mac80211.h |   16 ++++++++++------
 net/mac80211/tx.c      |    5 +++--
 net/mac80211/wpa.c     |    6 ++++--
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2de7ff4..c81415f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1202,14 +1202,18 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *	fall back to software crypto. Note that this flag deals only with
  *	RX, if your crypto engine can't deal with TX you can also set the
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
+ * @IEEE80211_KEY_FLAG_GENERATE_MGMT_IV: This flag should be set by the
+ *	driver for a CCMP key to indicate that is requires IV generation
+ *	only for managment frames (MFP).
  */
 enum ieee80211_key_flags {
-	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
-	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
-	IEEE80211_KEY_FLAG_PAIRWISE	= 1<<3,
-	IEEE80211_KEY_FLAG_SW_MGMT_TX	= 1<<4,
-	IEEE80211_KEY_FLAG_PUT_IV_SPACE = 1<<5,
-	IEEE80211_KEY_FLAG_RX_MGMT	= 1<<6,
+	IEEE80211_KEY_FLAG_GENERATE_IV		= 1<<1,
+	IEEE80211_KEY_FLAG_GENERATE_MMIC	= 1<<2,
+	IEEE80211_KEY_FLAG_PAIRWISE		= 1<<3,
+	IEEE80211_KEY_FLAG_SW_MGMT_TX		= 1<<4,
+	IEEE80211_KEY_FLAG_PUT_IV_SPACE		= 1<<5,
+	IEEE80211_KEY_FLAG_RX_MGMT		= 1<<6,
+	IEEE80211_KEY_FLAG_SW_MGMT_IV_TX	= 1<<7,
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 19d36d4..49b19ab 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -625,8 +625,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 				tx->key = NULL;
 			else
 				skip_hw = (tx->key->conf.flags &
-					   IEEE80211_KEY_FLAG_SW_MGMT_TX) &&
-					ieee80211_is_mgmt(hdr->frame_control);
+				      (IEEE80211_KEY_FLAG_SW_MGMT_TX |
+				       IEEE80211_KEY_FLAG_GENERATE_MGMT_IV)) &&
+				       ieee80211_is_mgmt(hdr->frame_control);
 			break;
 		case WLAN_CIPHER_SUITE_AES_CMAC:
 			if (!ieee80211_is_mgmt(hdr->frame_control))
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index b8600e3..a5fe1d9 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -450,8 +450,10 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 	ccmp_pn2hdr(pos, pn, key->conf.keyidx);
 
-	/* hwaccel - with software CCMP header */
-	if (info->control.hw_key)
+	/* hwaccel - with software CCMP header or the HW needs
+	 * generated the IV */
+	if (info->control.hw_key ||
+	    (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MGMT_IV))
 		return 0;
 
 	pos += IEEE80211_CCMP_HDR_LEN;
-- 
1.7.9.5
