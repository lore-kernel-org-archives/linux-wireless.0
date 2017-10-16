Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41918 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdJPJRy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 05:17:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: accept key reinstall without changing anything
Date: Mon, 16 Oct 2017 11:17:51 +0200
Message-Id: <20171016091751.17989-1-johannes@sipsolutions.net> (sfid-20171016_111758_022974_22D72505)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a key is reinstalled we can reset the replay counters
etc. which can lead to nonce reuse and/or replay detection
being impossible, breaking security properties, as described
in the "KRACK attacks".

In particular, CVE-2017-13080 applies to GTK rekeying that
happened in firmware while the host is in D3, with the second
part of the attack being done after the host wakes up. In
this case, the wpa_supplicant mitigation isn't sufficient
since wpa_supplicant doesn't know the GTK material.

In case this happens, simply silently accept the new key
coming from userspace but don't take any action on it since
it's the same key; this keeps the PN counter intact.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index a98fc2b5e0dc..ae995c8480db 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2008	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2015	Intel Deutschland GmbH
+ * Copyright 2015-2017	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -620,9 +620,6 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
 	idx = key->conf.keyidx;
-	key->local = sdata->local;
-	key->sdata = sdata;
-	key->sta = sta;
 
 	mutex_lock(&sdata->local->key_mtx);
 
@@ -633,6 +630,21 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	else
 		old_key = key_mtx_dereference(sdata->local, sdata->keys[idx]);
 
+	/*
+	 * Silently accept key re-installation without really installing the
+	 * new version of the key to avoid nonce reuse or replay issues.
+	 */
+	if (old_key && key->conf.keylen == old_key->conf.keylen &&
+	    !memcmp(key->conf.key, old_key->conf.key, key->conf.keylen)) {
+		ieee80211_key_free_unused(key);
+		ret = 0;
+		goto out;
+	}
+
+	key->local = sdata->local;
+	key->sdata = sdata;
+	key->sta = sta;
+
 	increment_tailroom_need_count(sdata);
 
 	ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
@@ -648,6 +660,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		ret = 0;
 	}
 
+ out:
 	mutex_unlock(&sdata->local->key_mtx);
 
 	return ret;
-- 
2.14.2
