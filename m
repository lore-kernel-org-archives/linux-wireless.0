Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CB3501F30
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896778; cv=none; b=FzPYkMMSuzTYRE14I3axFa4wjJX7Ez9/EtUz7LneZb1nYqNZoQ4G0YaDdAbYqQznPGqORVqVWryEUsB9Gqnm5hh1G5nj+aNDgopEoYFsZmRyVl1Bb2VWn+4tiIApgLAZmjUk8OGQa6tjoTlPBo9omZA4KmZBogfaBE/cFsjxICo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896778; c=relaxed/simple;
	bh=e9xPqzhLMQCUI+PMq39FU8/0rJNTI2iSy3yjanPPDRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmrmTx6+kjsXpQgjI9iOJDVO/ecYjqllDNkOXyhLoi9d40Xt1j5w3SCeowZy1VIylGLnV5dDvJFXjgzMamCq3/3StKcAnLzntZbFSX2HgNUI4lVjcHE2pkowvML9LuSvXPKOUEfguzMG5I/XvyOSK3tvuFQxQyVYU6WOt0FLnqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=GDhVc/9g; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="GDhVc/9g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=sI0hJtCHgUQ8IERATVMJOLI/C/hIkggWjl3/oLQxUJs=;
	t=1791896777; x=1793106377; b=GDhVc/9gxFcS5Dpd1VNCU4MamyWybo8Tef9hL+5P1vFlC50
	xL8+MrMYWw1na8ATwCjN/dR3H4SInJurQK9FFJtgMscFIPmtcVb0YALQkuSHuGgN1vg9V8r1RJrCR
	ew6NvefKFsOsXm8PhPWkW30Nl0hB8NiweADHe91G/vAJhwdQIb8KaCxrHGcewIDFGb1HfctKsT8na
	TC71s9eFiqdxWGaXZFQVsdCEQ52ye6TUf/05g9j+3H2AEdOm9YuBVCizeTZsGNMG+qDVvlMKLWYT0
	jL6PttRQDtlzbcDSPUG5qhwdQtbvdhK/zVQJ4ucTHwMvw56ya9xqLp8xNuEIQBhA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCt-0000000HPRi-0DkV;
	Tue, 13 Oct 2026 15:06:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/11] wifi: mac80211: refactor tailroom needed checks
Date: Tue, 13 Oct 2026 14:59:11 +0200
Message-ID: <20261013150605.c018564739a2.Ibe47133b0d3e04546b9a8346ad13f7f8bee32a25@changeid>
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

Whether a key needs TX tailroom reserved for it is open-coded in
several places as a test of the relevant flags. Create a small
helper function and use it instead.

The check for KEY_FLAG_UPLOADED_TO_HARDWARE is new in a few of
the places, but it's set appropriately there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 66bc8b1a4cbf..d32c61a90d93 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -118,6 +118,16 @@ static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
 	sdata->crypto_tx_tailroom_needed_cnt -= delta;
 }
 
+static bool ieee80211_key_needs_tailroom(struct ieee80211_key *key)
+{
+	if (key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
+			       IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
+			       IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
+		return true;
+
+	return !(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE);
+}
+
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata = key->sdata;
@@ -135,10 +145,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		 * so clear that flag now to avoid trying to remove
 		 * it again later.
 		 */
-		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
-		    !(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
-					 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
-					 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+		if (!ieee80211_key_needs_tailroom(key))
 			increment_tailroom_need_count(sdata);
 
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
@@ -204,9 +211,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (!(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
-					 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
-					 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+		if (!ieee80211_key_needs_tailroom(key))
 			decrease_tailroom_need_count(sdata, 1);
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
@@ -276,9 +281,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	    !(sdata->vif.active_links & BIT(key->conf.link_id)))
 		return;
 
-	if (!(key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
-				 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
-				 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+	if (!ieee80211_key_needs_tailroom(key))
 		increment_tailroom_need_count(sdata);
 
 	pubsta = sta ? &sta->sta : NULL;
@@ -612,9 +615,7 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		} else if (new->conf.link_id < 0 || !sdata->vif.active_links ||
 			 BIT(new->conf.link_id) & sdata->vif.active_links) {
 			new->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
-			if (!(new->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
-						 IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
-						 IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
+			if (!ieee80211_key_needs_tailroom(new))
 				decrease_tailroom_need_count(sdata, 1);
 		}
 	}
-- 
2.56.0

