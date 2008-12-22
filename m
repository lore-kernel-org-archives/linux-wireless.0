Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25150 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYLVSVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 13:21:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 10:21:17 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 12/18] mac80211: no need for ht.enabled
Date: Mon, 22 Dec 2008 10:20:33 -0800
Message-ID: <1229970039-10561-13-git-send-email-lrodriguez@atheros.com> (sfid-20081222_193906_503167_F2A7D825)
In-Reply-To: <1229970039-10561-12-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-3-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-4-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-5-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-6-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-7-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-8-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-9-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-10-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-11-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-12-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can simply use conf_is_ht() check where needed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h |    1 -
 net/mac80211/ht.c      |    3 +--
 net/mac80211/main.c    |   10 ----------
 net/mac80211/mlme.c    |    1 -
 4 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ee2b75e..b51caab 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -509,7 +509,6 @@ static inline int __deprecated __IEEE80211_CONF_SHORT_SLOT_TIME(void)
 #define IEEE80211_CONF_SHORT_SLOT_TIME (__IEEE80211_CONF_SHORT_SLOT_TIME())
 
 struct ieee80211_ht_conf {
-	bool enabled;
 	enum nl80211_channel_type channel_type;
 };
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 55bfe48..6314289 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -130,11 +130,10 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	ht_changed = local->hw.conf.ht.enabled != enable_ht ||
+	ht_changed = conf_is_ht(&local->hw.conf) != enable_ht ||
 		     channel_type != local->hw.conf.ht.channel_type;
 
 	local->oper_channel_type = channel_type;
-	local->hw.conf.ht.enabled = enable_ht;
 
 	if (ht_changed)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 24b1436..a6cb480 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -211,16 +211,6 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	    channel_type != local->hw.conf.ht.channel_type) {
 		local->hw.conf.channel = chan;
 		local->hw.conf.ht.channel_type = channel_type;
-		switch (channel_type) {
-		case NL80211_CHAN_NO_HT:
-			local->hw.conf.ht.enabled = false;
-			break;
-		case NL80211_CHAN_HT20:
-		case NL80211_CHAN_HT40MINUS:
-		case NL80211_CHAN_HT40PLUS:
-			local->hw.conf.ht.enabled = true;
-			break;
-		}
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c75d0ea..6558209 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -874,7 +874,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_unlock();
 
-	local->hw.conf.ht.enabled = false;
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	config_changed |= IEEE80211_CONF_CHANGE_HT;
 
-- 
1.6.1.rc3.51.g5832d

