Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51402 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab3EZOFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 May 2013 10:05:12 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/3] cfg80211: support an active monitor interface flag
Date: Sun, 26 May 2013 16:05:05 +0200
Message-Id: <1369577107-87931-1-git-send-email-nbd@openwrt.org> (sfid-20130526_160533_930934_4479AD62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An active monitor interface is one that is used for communication (via
injection). It is expected to ACK incoming unicast packets. This is
useful for running various 802.11 testing utilities that associate to an
AP via injection and manage the state in user space.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/cfg80211.h       | 1 +
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 1 +
 3 files changed, 5 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26b5b69..489821f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -954,6 +954,7 @@ enum monitor_flags {
 	MONITOR_FLAG_CONTROL		= 1<<NL80211_MNTR_FLAG_CONTROL,
 	MONITOR_FLAG_OTHER_BSS		= 1<<NL80211_MNTR_FLAG_OTHER_BSS,
 	MONITOR_FLAG_COOK_FRAMES	= 1<<NL80211_MNTR_FLAG_COOK_FRAMES,
+	MONITOR_FLAG_ACTIVE		= 1<<NL80211_MNTR_FLAG_ACTIVE,
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d1e48b5..d607848 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2413,6 +2413,8 @@ enum nl80211_survey_info {
  * @NL80211_MNTR_FLAG_OTHER_BSS: disable BSSID filtering
  * @NL80211_MNTR_FLAG_COOK_FRAMES: report frames after processing.
  *	overrides all other flags.
+ * @NL80211_MNTR_FLAG_ACTIVE: use the configured MAC address
+ *	and ACK incoming unicast packets.
  *
  * @__NL80211_MNTR_FLAG_AFTER_LAST: internal use
  * @NL80211_MNTR_FLAG_MAX: highest possible monitor flag
@@ -2424,6 +2426,7 @@ enum nl80211_mntr_flags {
 	NL80211_MNTR_FLAG_CONTROL,
 	NL80211_MNTR_FLAG_OTHER_BSS,
 	NL80211_MNTR_FLAG_COOK_FRAMES,
+	NL80211_MNTR_FLAG_ACTIVE,
 
 	/* keep last */
 	__NL80211_MNTR_FLAG_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dfdb5e6..500a6c5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2279,6 +2279,7 @@ static const struct nla_policy mntr_flags_policy[NL80211_MNTR_FLAG_MAX + 1] = {
 	[NL80211_MNTR_FLAG_CONTROL] = { .type = NLA_FLAG },
 	[NL80211_MNTR_FLAG_OTHER_BSS] = { .type = NLA_FLAG },
 	[NL80211_MNTR_FLAG_COOK_FRAMES] = { .type = NLA_FLAG },
+	[NL80211_MNTR_FLAG_ACTIVE] = { .type = NLA_FLAG },
 };
 
 static int parse_monitor_flags(struct nlattr *nla, u32 *mntrflags)
-- 
1.8.0.2

