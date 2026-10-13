Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF28D50256C
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896779; cv=none; b=G9c+6UNdVYo6yaTkTsvkWUnOt0vCvWAq0ZQ4pv03S+hmZw7foXag2C+LNJV79e+RdT2z0grRmNl7Hs+yWL0T2w8qCgtJXpnId6NwqWk3gohF71/kWHMqyJQSq8A8NzRO5nQzRM50Nt1CAaT3FpWl1qgal/mxag2MVD8jCiy6Kg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896779; c=relaxed/simple;
	bh=loOPB8PEDOmZSNjuwG+DD7sb/Zg8Wn/i7Ndsx+VepCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3RkP+BxO8DVtA1MSJ+I/wmwsNubbfdMKgo0gX7I9a/uxHTJ+ZHNkoOI9a4WJ9e1f/SEh4mtyiujz9AXQqSNSx6a8vLVvnX4blkY1/GYDVPzfRM3n6j6f7nTPwp084OaAo298P15llmbEu2sV0//zCf4W42ODgKbmiRU1kBFn/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=belgq8Oj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="belgq8Oj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=xlrZ4GVr4+/ZDHaGR0CNlY3GB5o7E+9H0rs+We8en/U=;
	t=1791896778; x=1793106378; b=belgq8OjVnvwyboZdUc8UXy3tg4V1PeZTESKR2zxBj+ru1t
	x4hCxo1fEtl9ki7ZvV5zAUw4R+lJ5Q0OBjybZI2UaT+8ntTxFh/TIzltezgpiO32Oh3hqdn5HLO6s
	IOeMZm+0wc/szENx/Xi98QsU/F5PrepeJIAu/9QnDYRRrH8UGEkmzc8se8uqv5EqBKbNU4IVmuX6o
	OLNRfKj0eZvzelezEbIkg5hXEE6Tw+xc+RAZQXzTWJF5nyjLLKZYtNmY3qyKTLK/0CFFxfMoQjCKH
	PKaVng3Qoq6d8Qqi5M+4mvrZRQlopGhMqOwkK36CN+MXRDznot0gx0cKI3vVWUBw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCt-0000000HPRi-2iaZ;
	Tue, 13 Oct 2026 15:06:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/11] wifi: mac80211: avoid tailroom accounting on new key installation
Date: Tue, 13 Oct 2026 14:59:12 +0200
Message-ID: <20261013150605.65fbe249d82e.Ie6b44dfeb421691898e1e181f38a6adfc780290d@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
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

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d32c61a90d93..caaea117d4e0 100644
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
 	if (new) {
 		spin_lock_bh(&sdata->local->key_lock);
 		list_add_tail(&new->list, &sdata->key_list);
@@ -1031,11 +1048,8 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
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
@@ -1087,7 +1101,7 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 		list_for_each_entry(key, &sdata->key_list, list) {
 			if (!(key->flags & KEY_FLAG_TAINTED))
 				increment_tailroom_need_count(sdata);
-			ieee80211_key_enable_hw_accel(key);
+			ieee80211_key_enable_hw_accel(key, true);
 		}
 	}
 }
@@ -1717,7 +1731,7 @@ int ieee80211_key_switch_links(struct ieee80211_sub_if_data *sdata,
 		    !(add_links_mask & BIT(key->conf.link_id)))
 			continue;
 
-		ret = ieee80211_key_enable_hw_accel(key);
+		ret = ieee80211_key_enable_hw_accel(key, true);
 		if (ret)
 			return ret;
 	}
-- 
2.56.0

