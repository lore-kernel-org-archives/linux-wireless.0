Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55581 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab1G2CuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 22:50:11 -0400
Subject: [PATCH] lib80211: call try_module_get() in lib80211_get_crypto_ops()
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 28 Jul 2011 22:50:07 -0400
Message-ID: <20110729025007.7889.19879.stgit@mj.roinet.com> (sfid-20110729_045017_968320_003C98BC)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doing it by the caller is racy.  Some callers neglected to do so.  Fix
callers not to call try_module_get() after lib80211_get_crypto_ops().

When ops is copied, move lib80211_crypt_delayed_deinit() after
try_module_get() to avoid the risk that the module would be unloaded
between those calls.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/hostap/hostap_ioctl.c |    5 ++---
 drivers/net/wireless/ipw2x00/libipw_wx.c   |    6 +++---
 net/wireless/lib80211.c                    |    3 +++
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 12de464..af0516c 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -166,7 +166,7 @@ static int prism2_ioctl_siwencode(struct net_device *dev,
 			request_module("lib80211_crypt_wep");
 			new_crypt->ops = lib80211_get_crypto_ops("WEP");
 		}
-		if (new_crypt->ops && try_module_get(new_crypt->ops->owner))
+		if (new_crypt->ops)
 			new_crypt->priv = new_crypt->ops->init(i);
 		if (!new_crypt->ops || !new_crypt->priv) {
 			kfree(new_crypt);
@@ -3293,8 +3293,6 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 	if (*crypt == NULL || (*crypt)->ops != ops) {
 		struct lib80211_crypt_data *new_crypt;
 
-		lib80211_crypt_delayed_deinit(&local->crypt_info, crypt);
-
 		new_crypt = kzalloc(sizeof(struct lib80211_crypt_data),
 				GFP_KERNEL);
 		if (new_crypt == NULL) {
@@ -3310,6 +3308,7 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 			goto done;
 		}
 
+		lib80211_crypt_delayed_deinit(&local->crypt_info, crypt);
 		*crypt = new_crypt;
 	}
 
diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index d7bd6cf0..04c4a60 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -395,7 +395,7 @@ int libipw_wx_set_encode(struct libipw_device *ieee,
 			new_crypt->ops = lib80211_get_crypto_ops("WEP");
 		}
 
-		if (new_crypt->ops && try_module_get(new_crypt->ops->owner))
+		if (new_crypt->ops)
 			new_crypt->priv = new_crypt->ops->init(key);
 
 		if (!new_crypt->ops || !new_crypt->priv) {
@@ -629,8 +629,6 @@ int libipw_wx_set_encodeext(struct libipw_device *ieee,
 	if (*crypt == NULL || (*crypt)->ops != ops) {
 		struct lib80211_crypt_data *new_crypt;
 
-		lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
-
 		new_crypt = kzalloc(sizeof(*new_crypt), GFP_KERNEL);
 		if (new_crypt == NULL) {
 			ret = -ENOMEM;
@@ -644,6 +642,8 @@ int libipw_wx_set_encodeext(struct libipw_device *ieee,
 			ret = -EINVAL;
 			goto done;
 		}
+
+		lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
 		*crypt = new_crypt;
 	}
 
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index a55c27b..123fa19 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -242,6 +242,7 @@ struct lib80211_crypto_ops *lib80211_get_crypto_ops(const char *name)
 {
 	struct lib80211_crypto_alg *alg;
 	unsigned long flags;
+	struct lib80211_crypto_ops *ret = NULL;
 
 	spin_lock_irqsave(&lib80211_crypto_lock, flags);
 	list_for_each_entry(alg, &lib80211_crypto_algs, list) {
@@ -252,6 +253,8 @@ struct lib80211_crypto_ops *lib80211_get_crypto_ops(const char *name)
 	return NULL;
 
       found:
+	if (try_module_get(alg->ops->owner))
+		ret = alg->ops;
 	spin_unlock_irqrestore(&lib80211_crypto_lock, flags);
 	return alg->ops;
 }
