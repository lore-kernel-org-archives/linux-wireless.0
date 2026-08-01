Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526533624DE
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571120; cv=none; b=tBDT57dHTSNTJWNb6AY/qoyuE1Nl0wjTNCh0qZ3KOgW98PV/Z1g8DMGYHrWuK5FpB/iKLxyZc67y3iNKN6Dnk0VSG4HtdHm+hXUNUwLi1PKWzuqIfVTrGhwTxOGgHCVSx9VjRmkXMXH6OlXZcyycbnTVV9hCqNnCbymUqYNVvKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571120; c=relaxed/simple;
	bh=G2cUXBhTQtk6wm26+thH4tTzKp2H/U5GCjtfa2jUYWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYhGVlTh6Tc5hkgD3RiE1naQfd7LncGsPyajKboo17K64k4xCEirJO//NwoamhK3vQhV52Mq8K5ftphInRRXQc2q3xwfHYfZWGNAyfPKJa0Anqr0GNHEPkgXSMfFz8V/0XAPBtDRr8CEekBcsYrVHREiiq6Svnl5SR4JDPgKOM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=SNxejdQ/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="SNxejdQ/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5PrRCUz0eOr6XtfpHaBmCxCZqozfI3ThTkQ3ynzc3R4=;
	t=1785571117; x=1786780717; b=SNxejdQ/MCY0TaecqEWeSourGQCXgucWZ3YOgDUYIw2yP4J
	ef+ljiA2ZM2yuQm3mKniN0IRl9zco83Z8ZoCmT7LANwkOofpeeJJ25bpSAUKlfhq7XP8tdSE4r8+h
	hxP/C1BlocNmTh1CjNq2RjojOPPeKuFWeVL6bxZS/Az3nzGtYlIh2EFJo3zt3aEFIok06ugaHjH+C
	gxgwxSDwz3UnaDEjZnPSt42Tq+Rhwxssptq7Y+FlUIdUW38JuQkl0kwsSe3CooY+lNpQyJQN0wMys
	pBmz+pmdibnEI/zCkrYtATcUAx3+iRE0sJrt69ZRZ/EZqdAhjGJAJ8NqPn7temZQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4c7-0000000ErOv-0Dhl;
	Sat, 01 Aug 2026 09:58:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 11/12] wifi: mac80211: avoid tailroom accounting on new key installation
Date: Sat,  1 Aug 2026 09:58:27 +0200
Message-ID: <20260801095822.734db8e294f5.Ie6b44dfeb421691898e1e181f38a6adfc780290d@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801075822.645974-14-johannes@sipsolutions.net>
References: <20260801075822.645974-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

On a new key installation, going from not having a key to
now having one, we currently synchronize_net() because the
key is first assumed to be handled in software (requiring
tailroom allocation, and that requires not transmitting a
packet without enough tailroom, hence synchronization). It
is then offloaded, usually not requiring tailroom anymore.

During a new key installation, however, it's actually not
the case that this is needed, since the key only becomes
reachable to the TX path _after_ being installed into the
hardware.

Restructure the code so that the increment/decrement of
the tailroom counter is skipped for newly installed keys.

In the case of rekeying, this doesn't work since the old
key is removed from hardware and may still be reachable
by software, so the tailroom counter still increments to
one until the old key is destroyed. This could be avoided
with more effort, requiring tracking more precisely if a
key is even used for TX at any given time.

Assisted-by: GithubCopilot:Claude-Opus-4.8
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index fafc44329606..ab92014f67ef 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -128,7 +128,8 @@ static bool ieee80211_key_needs_tailroom(struct ieee80211_key *key)
 	return !(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE);
 }
 
-static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
+static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key,
+					 bool update_tailroom)
 {
 	struct ieee80211_sub_if_data *sdata = key->sdata;
 	struct sta_info *sta;
@@ -145,7 +146,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		 * so clear that flag now to avoid trying to remove
 		 * it again later.
 		 */
-		if (!ieee80211_key_needs_tailroom(key))
+		if (update_tailroom && !ieee80211_key_needs_tailroom(key))
 			increment_tailroom_need_count(sdata);
 
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
@@ -211,7 +212,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!ieee80211_key_needs_tailroom(key))
+		if (update_tailroom && !ieee80211_key_needs_tailroom(key))
 			decrease_tailroom_need_count(sdata, 1);
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
@@ -607,22 +608,38 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 			ieee80211_key_disable_hw_accel(old);
 
 			if (new)
-				ret = ieee80211_key_enable_hw_accel(new);
+				ret = ieee80211_key_enable_hw_accel(new, false);
 		}
 	} else {
 		if (!local->wowlan) {
-			ret = ieee80211_key_enable_hw_accel(new);
+			ret = ieee80211_key_enable_hw_accel(new, false);
 		} else if (new->conf.link_id < 0 || !sdata->vif.active_links ||
 			 BIT(new->conf.link_id) & sdata->vif.active_links) {
 			new->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
-			if (!ieee80211_key_needs_tailroom(new))
-				decrease_tailroom_need_count(sdata, 1);
 		}
 	}
 
 	if (ret)
 		return ret;
 
+	/*
+	 * The new key only becomes reachable by the TX path - and can thus
+	 * require software crypto tailroom - once it is assigned to the slot
+	 * (possibly not even then, depending on the key and default key, but
+	 * that's too complex to handle here).
+	 *
+	 * This is after it was installed in the device, so that the device
+	 * has it when it's used.
+	 *
+	 * This means that we can do the tailroom-needed accounting here and
+	 * only ever call increment_tailroom_need_count() if needed now, in
+	 * case it's fully offloaded it's not actually needed.
+	 *
+	 * This avoids the RCU synchronize on first key installation.
+	 */
+	if (new && ieee80211_key_needs_tailroom(new))
+		increment_tailroom_need_count(sdata);
+
 	if (new)
 		list_add_tail_rcu(&new->list, &sdata->key_list);
 
@@ -1019,11 +1036,8 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	increment_tailroom_need_count(sdata);
-
 	ret = ieee80211_key_replace(sdata, slot, old_key, key);
 	if (ret) {
-		decrease_tailroom_need_count(sdata, 1);
 		key->local = NULL;
 		key->sdata = NULL;
 		goto out;
@@ -1075,7 +1089,7 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 		list_for_each_entry(key, &sdata->key_list, list) {
 			if (!(key->flags & KEY_FLAG_TAINTED))
 				increment_tailroom_need_count(sdata);
-			ieee80211_key_enable_hw_accel(key);
+			ieee80211_key_enable_hw_accel(key, true);
 		}
 	}
 }
@@ -1687,7 +1701,7 @@ int ieee80211_key_switch_links(struct ieee80211_sub_if_data *sdata,
 		    !(add_links_mask & BIT(key->conf.link_id)))
 			continue;
 
-		ret = ieee80211_key_enable_hw_accel(key);
+		ret = ieee80211_key_enable_hw_accel(key, true);
 		if (ret)
 			return ret;
 	}
-- 
2.55.0

