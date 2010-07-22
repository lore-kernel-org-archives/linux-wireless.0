Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53637 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655Ab0GVUpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 16:45:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] lib80211: remove unused host_build_iv option
Date: Thu, 22 Jul 2010 16:33:00 -0400
Message-Id: <1279830780-13729-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/libipw.h    |    1 -
 drivers/net/wireless/ipw2x00/libipw_tx.c |   16 +++-------------
 drivers/net/wireless/ipw2x00/libipw_wx.c |    2 +-
 include/net/lib80211.h                   |    3 ---
 net/wireless/lib80211_crypt_ccmp.c       |    1 -
 net/wireless/lib80211_crypt_tkip.c       |    1 -
 net/wireless/lib80211_crypt_wep.c        |    1 -
 7 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index 284b0e4..7b9539a 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -828,7 +828,6 @@ struct libipw_device {
 	int host_strip_iv_icv;
 
 	int host_open_frag;
-	int host_build_iv;
 	int ieee802_1x;		/* is IEEE 802.1X used */
 
 	/* WPA data */
diff --git a/drivers/net/wireless/ipw2x00/libipw_tx.c b/drivers/net/wireless/ipw2x00/libipw_tx.c
index da8beac..01c88a7 100644
--- a/drivers/net/wireless/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_tx.c
@@ -260,7 +260,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 	int i, bytes_per_frag, nr_frags, bytes_last_frag, frag_size,
 	    rts_required;
 	unsigned long flags;
-	int encrypt, host_encrypt, host_encrypt_msdu, host_build_iv;
+	int encrypt, host_encrypt, host_encrypt_msdu;
 	__be16 ether_type;
 	int bytes, fc, hdr_len;
 	struct sk_buff *skb_frag;
@@ -301,7 +301,6 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	host_encrypt = ieee->host_encrypt && encrypt && crypt;
 	host_encrypt_msdu = ieee->host_encrypt_msdu && encrypt && crypt;
-	host_build_iv = ieee->host_build_iv && encrypt && crypt;
 
 	if (!encrypt && ieee->ieee802_1x &&
 	    ieee->drop_unencrypted && ether_type != htons(ETH_P_PAE)) {
@@ -313,7 +312,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_copy_from_linear_data(skb, dest, ETH_ALEN);
 	skb_copy_from_linear_data_offset(skb, ETH_ALEN, src, ETH_ALEN);
 
-	if (host_encrypt || host_build_iv)
+	if (host_encrypt)
 		fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA |
 		    IEEE80211_FCTL_PROTECTED;
 	else
@@ -467,7 +466,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 	for (; i < nr_frags; i++) {
 		skb_frag = txb->fragments[i];
 
-		if (host_encrypt || host_build_iv)
+		if (host_encrypt)
 			skb_reserve(skb_frag,
 				    crypt->ops->extra_mpdu_prefix_len);
 
@@ -502,15 +501,6 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * to insert the IV between the header and the payload */
 		if (host_encrypt)
 			libipw_encrypt_fragment(ieee, skb_frag, hdr_len);
-		else if (host_build_iv) {
-			atomic_inc(&crypt->refcnt);
-			if (crypt->ops->build_iv)
-				crypt->ops->build_iv(skb_frag, hdr_len,
-				      ieee->sec.keys[ieee->sec.active_key],
-				      ieee->sec.key_sizes[ieee->sec.active_key],
-				      crypt->priv);
-			atomic_dec(&crypt->refcnt);
-		}
 
 		if (ieee->config &
 		    (CFG_LIBIPW_COMPUTE_FCS | CFG_LIBIPW_RESERVE_FCS))
diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 8a4bae4..d7bd6cf 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -320,7 +320,7 @@ int libipw_wx_set_encode(struct libipw_device *ieee,
 	};
 	int i, key, key_provided, len;
 	struct lib80211_crypt_data **crypt;
-	int host_crypto = ieee->host_encrypt || ieee->host_decrypt || ieee->host_build_iv;
+	int host_crypto = ieee->host_encrypt || ieee->host_decrypt;
 	DECLARE_SSID_BUF(ssid);
 
 	LIBIPW_DEBUG_WX("SET_ENCODE\n");
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index fb4e278..848cce1 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -54,9 +54,6 @@ struct lib80211_crypto_ops {
 	/* deinitialize crypto context and free allocated private data */
 	void (*deinit) (void *priv);
 
-	int (*build_iv) (struct sk_buff * skb, int hdr_len,
-			 u8 *key, int keylen, void *priv);
-
 	/* encrypt/decrypt return < 0 on error or >= 0 on success. The return
 	 * value from decrypt_mpdu is passed as the keyidx value for
 	 * decrypt_msdu. skb must have enough head and tail room for the
diff --git a/net/wireless/lib80211_crypt_ccmp.c b/net/wireless/lib80211_crypt_ccmp.c
index b7fa31d..dacb3b4 100644
--- a/net/wireless/lib80211_crypt_ccmp.c
+++ b/net/wireless/lib80211_crypt_ccmp.c
@@ -467,7 +467,6 @@ static struct lib80211_crypto_ops lib80211_crypt_ccmp = {
 	.name = "CCMP",
 	.init = lib80211_ccmp_init,
 	.deinit = lib80211_ccmp_deinit,
-	.build_iv = lib80211_ccmp_hdr,
 	.encrypt_mpdu = lib80211_ccmp_encrypt,
 	.decrypt_mpdu = lib80211_ccmp_decrypt,
 	.encrypt_msdu = NULL,
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index a7f9956..0fe4051 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -757,7 +757,6 @@ static struct lib80211_crypto_ops lib80211_crypt_tkip = {
 	.name = "TKIP",
 	.init = lib80211_tkip_init,
 	.deinit = lib80211_tkip_deinit,
-	.build_iv = lib80211_tkip_hdr,
 	.encrypt_mpdu = lib80211_tkip_encrypt,
 	.decrypt_mpdu = lib80211_tkip_decrypt,
 	.encrypt_msdu = lib80211_michael_mic_add,
diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index 6d41e05..e2e8887 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -269,7 +269,6 @@ static struct lib80211_crypto_ops lib80211_crypt_wep = {
 	.name = "WEP",
 	.init = lib80211_wep_init,
 	.deinit = lib80211_wep_deinit,
-	.build_iv = lib80211_wep_build_iv,
 	.encrypt_mpdu = lib80211_wep_encrypt,
 	.decrypt_mpdu = lib80211_wep_decrypt,
 	.encrypt_msdu = NULL,
-- 
1.7.1.1

