Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51441 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaAVWzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 17:55:47 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] mac80211: Support tx-hw-crypt with rx-sw-crypt.
Date: Wed, 22 Jan 2014 14:54:56 -0800
Message-Id: <1390431296-20568-2-git-send-email-greearb@candelatech.com> (sfid-20140122_235550_068991_E5B7233B)
In-Reply-To: <1390431296-20568-1-git-send-email-greearb@candelatech.com>
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Some NICs can be made to offload the tx encryption and
run the rx encryption in software.  This can be used to
allow connecting several stations to the same AP, since most
hardware appears to hash only on the remote peer's MAC.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/mac80211.h | 4 ++++
 net/mac80211/tkip.c    | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f4ab2fb..dc552c7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1203,6 +1203,9 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  *	fall back to software crypto. Note that this flag deals only with
  *	RX, if your crypto engine can't deal with TX you can also set the
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
+ * @IEEE80211_KEY_FLAG_SW_RX_CRYPT: This flag indicates hardware will not
+ *	do any decrypt for received packets, though it may have uploaded
+ *	the hardware key to be used for encrypting transmitted frames.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
@@ -1211,6 +1214,7 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_SW_MGMT_TX	= 1<<4,
 	IEEE80211_KEY_FLAG_PUT_IV_SPACE = 1<<5,
 	IEEE80211_KEY_FLAG_RX_MGMT	= 1<<6,
+	IEEE80211_KEY_FLAG_SW_RX_CRYPT	= 1<<7,
 };
 
 /**
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 0ae2077..83ac9d9 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -283,7 +283,8 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 		tkip_mixing_phase1(tk, &key->u.tkip.rx[queue], ta, iv32);
 	}
 	if (key->local->ops->update_tkip_key &&
-	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+	    (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+	     !(key->conf.flags & IEEE80211_KEY_FLAG_SW_RX_CRYPT)) &&
 	    key->u.tkip.rx[queue].state != TKIP_STATE_PHASE1_HW_UPLOADED) {
 		struct ieee80211_sub_if_data *sdata = key->sdata;
 
-- 
1.7.11.7

