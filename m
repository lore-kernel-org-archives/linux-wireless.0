Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbZGGCAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:19 -0400
Message-Id: <20090707015709.031033179@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/9] cfg80211: fix MFP bug, sparse warnings
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse warns about a number of things, and one of them
(use_mfp shadowed variable) actually is a bug, fix all
of them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c     |    6 +++---
 net/wireless/wext-compat.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-07 03:37:05.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-07 03:37:05.000000000 +0200
@@ -3239,11 +3239,11 @@ static int nl80211_associate(struct sk_b
 	}
 
 	if (info->attrs[NL80211_ATTR_USE_MFP]) {
-		enum nl80211_mfp use_mfp =
+		enum nl80211_mfp mfp =
 			nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
-		if (use_mfp == NL80211_MFP_REQUIRED)
+		if (mfp == NL80211_MFP_REQUIRED)
 			use_mfp = true;
-		else if (use_mfp != NL80211_MFP_NO) {
+		else if (mfp != NL80211_MFP_NO) {
 			err = -EINVAL;
 			goto out;
 		}
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-07 03:37:05.000000000 +0200
@@ -855,7 +855,7 @@ static int cfg80211_set_wpa_version(stru
 	return 0;
 }
 
-int cfg80211_set_cipher_group(struct wireless_dev *wdev, u32 cipher)
+static int cfg80211_set_cipher_group(struct wireless_dev *wdev, u32 cipher)
 {
 	wdev->wext.connect.crypto.cipher_group = 0;
 
@@ -880,7 +880,7 @@ int cfg80211_set_cipher_group(struct wir
 	return 0;
 }
 
-int cfg80211_set_cipher_pairwise(struct wireless_dev *wdev, u32 cipher)
+static int cfg80211_set_cipher_pairwise(struct wireless_dev *wdev, u32 cipher)
 {
 	int nr_ciphers = 0;
 	u32 *ciphers_pairwise = wdev->wext.connect.crypto.ciphers_pairwise;
@@ -918,7 +918,7 @@ int cfg80211_set_cipher_pairwise(struct 
 }
 
 
-int cfg80211_set_key_mgt(struct wireless_dev *wdev, u32 key_mgt)
+static int cfg80211_set_key_mgt(struct wireless_dev *wdev, u32 key_mgt)
 {
 	int nr_akm_suites = 0;
 

-- 

