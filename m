Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42B84EBAF1
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534083; cv=none; b=V5WaE2lc2jlCjETnK1OwmcIX3Re/5HT5T5R/JcbNJ6bl55GweJZsxq28tk8DlzLeOlNc7QXdHcYEFb7C7nFT79wZc4om4QEXib3fSCPPGYMXjmPxu282lXjPCRZorS6wix8hy7zMAGvqFWFoPqqaNnHmDFVkvfrhRmxqbxt8jWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534083; c=relaxed/simple;
	bh=8PLmwACzfN21rz+mqQgkVcG+YQGgS2F+zaouKPDXiOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caOnvCsx7n2ieleB9bHqb8tYluqmWQvK6q2LYWxGXyNqDIHu2bwIjn3PYddCdpuEEYuu7tlmVSt8H1tw0nxbtzqff//ivim5PPr6JSPrTQXFCY2lyX3TgHcQruAiuYxo67ShK8SgABNHp+PVG3f9WJRkEag6vyfkUbI3NNmuSnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=svJFKMwJ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="svJFKMwJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=mNzQFSZFVNo6pVemN12csmt+0/ELg3TclhYhlPp4GWI=;
	t=1788534081; x=1789743681; b=svJFKMwJYyTKp2FD8fJ1Kv+M4T6FLHjS+O/kUDX58rGZpNf
	oCnXs8TooXEMRhrRx+RLYjXVcUleMiKu+6Fcmji074GSJulQXgSCFTylBpaa1iKJURVV7Z75M6zem
	GnK6C/HO7RpREm/kKjYtgsHl+/x73lIZ/iEsUImawpSYbcfUDmpv5KNgrL4iKqM9Py6cNe4t5SbZo
	9Q5FHYUga+QFEJEyASCmQQyhovbsh5LF88XolllmVwIXrG5fDv3hQe1gywFbyXDhCqkwuflhctFmm
	Nx/W+wLKuSosd8Bge5x7n9humtXYHVwxzXEcdir618Wshmz3KeAy40suuUzjJamw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPp-00000001SeL-3tdu;
	Fri, 04 Sep 2026 17:01:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Subject: [PATCH wireless 08/10] wifi: mac80211: mesh: reset the CSA state when leaving
Date: Fri,  4 Sep 2026 16:58:07 +0200
Message-ID: <20260904170057.86f8e0a996cc.Ib013eda6356cb548f29e04dfc7bf2c7a746b75a0@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150057.424369-12-johannes@sipsolutions.net>
References: <20260904150057.424369-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ifmsh->csa is allocated in ieee80211_mesh_csa_beacon() and only freed
in ieee80211_mesh_finish_csa(), i.e. when the channel switch completes.
Leaving the mesh while a switch is still pending therefore leaks it.

Additionally, ifmsh->csa_role and ifmsh->chsw_ttl have their state leak
in this case, so things can get mixed up in addition to the memory
leak.

Refactor the reset and call it in ieee80211_stop_mesh() to fix it all.

Assisted-by: LLM
Reported-by: syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f5752cd6b94fe38be666
Fixes: b8456a14e9d2 ("{nl,cfg,mac}80211: implement mesh channel switch userspace API")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a35e2d5870b6..8f8814125375 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1196,6 +1196,21 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
+static void ieee80211_mesh_reset_csa(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_csa_settings *csa;
+
+	/* Reset the TTL value and Initiator flag */
+	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
+	ifmsh->chsw_ttl = 0;
+
+	/* Remove the CSA and MCSP elements from the beacon */
+	csa = sdata_dereference(ifmsh->csa, sdata);
+	RCU_INIT_POINTER(ifmsh->csa, NULL);
+	kfree_rcu(csa, rcu_head);
+}
+
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -1206,6 +1221,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	/* abort any running channel switch */
 	sdata->vif.bss_conf.csa_active = false;
+	ieee80211_mesh_reset_csa(sdata);
 	ieee80211_vif_unblock_queues_csa(sdata);
 
 	/* flush STAs and mpaths on this iface */
@@ -1514,19 +1530,10 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata, u64 *changed)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct mesh_csa_settings *tmp_csa_settings;
-	int ret = 0;
+	int ret;
 
-	/* Reset the TTL value and Initiator flag */
-	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
-	ifmsh->chsw_ttl = 0;
+	ieee80211_mesh_reset_csa(sdata);
 
-	/* Remove the CSA and MCSP elements from the beacon */
-	tmp_csa_settings = sdata_dereference(ifmsh->csa, sdata);
-	RCU_INIT_POINTER(ifmsh->csa, NULL);
-	if (tmp_csa_settings)
-		kfree_rcu(tmp_csa_settings, rcu_head);
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret)
 		return -EINVAL;
-- 
2.55.0

