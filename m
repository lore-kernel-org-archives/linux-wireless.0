Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3170A36197C
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571118; cv=none; b=VP6CKeQvmlcO2r1iDc4aH7jaNnstRa8FDvjMf3hFOb6FFdy6h9qnk9OBd4JAzeBs2xoI4GkGr3qboGCBm6icAaSO/cBX3ElBecwYzaXq0I5ElLg36fiQtS5e3HSbafDCAc5vaXtYqMJHQVSvLtG7khrT4BoGQq1CmPUH8LPSt6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571118; c=relaxed/simple;
	bh=LaoeFL5xnWkQbhfAZxC6318AvCASSnhbnbeMyaG3huo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUFmpXuVptLFW/jSueTRtgDayfs8mFL081BSe4ZOGGwUIr6k3/nEUJ88VyMT/Rng8MzA+/97zFQ5b/IQO7D5ZpfPsaRJSYQyg+G8WJFX31aUyGDLjaoSBLMAMWx/EAU9dpjaLR1e2LWY9N8EvSCjN5PgnOCuf1Wnw49aRM1Rp/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Z3/eWLVS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Z3/eWLVS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KP6CM2+2cLvLxJ7o4ybrv1tLrhVAYHXGcMxHjRLhPps=;
	t=1785571117; x=1786780717; b=Z3/eWLVS0zdYXI/X3XtxqQ95PuHE8opLaMBMYjErZtycgMv
	5tyAfR8MB/O4Tv3zekGpF5LY5qa2jWcr6KaqDSKcf8P4P10KMSLaGi1yk3WisNkh4zK4HJ5d88B33
	S0QWuBCRrEdjCq+ICZm+782dknGBjm9CErnB8dTqPmW4/Ch0TV9Qhaq5Nk3nuJ8+VjJ2XlE5yGs4l
	ouraFevk6dkPMiBA+9bsbb988tnldc9adP0xsetNJPQHDM8KX3mUB+olZQ+Gm6IZvRv7emR0D/x20
	w2YxJ6/7NGpgNRl1GRwRgYbq50+6rlfwbYQA9v9esXEsnO48gC5lwriwQRpWFTAA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4c6-0000000ErOv-15yU;
	Sat, 01 Aug 2026 09:58:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 10/12] wifi: mac80211: refactor tailroom needed checks
Date: Sat,  1 Aug 2026 09:58:26 +0200
Message-ID: <20260801095822.8536224493fd.Ibe47133b0d3e04546b9a8346ad13f7f8bee32a25@changeid>
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
index 1226f64b3a97..fafc44329606 100644
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
2.55.0

