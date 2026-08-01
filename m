Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFB2369D74
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571118; cv=none; b=luoOjNvI48fYmJKzq3Qahq3XhQ7Kb5wBMRqkCFGHWAvKfoH3AUhuQ1vjj+7RoqCmgMAL4IvxYFkOXzXCD0nH9lGZc8m7m6o9mqhG12PEmDJmpKb0/eY9111mYGLjbLU6VbNFp0M3AkZOLe+u4+qb0nH8etp02xpN8j/JuJZYiWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571118; c=relaxed/simple;
	bh=CJoYYzr4KpCy4Zk+/hz928tR+Bc5gVoZKe3lbXF1O9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cC82PuDxU1UYmwJcRfvxwH9dpJanxBVQkXfeN4SfGeazW8PcKRQLexACuvsSya0CRK/tox47ikRIQbdjfH2StbbhQLPiusJ9Y8wAbAFpEvzODnjmiF8p0s2uOGzkpkqBKiBuFevwrrEwdC90YAgekztuXwISfOhx/+PVidpF9pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bYTxKx4S; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bYTxKx4S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=bxIdnB0rt19HGntovV08TNZ1kcRhOm8XEkznxu0aZOw=;
	t=1785571117; x=1786780717; b=bYTxKx4SHGLhbrfIjSHKppOZn5dskfFFp5nmxu4fU0qj8m4
	icV+g7ei+TqvIcTYROcLLwVTvJOTyBlsTXPY9ROm7Ljpr5MRJTjJa49gK6cz6W/QqdavZEujO5u5L
	ie93Uh3QzI6oQkIeQZ71+Bk24VKZbLxLLT/++V9AFhF0ea50PHtUIYDwRC7agxsmKq7cfn6skpvhU
	VLFFcEX8sYe802afUhmsn4lMsfMOfRkXfrbSCkgjceUJs2Fqs8KrKRQM5p9FMW1QFL81ZYouDIO+M
	oaha+2AbmHiKPQK7yt8kkQQcj8HTMwhq3x1ENcURq1Q+F54ociPFEz9ENK+9VcDA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4c0-0000000ErOv-3Bcb;
	Sat, 01 Aug 2026 09:58:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 04/12] wifi: iwlwifi: mld: cope with different key/sta ordering
Date: Sat,  1 Aug 2026 09:58:20 +0200
Message-ID: <20260801095822.a243ae7dba8f.Ib27388f723fdedf6bc327fe5617ddcc49efd36b2@changeid>
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

In a subsequent patch, mac80211 will remove group keys
while the station is removed, not after. The workarounds
in the driver fail with that, adjust them now.

Later, we can let drivers opt in to know the station of
a client-side group key, and remove all of this code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/key.c      |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 14 +++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mld/sta.c      |  7 -------
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/key.c b/drivers/net/wireless/intel/iwlwifi/mld/key.c
index bf80b4770b5a..126ce5fa2b0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/key.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/key.c
@@ -354,8 +354,8 @@ static void iwl_mld_remove_ap_keys_iter(struct ieee80211_hw *hw,
 	if (key->hw_key_idx == STA_KEY_IDX_INVALID)
 		return;
 
-	/* All the pairwise keys should have been removed by now */
-	if (WARN_ON(sta))
+	/* only remove group keys */
+	if (sta)
 		return;
 
 	if (key->link_id >= 0 && key->link_id != data->link_id)
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 3a4c8fda68d0..13e21fdd1953 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2564,10 +2564,22 @@ static void iwl_mld_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 	 * on further RCU synchronisation after the sta_state()
 	 * callback deleted the station.
 	 */
-	for_each_mld_link_sta(mld_sta, mld_link_sta, link_id)
+
+	for_each_mld_link_sta(mld_sta, mld_link_sta, link_id) {
 		RCU_INIT_POINTER(mld->fw_id_to_link_sta[mld_link_sta->fw_id],
 				 NULL);
 
+		/*
+		 * mac80211 will remove the group keys during the STA
+		 * removal, but then we don't have the AP STA as we've
+		 * already NULLed the pointer below, and thus we cannot
+		 * remove the keys properly from FW since we need the
+		 * station ID. Remove them all here to be able to.
+		 */
+		if (sta == mld_vif->ap_sta)
+			iwl_mld_remove_ap_keys(mld, vif, sta, link_id);
+	}
+
 	if (sta == mld_vif->ap_sta)
 		mld_vif->ap_sta = NULL;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index 7957ac11b0cd..727f005c4a35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -915,13 +915,6 @@ void iwl_mld_remove_sta(struct iwl_mld *mld, struct ieee80211_sta *sta)
 		iwl_mld_remove_txq(mld, sta->txq[i]);
 
 	for_each_sta_active_link(vif, sta, link_sta, link_id) {
-		/* Mac8011 will remove the groupwise keys after the sta is
-		 * removed, but FW expects all the keys to be removed before
-		 * the STA is, so remove them all here.
-		 */
-		if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
-			iwl_mld_remove_ap_keys(mld, vif, sta, link_id);
-
 		/* Remove the link_sta */
 		iwl_mld_remove_link_sta(mld, link_sta);
 	}
-- 
2.55.0

