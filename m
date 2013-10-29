Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3J2JCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 05:02:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: verify ieee80211_key_replace() arguments
Date: Tue, 29 Oct 2013 10:02:31 +0100
Message-Id: <1383037351-18687-1-git-send-email-johannes@sipsolutions.net> (sfid-20131029_100242_424137_47FDCB81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no code calling ieee80211_key_replace() with both
arguments NULL and it wouldn't make sense, but in the
interest of maintainability add a warning for it. As a
side effect, this also shuts up a smatch warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 3e51dd7..ab84680 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -260,6 +260,10 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	int idx;
 	bool defunikey, defmultikey, defmgmtkey;
 
+	/* caller must provide at least one old/new */
+	if (WARN_ON(!new && !old))
+		return;
+
 	if (new)
 		list_add_tail(&new->list, &sdata->key_list);
 
-- 
1.8.4.rc3

