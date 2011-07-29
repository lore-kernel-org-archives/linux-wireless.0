Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9385 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab1G2Cuq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 22:50:46 -0400
Subject: [PATCH] lib80211: remove exports for functions not called by other
 modules
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 28 Jul 2011 22:50:44 -0400
Message-ID: <20110729025044.7949.95137.stgit@mj.roinet.com> (sfid-20110729_045050_005665_5299258B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 include/net/lib80211.h  |    3 ---
 net/wireless/lib80211.c |   15 +++++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index 848cce1..659c269 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -117,10 +117,7 @@ void lib80211_crypt_info_free(struct lib80211_crypt_info *info);
 int lib80211_register_crypto_ops(struct lib80211_crypto_ops *ops);
 int lib80211_unregister_crypto_ops(struct lib80211_crypto_ops *ops);
 struct lib80211_crypto_ops *lib80211_get_crypto_ops(const char *name);
-void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *, int);
-void lib80211_crypt_deinit_handler(unsigned long);
 void lib80211_crypt_delayed_deinit(struct lib80211_crypt_info *info,
 				    struct lib80211_crypt_data **crypt);
-void lib80211_crypt_quiescing(struct lib80211_crypt_info *info);
 
 #endif /* LIB80211_H */
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index 3268fac..a55c27b 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -41,6 +41,11 @@ struct lib80211_crypto_alg {
 static LIST_HEAD(lib80211_crypto_algs);
 static DEFINE_SPINLOCK(lib80211_crypto_lock);
 
+static void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *info,
+					  int force);
+static void lib80211_crypt_quiescing(struct lib80211_crypt_info *info);
+static void lib80211_crypt_deinit_handler(unsigned long data);
+
 const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
 {
 	const char *s = ssid;
@@ -111,7 +116,8 @@ void lib80211_crypt_info_free(struct lib80211_crypt_info *info)
 }
 EXPORT_SYMBOL(lib80211_crypt_info_free);
 
-void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *info, int force)
+static void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *info,
+					  int force)
 {
 	struct lib80211_crypt_data *entry, *next;
 	unsigned long flags;
@@ -131,10 +137,9 @@ void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *info, int force)
 	}
 	spin_unlock_irqrestore(info->lock, flags);
 }
-EXPORT_SYMBOL(lib80211_crypt_deinit_entries);
 
 /* After this, crypt_deinit_list won't accept new members */
-void lib80211_crypt_quiescing(struct lib80211_crypt_info *info)
+static void lib80211_crypt_quiescing(struct lib80211_crypt_info *info)
 {
 	unsigned long flags;
 
@@ -142,9 +147,8 @@ void lib80211_crypt_quiescing(struct lib80211_crypt_info *info)
 	info->crypt_quiesced = 1;
 	spin_unlock_irqrestore(info->lock, flags);
 }
-EXPORT_SYMBOL(lib80211_crypt_quiescing);
 
-void lib80211_crypt_deinit_handler(unsigned long data)
+static void lib80211_crypt_deinit_handler(unsigned long data)
 {
 	struct lib80211_crypt_info *info = (struct lib80211_crypt_info *)data;
 	unsigned long flags;
@@ -160,7 +164,6 @@ void lib80211_crypt_deinit_handler(unsigned long data)
 	}
 	spin_unlock_irqrestore(info->lock, flags);
 }
-EXPORT_SYMBOL(lib80211_crypt_deinit_handler);
 
 void lib80211_crypt_delayed_deinit(struct lib80211_crypt_info *info,
 				    struct lib80211_crypt_data **crypt)
