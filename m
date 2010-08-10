Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab0HJHvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 03:51:03 -0400
Message-Id: <20100810074700.196290960@sipsolutions.net>
Date: Tue, 10 Aug 2010 09:46:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] mac80211: move key tfm setup
References: <20100810074637.034583799@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to keep separate if statements
for setting up the CCMP/AES-CMAC tfm structs;
move that into the existing switch statement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

--- wireless-testing.orig/net/mac80211/key.c	2010-08-08 11:03:25.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2010-08-08 11:03:26.000000000 +0200
@@ -277,19 +277,6 @@ struct ieee80211_key *ieee80211_key_allo
 					key->u.ccmp.rx_pn[i][j] =
 						seq[CCMP_PN_LEN - j - 1];
 		}
-		break;
-	case WLAN_CIPHER_SUITE_AES_CMAC:
-		key->conf.iv_len = 0;
-		key->conf.icv_len = sizeof(struct ieee80211_mmie);
-		if (seq)
-			for (j = 0; j < 6; j++)
-				key->u.aes_cmac.rx_pn[j] = seq[6 - j - 1];
-		break;
-	}
-	memcpy(key->conf.key, key_data, key_len);
-	INIT_LIST_HEAD(&key->list);
-
-	if (cipher == WLAN_CIPHER_SUITE_CCMP) {
 		/*
 		 * Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
@@ -299,9 +286,13 @@ struct ieee80211_key *ieee80211_key_allo
 			kfree(key);
 			return NULL;
 		}
-	}
-
-	if (cipher == WLAN_CIPHER_SUITE_AES_CMAC) {
+		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		key->conf.iv_len = 0;
+		key->conf.icv_len = sizeof(struct ieee80211_mmie);
+		if (seq)
+			for (j = 0; j < 6; j++)
+				key->u.aes_cmac.rx_pn[j] = seq[6 - j - 1];
 		/*
 		 * Initialize AES key state here as an optimization so that
 		 * it does not need to be initialized for every packet.
@@ -312,7 +303,10 @@ struct ieee80211_key *ieee80211_key_allo
 			kfree(key);
 			return NULL;
 		}
+		break;
 	}
+	memcpy(key->conf.key, key_data, key_len);
+	INIT_LIST_HEAD(&key->list);
 
 	return key;
 }


