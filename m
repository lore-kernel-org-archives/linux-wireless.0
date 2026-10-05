Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EEB37F337
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233410; cv=none; b=aHDG8miwkmp0yQkJZW7k7Om09z714g84scnrG4BWyApZb22F3roDOeGpjf83Pk0F5BBB+5OrzB6H6SUIhGnbB/8zXHcltvhvzGPtG5ukLkpqcZn088zNrleRbAp4bIl3TpWbSJiUvV/2v+/jLDybNPf7h84gUPTynG1O5iXYmag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233410; c=relaxed/simple;
	bh=x6vK86dC1f9ihVnMFnqSDbkRJZnNhIisHqBtkAsZqFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOJmnDv38ERS0xr8NgeA15+1hXVUQKILVyz74Y11J5Uki7GUHMgDQHUkPZbM+uuX1ycuZLZnMKCHvi3TMO7cGMxDg3QiNNr//OVKfsp0fd9GGh+iwJn/caocw27y2G21jr+CeOp6NRZdcHEzFrcXWG1zE5VrdRVhSHQGCZ+dKrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=MfKRRKuV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="MfKRRKuV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=iIJ+g4SagNe3nM1YFHZe63dwW/jSNSnvJ/Z5zacwLbA=;
	t=1791233408; x=1792443008; b=MfKRRKuVCnMEbCwaQks4oX9c+PIUNXakGTtUokFufdl4FC6
	eJZ6bPYadUBXwsEL9FqyND+QjZtfYW6rwln7cB/x6iZnERCH6+b+nSfXyC77jqiWI1yka+HgCUCfA
	g5zxXTDd0f0prRi3fDCfyvHUoGHMCjus5tix7jbwzAkJvswr8hJro/IpWTk1uDXMv7O/JkM9wkqvd
	K8C6QsrAOx+VdgyxxrvE7dFMB2IS6pO/TztJob6LMnlcQUzgMoQVB+sRj+DWTe+J+CmfR8x8Jx8R0
	7XvMZoaCCMrR8UM3YLJo4LeZwifuZ/XrWbl10wu66MQJqLxTJ6mQcZ4cD2kBh7YA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdG-00000005cw8-1MJ5;
	Mon, 05 Oct 2026 22:49:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/10] wifi: mac80211: mesh: fix path table generation counters
Date: Mon,  5 Oct 2026 22:47:58 +0200
Message-ID: <20261005224950.373dd5c1e46a.I29b95bc3f62b846084700599a261a203a6e459b4@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005204950.2303430-12-johannes@sipsolutions.net>
References: <20261005204950.2303430-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The mesh and MPP path generation counters (for netlink)
are updated wrongly and sometimes unlocked. Fix those
issues.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_pathtbl.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 0485a979b3c2..dcb0a58e0fa9 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -711,8 +711,10 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	mpath = rhashtable_lookup_get_insert_fast(&tbl->rhead,
 						  &new_mpath->rhash,
 						  mesh_rht_params);
-	if (!mpath)
+	if (!mpath) {
 		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
+		sdata->u.mesh.mesh_paths_generation++;
+	}
 	spin_unlock_bh(&tbl->walk_lock);
 
 	if (mpath) {
@@ -725,7 +727,6 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 		new_mpath = mpath;
 	}
 
-	sdata->u.mesh.mesh_paths_generation++;
 	return new_mpath;
 }
 
@@ -760,8 +761,10 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	ret = rhashtable_lookup_insert_fast(&tbl->rhead,
 					    &new_mpath->rhash,
 					    mesh_rht_params);
-	if (!ret)
+	if (!ret) {
 		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
+		sdata->u.mesh.mpp_paths_generation++;
+	}
 	spin_unlock_bh(&tbl->walk_lock);
 
 	if (ret) {
@@ -771,7 +774,6 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		mesh_fast_tx_flush_addr(sdata, dst);
 	}
 
-	sdata->u.mesh.mpp_paths_generation++;
 	return ret;
 }
 
@@ -833,10 +835,13 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mesh_path *mpath)
 	spin_lock_bh(&mpath->state_lock);
 	WRITE_ONCE(mpath->flags, mpath->flags | MESH_PATH_DELETED);
 	spin_unlock_bh(&mpath->state_lock);
-	if (tbl == &mpath->sdata->u.mesh.mpp_paths)
+	if (tbl == &mpath->sdata->u.mesh.mpp_paths) {
+		mpath->sdata->u.mesh.mpp_paths_generation++;
 		mesh_fast_tx_flush_addr(mpath->sdata, mpath->dst);
-	else
+	} else {
+		mpath->sdata->u.mesh.mesh_paths_generation++;
 		mesh_fast_tx_flush_mpath(mpath);
+	}
 	mesh_path_free_rcu(tbl, mpath);
 }
 
@@ -944,14 +949,10 @@ static int table_path_del(struct mesh_table *tbl,
  */
 int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 {
-	int err;
-
 	/* flush relevant mpp entries first */
 	mpp_flush_by_proxy(sdata, addr);
 
-	err = table_path_del(&sdata->u.mesh.mesh_paths, sdata, addr);
-	sdata->u.mesh.mesh_paths_generation++;
-	return err;
+	return table_path_del(&sdata->u.mesh.mesh_paths, sdata, addr);
 }
 
 /**
-- 
2.55.0

