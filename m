Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDE24908A6
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792009414; cv=none; b=clROBHnfZ6xoikpvCejC64h6SxoSjO6MqrLtPGUaOzH+YiRzBZhoUknZcVHxV3g0MNXryCUL+UvZmp5YO1QCyNVkV/M0FmZoHO5Uy+tYofZQ2b2BaiZT7p00lL6t+jx7utvoxm8crLwxd+qpR+yFG4gtw+RJ94uT70+90wVRPh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792009414; c=relaxed/simple;
	bh=OG2Z9fl5mj9EnMwTwetlb3+yc9wVfd8RP9l+D/zN2Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzsWf4VLLTDa5Yx6sYtCLdDGf4nPvlZS1KnCGt7OlKdh3cbZDUBTNIHJyoWh484kSNWhiDNs2sE3G6KaRGRV3r99z3FmBXGb113uBWXdHsZ02C4xwaF5ZReY1SZy04Xq+TfrMDZ1oCaQv+1pbZDnzexRKorkbaPdlcCk8nutpYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=XELsxThx; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="XELsxThx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SW496R3vOw2pQsWRgHdfOkCB7UTsgCc4J7+4G4BBSbg=;
	t=1792009413; x=1793219013; b=XELsxThxBcJfw08seLr42Y4ZHuZGcn1OpKSLf7wog5euXkG
	d4vq7plXUM0KUZIMtJ9UvbDC1n+YTN9x3UOH2uhnwbRl97ouFJwBRQnJAtOxQLJ5j1SATqG//nDLv
	ih4rLABJMta2AFlDc/GYbUuBIsxKiPV4AdrSUyE4Z7jVASQl7W47EE/0qd8kCemVWXZy2BFJF9Y3w
	V2CJWDSpw9ljGyGwFNawMMfKlIReAOKQUc88W1SuTItwS3CfuWXJBQ9S6ubXyrhGMS97ZjK2B4MmC
	eAq4Xv6RQvfJfoFaxgPPo2+3e4vDr7j0HGX/8weNQ0FWrmCyeyTfkgFs3TZF23+Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xH5VZ-0000000254S-1jjx;
	Wed, 14 Oct 2026 22:23:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 2/2] wifi: mac80211: remove force_synchronize from ieee80211_free_keys()
Date: Wed, 14 Oct 2026 22:23:25 +0200
Message-ID: <20261014222324.9bae146bfedd.I8d6d1ca4d1c7c1d1b937422c3ad596d2e8545c0a@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014222324.2c196424ccd3.Ieaf95b8e1336f07866f54d174f699c6aa079d9b8@changeid>
References: <20261014222324.2c196424ccd3.Ieaf95b8e1336f07866f54d174f699c6aa079d9b8@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The only reason for the force_synchronize here was for some
callers to amortize their own synchronize_rcu() with the one
required for keys, but keys no longer require one. Clean up
the argument.

It seems like this should require some callers to call it
themselves, but the original user was do_stop(), which now
has its own (again) anyway to ensure no frames go to the SKB
queue before purging it. See commit 7907c7d33c37 ("mac80211:
free all AP/VLAN keys at once") for the move into key code.

The other callers (AP_VLAN, NAN, mesh) didn't really care
at all, so we can just drop the argument.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 14 ++++----------
 net/mac80211/key.c   |  5 +----
 net/mac80211/key.h   |  3 +--
 net/mac80211/mesh.c  |  2 +-
 4 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 581a5d57e560..8bfd6bc9c9fe 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -614,8 +614,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 	case NL80211_IFTYPE_AP_VLAN:
 		list_del(&sdata->u.vlan.list);
 		RCU_INIT_POINTER(sdata->vif.bss_conf.chanctx_conf, NULL);
-		/* see comment in the default case below */
-		ieee80211_free_keys(sdata, true);
+		ieee80211_free_keys(sdata);
 		/* increased by AP value on ifup, so reset on ifdown */
 		sdata->crypto_tx_tailroom_needed_cnt = 0;
 		/* no need to tell driver */
@@ -662,7 +661,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		 * Free the remaining keys that might be associated with the
 		 * NAN interface, e.g., IGTK and BIGTK used for Tx.
 		 */
-		ieee80211_free_keys(sdata, true);
+		ieee80211_free_keys(sdata);
 		break;
 	case NL80211_IFTYPE_NAN_DATA:
 		RCU_INIT_POINTER(sdata->u.nan_data.nmi, NULL);
@@ -674,13 +673,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		 * Free the remaining keys, if there are any
 		 * (which can happen in AP mode if userspace sets
 		 * keys before the interface is operating)
-		 *
-		 * Force the key freeing to always synchronize_net()
-		 * to wait for the RX path in case it is using this
-		 * interface enqueuing frames at this very time on
-		 * another CPU.
 		 */
-		ieee80211_free_keys(sdata, true);
+		ieee80211_free_keys(sdata);
 		skb_queue_purge(&sdata->skb_queue);
 		skb_queue_purge(&sdata->status_queue);
 	}
@@ -906,7 +900,7 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 		wiphy_work_cancel(sdata->local->hw.wiphy, &sdata->work);
 
 	/* free extra data */
-	ieee80211_free_keys(sdata, false);
+	ieee80211_free_keys(sdata);
 
 	ieee80211_debugfs_remove_netdev(sdata);
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index b66168edab25..d1e3fe37d2e3 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -1229,8 +1229,7 @@ void ieee80211_free_key_list(struct ieee80211_local *local,
 		ieee80211_key_destroy(key);
 }
 
-void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
-			 bool force_synchronize)
+void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *vlan;
@@ -1252,8 +1251,6 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 
 	WARN_ON(!list_empty(&sdata->key_list));
 
-	if (force_synchronize)
-		synchronize_net();
 	list_for_each_entry_safe(key, tmp, &keys, list)
 		ieee80211_key_destroy(key);
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index b7afd6c90eb0..9f13d175623a 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -205,8 +205,7 @@ void ieee80211_remove_link_keys(struct ieee80211_link_data *link,
 				struct list_head *keys);
 void ieee80211_free_key_list(struct ieee80211_local *local,
 			     struct list_head *keys);
-void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
-			 bool force_synchronize);
+void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
 void ieee80211_unlink_link_sta_keys(struct ieee80211_local *local,
 				    struct link_sta_info *link_sta);
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8f8814125375..5f523e14cf84 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1226,7 +1226,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata, -1);
-	ieee80211_free_keys(sdata, true);
+	ieee80211_free_keys(sdata);
 	mesh_path_flush_by_iface(sdata);
 
 	/* stop the beacon */
-- 
2.56.0

