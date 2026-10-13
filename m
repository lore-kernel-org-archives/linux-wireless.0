Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D1D331EBC
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897021; cv=none; b=BaphYkZ/8+bJNJ1rtoTj/sCR6yuZ5DuPzSIi1otVSjGmA1u7UFbWWaJ4J85vn4F5tR72UHkr1wqDxh3kTWD3Z4nBPxF6JnJIawt9A6jSFeM60orXmyHq3tA3uA+zLbahdrB38MeZAWBFQe5/Wr4VwUOeElmgbJxXD+7SkXyEvjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897021; c=relaxed/simple;
	bh=v4ysSe3gSlZGVIRnrJgx8c2l0n9kMRiyS9+fB/9ED/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=suLLQW8plUeGUqIViphwfl3Y66VD6sSbBR2pR39Bkr/lbzagDh1EyBzeThhVNFQGQqgnnxLtHWJJ3ekTUurspQiXUCgtQWEmLBhviiAhF8nV2U3HUdfLhZJ2fDhRaJVRYLwJuNCN0+NyM2BUIIvE4JoOw5qZNnP2h7JEJ2v0DPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=u12vowJU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="u12vowJU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=0hl2wKYCK3ME9MRMAKzm02Bw2Qkd/1H2/DG6X41e3zc=; t=1791897020; x=1793106620; 
	b=u12vowJUGgtwS6Q9fBQ5OhnY71zOO41+CjznuQBpwo932nSndbnQhdiaMkhSQGe9iZ756tWANFx
	91iDpg902ANq0OnsDekJ0rNJsKiHHD8XKjbRmAbIt33nEbFdi5grISgyEmrE9e718LHj4caTqOGlg
	Ryc0A2jUpN4y1I56CwyEfWO8c9X3pr4+IOFnjl9ESDneKj78n+2a0yp/M4/DdLpMKcmbMCy4TN4l+
	wquN1IxeZEmAFyaRF5yOQ8GB7vU5fYUjvoTV6tSjk0hW0Ln2ykbDobnsG66D4YXCIrve7z1eqyCA5
	ZCcqKx0VDW3Mu6+CKc9pZiR9h7cebrAitN+w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcGm-0000000HPhK-2zFT;
	Tue, 13 Oct 2026 15:10:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: mac80211: add and use ieee80211_tu_to_ktime()
Date: Tue, 13 Oct 2026 15:10:14 +0200
Message-ID: <20261013151014.663e3b267a90.I84c31881c92065edc0716db81a5d7c416af9f32d@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Doing us_to_ktime(ieee80211_tu_to_usec(...)) gets pretty
long. Now that we use hrtimers more we have more uses of
ktime_t. Add a helper function for conversions to it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 10 ++++++++++
 net/mac80211/mlme.c       |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 66f9ebe79c61..67aef610b15a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2571,6 +2571,16 @@ static inline unsigned long ieee80211_tu_to_usec(unsigned long tu)
 	return 1024 * tu;
 }
 
+/**
+ * ieee80211_tu_to_ktime - convert time units (TU) to ktime_t
+ * @tu: the TUs
+ * Return: the time value converted to ktime_t (nanoseconds)
+ */
+static inline ktime_t ieee80211_tu_to_ktime(unsigned long tu)
+{
+	return us_to_ktime(ieee80211_tu_to_usec(tu));
+}
+
 static inline bool __ieee80211_check_tim(const struct ieee80211_tim_ie *tim,
 					 u8 tim_len, u16 aid)
 {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index eebdd8a12f52..5d97595f311a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3533,7 +3533,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_link_data *link,
 	/* we may have to handle timeout for deactivated link in software */
 	now = ktime_get_boottime();
 	csa_time_tu = (max_t(int, csa_ie.count, 1) - 1) * link->conf->beacon_int;
-	link->u.mgd.csa.time = now + us_to_ktime(ieee80211_tu_to_usec(csa_time_tu));
+	link->u.mgd.csa.time = now + ieee80211_tu_to_ktime(csa_time_tu);
 
 	if (ieee80211_vif_link_active(&sdata->vif, link->link_id) &&
 	    local->ops->channel_switch) {
@@ -7844,7 +7844,7 @@ static void ieee80211_ml_reconfiguration(struct ieee80211_sub_if_data *sdata,
 	sdata->u.mgd.removed_links = removed_links;
 	wiphy_hrtimer_work_queue(sdata->local->hw.wiphy,
 				 &sdata->u.mgd.ml_reconf_work,
-				 us_to_ktime(ieee80211_tu_to_usec(delay)));
+				 ieee80211_tu_to_ktime(delay));
 }
 
 static int ieee80211_ttlm_set_links(struct ieee80211_sub_if_data *sdata,
-- 
2.56.0

