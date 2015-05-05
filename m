Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52196 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993199AbbEEOfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 10:35:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: max.stepanov@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: validate cipher scheme PN length better
Date: Tue,  5 May 2015 16:35:00 +0200
Message-Id: <1430836500-6297-1-git-send-email-johannes@sipsolutions.net> (sfid-20150505_194421_786136_BD90F26C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, a cipher scheme can advertise an arbitrarily long
sequence counter, but mac80211 only supports up to 16 bytes
and the initial value from userspace will be truncated.

Fix two things:
 * don't allow the driver to register anything longer than
   the 16 bytes that mac80211 reserves space for
 * require userspace to specify a starting value with the
   correct length (or none at all)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c  | 10 ++++++----
 net/mac80211/main.c |  5 ++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 0a5d5c5ad30f..2e677376c958 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -485,15 +485,17 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		break;
 	default:
 		if (cs) {
-			size_t len = (seq_len > IEEE80211_MAX_PN_LEN) ?
-						IEEE80211_MAX_PN_LEN : seq_len;
+			if (seq_len && seq_len != cs->pn_len) {
+				kfree(key);
+				return ERR_PTR(-EINVAL);
+			}
 
 			key->conf.iv_len = cs->hdr_len;
 			key->conf.icv_len = cs->mic_len;
 			for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++)
-				for (j = 0; j < len; j++)
+				for (j = 0; j < seq_len; j++)
 					key->u.gen.rx_pn[i][j] =
-							seq[len - j - 1];
+							seq[seq_len - j - 1];
 			key->flags |= KEY_FLAG_CIPHER_SCHEME;
 		}
 	}
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b4e29f9c73c8..2ca132146a79 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -768,8 +768,11 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 			suites[w++] = WLAN_CIPHER_SUITE_BIP_GMAC_256;
 		}
 
-		for (r = 0; r < local->hw.n_cipher_schemes; r++)
+		for (r = 0; r < local->hw.n_cipher_schemes; r++) {
 			suites[w++] = cs[r].cipher;
+			if (WARN_ON(cs[r].pn_len > IEEE80211_MAX_PN_LEN))
+				return -EINVAL;
+		}
 	}
 
 	local->hw.wiphy->cipher_suites = suites;
-- 
2.1.4

