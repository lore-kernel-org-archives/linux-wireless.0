Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58017 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753890AbcI1V4I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 17:56:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: wext: really don't store non-WEP keys
Date: Wed, 28 Sep 2016 23:56:00 +0200
Message-Id: <1475099760-4615-1-git-send-email-johannes@sipsolutions.net> (sfid-20160928_235613_428851_1564A207)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Jouni reported that during (repeated) wext_pmf test runs (from the
wpa_supplicant hwsim test suite) the kernel crashes. The reason is
that after the key is set, the wext code still unnecessarily stores
it into the key cache. Despite smatch pointing out an overflow, I
failed to identify the possibility for this in the code and missed
it during development of the earlier patch series.

In order to fix this, simply check that we never store anything but
WEP keys into the cache, adding a comment as to why that's enough.

Also, since the cache is still allocated early even if it won't be
used in many cases, add a comment explaining why - otherwise we'd
have to roll back key settings to the driver in case of allocation
failures, which is far more difficult.

Fixes: 89b706fb28e4 ("cfg80211: reduce connect key caching struct size")
Reported-by: Jouni Malinen <j@w1.fi>
Bisected-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-compat.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7b97d43b27e1..2b096c02eb85 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -406,6 +406,10 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 	if (pairwise && !addr)
 		return -EINVAL;
 
+	/*
+	 * In many cases we won't actually need this, but it's better
+	 * to do it first in case the allocation fails. Don't use wext.
+	 */
 	if (!wdev->wext.keys) {
 		wdev->wext.keys = kzalloc(sizeof(*wdev->wext.keys),
 					  GFP_KERNEL);
@@ -493,7 +497,13 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 	if (err)
 		return err;
 
-	if (!addr) {
+	/*
+	 * We only need to store WEP keys, since they're the only keys that
+	 * can be be set before a connection is established and persist after
+	 * disconnecting.
+	 */
+	if (!addr && (params->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+		      params->cipher == WLAN_CIPHER_SUITE_WEP104)) {
 		wdev->wext.keys->params[idx] = *params;
 		memcpy(wdev->wext.keys->data[idx],
 			params->key, params->key_len);
-- 
2.8.1
