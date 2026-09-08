Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AE953CA62
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870532; cv=none; b=IPpa8iLO1S5I1fABwUtUR3dfqI3+Iu8iYgFt8aKEcSqA0jUWlZeRhFRYvDgmMQ8GTOLwzNULt9klzCe4N8hiMxOa9kpdDAbbO24M8sBoOceFsX0fZdPMNdoBOnmnsE9hToQZ+8xx9/XRQ+Akl6YpX3dG0pqCeM/cxQ+ZJsilQ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870532; c=relaxed/simple;
	bh=4OXmR1bMyWPg08tbk+SXiHlMo4G62a1KfgpUgTzq1K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcfKE3CiZmCg19eYPhjv3O8+LtCUERIwAvoHrowSX4nExhzwhWOGWHc/jDkie94F0axT5OuOV3c1LJAd1CsFyWLhtN185/hKmCimL6QzChhubiUs+BNiIuz7K3kLt5hmD5ChReahIUyA8jXUHnQYxwVpbQQH6kiM4nZHULijPUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LJHZLlaY; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LJHZLlaY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=GE0u50eThAoshL2roA+ocBJ3WiJ+68Zz0Xc/DI4VXvA=;
	t=1788870531; x=1790080131; b=LJHZLlaYKpHe5w9i8KZTTeO61mWJbqCEge8byz4VKXVRSJb
	QZkL6QA8vb6Hz6JHVUJrMS7P/gWxsy5ynYlgADig0O3GUjYT5O3WUt8dtrR9NMNHFR4By7sxkWe4n
	+QvIbKvz33lANXrPDKGhUysOkWftFwCQAY3mxYFC5Z51Ce44Z/CxrAZRT0b+Nyd4iCwO/oh3MmSwZ
	PpVYcUL+F2M+s6lbVGmRjJY6XSAjQHlgi6SfW01qn8+/0bPtbm2xgx/kAGBoWuiBl2PUXrO7HKbV1
	2ozHQuXcW+PTernefuRawDjTyREe9/6wGHPc723hgoacofFY7r2d6WQqgysFGIVw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwP-0000000670J-1xCq;
	Tue, 08 Sep 2026 14:28:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 05/10] wifi: mac80211: don't RCU-dereference the mesh CSA settings we just set
Date: Tue,  8 Sep 2026 14:28:16 +0200
Message-ID: <20260908122838.201719-17-johannes@sipsolutions.net>
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

In the error path of ieee80211_mesh_csa_beacon() the settings that were
just assigned are read back with rcu_dereference(), which lockdep then
complains about.

There's no need to read the pointer at all, tmp_csa_settings still is
the right value anyway.

Assisted-by: LLM
Fixes: b8456a14e9d2 ("{nl,cfg,mac}80211: implement mesh channel switch userspace API")
Reported-by: syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b59873f5699e941717ca
Link: https://patch.msgid.link/20260904170057.30c3a1780224.Ia633160bc01e1ad1b30a9f44446728a747f2b16a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index bed7ac838250..a35e2d5870b6 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1559,7 +1559,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.55.0

