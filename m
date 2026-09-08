Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A3353A8AF
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870534; cv=none; b=kFoiPFcqN9NM9Lgx/h1KjJXI2FIGXkIg2qUPRrrDIaofRIsM6v3tU7m+Fvd1AOWWW8O6IBCX86MSZCtzT5/QoXCu9yEQD+xgo6heCrdtvTJAvg1rhmimWmNDyALYagUhreAXb/Xylar3JmkN5WnivicYX2glsBxfSzqvPKH+Pks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870534; c=relaxed/simple;
	bh=yf6mR1TEWdaNgmkpz2EmiQRVrd7ZiTf1+uOPCJZujss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpsJzrZh12Z9y+o655zpX8OOsLmK6VCMLQkTJgN6mLpiiGy/GirfySOWDa3Y0ZqTamdOLgnWB2oGoiZyJfOzWJNkbnpqWHbe2mjGt3uF1xnp0ulIMpuYju2cuyDjMpiuuEUt7e7I4gXDrBQixWU9N12p9va3smoYgm1Vfod9aDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KCZh04vj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KCZh04vj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SOZmcXmm8paFjeiiT8T73/BmfikpJUPYQTX1AgP17g0=;
	t=1788870532; x=1790080132; b=KCZh04vj8qlHEtFA8vg1TshvhZGjNUGlU9qayKjyGfF1vWd
	3uFjQ9haag2DcaLX/cIJI8xBNbYE1bY9kbwxP5CkYnOmZ5oHyhAcqwdOpRto82b8capEDsF4yn2HY
	ST45YUrYdjtYb26rod6QZ0x32GAPCkDRw/fcAOkhGTTAhAs0SGWEib8Kh9y1Z/eajcgms/xuUdRLV
	uJkep8qNXKsykLOCeMikz+L+8BOaL3IHWczw351jPGonU9qViVaYB86sehlTCrFr8Ay1UeExS1ALU
	YRhnOV//5PVFgsz7TqUckJ5ZK8jY9pR3JTSCX8DGF5yzLu5b37MNLAYMKpAK1l0A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwU-0000000670J-1tUw;
	Tue, 08 Sep 2026 14:28:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 08/10] wifi: mac80211: mesh: reset the CSA state when leaving
Date: Tue,  8 Sep 2026 14:28:19 +0200
Message-ID: <20260908122838.201719-20-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908122838.201719-12-johannes@sipsolutions.net>
References: <20260908122838.201719-12-johannes@sipsolutions.net>
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
Link: https://patch.msgid.link/20260904170057.86f8e0a996cc.Ib013eda6356cb548f29e04dfc7bf2c7a746b75a0@changeid
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

