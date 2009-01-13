Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19395 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbZAMT6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:38 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 07/12] cfg80211: allow driver read access to cfg80211_regdomain
Date: Tue, 13 Jan 2009 11:57:50 -0800
Message-ID: <1231876675-20518-8-git-send-email-lrodriguez@atheros.com> (sfid-20090113_205841_871676_B84F33D4)
In-Reply-To: <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A driver's reg_notfier() may want to inspect the currently set
regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |    3 +++
 net/wireless/reg.c     |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index cb04e7b..4fd40a2 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -437,4 +437,7 @@ extern int regulatory_set_custom_rd(
  */
 extern int regdom_intersect_wiphy_regd(struct wiphy *wiphy);
 
+/* The wireless core regulatory domain */
+extern const struct ieee80211_regdomain *cfg80211_regdomain;
+
 #endif /* __NET_WIRELESS_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 88e8ff0..ad38a9d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -89,7 +89,8 @@ static u32 supported_bandwidths[] = {
 /* Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
  * information to give us an alpha2 */
-static const struct ieee80211_regdomain *cfg80211_regdomain;
+const struct ieee80211_regdomain *cfg80211_regdomain;
+EXPORT_SYMBOL(cfg80211_regdomain);
 
 /* We use this as a place for the rd structure built from the
  * last parsed country IE to rest until CRDA gets back to us with
-- 
1.6.1.rc3.51.g5832d

