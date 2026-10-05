Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22FC380FDF
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233405; cv=none; b=IkOI/LeJ8FbDT1+hGj1+vL8GlV4LFhu16ANoMKQ40uA7WCMuCapwV0AkPagI/eC7Z/6IQO0KUX1H7bUHpFV2AW/Z9js0R09jvxx3yEkSFMGlk2qZ426IdH592kJsGhKtTQ0N2jpcUgroltFwurC98z1t+4ywDZk4bWv2ZE0xU9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233405; c=relaxed/simple;
	bh=mJEr4tsvIknqg3vx+Jy+OOnz9AhbTRNHPJS8ARGzCpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBlZ1dx1TUcIXV+AsAXYimeDeBtyEYAsRo/FRpm1yMNWkKVUV7beYLfhTxHOe1spt5CTl140UadXmjDwO915mVV8qud+Fa4OhwV1iw0K3zMy2IEZDfk0BJtJCboKvNKZoredAr7qzbXIbMyspzL7bz0dEBUPndZzOCMd/goBh2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LWJdVOYF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LWJdVOYF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kMDZ8VsgRmfrtNECWYzQTjGxJM3CAbvRKRK1sQ0YXsI=;
	t=1791233404; x=1792443004; b=LWJdVOYF21z2KKBM6Hv7XY8SaOWgeAwVjx1kETbkgZklbNe
	b3QofPjw6OEu/TQYJXziwbSegjmoJ6ylPHkpuG+i5YV+n3CAyoRx4EcrTF2wm4c37gOTFgvbTUbWo
	Qs8RXFtaMW5CrjG5qOzY565wWnUmkOIbXkmhNQtKUmFS8er9dXSjtw1VhBUttwEcxav3MD6RWkpWE
	Fp54Nf4jPJvDuEPYvf2y3Vb2P1pittEHHW5VCVarf5o0dcjm+B5s6xW8GdlXMC7uY+KW9KDjW1n0p
	sdLOcIpxk8qM5V6R7Q17PS8c3gMfqFmSaFA7/pO49vFNbMzQPea2rmd+4vUN2zSw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdC-00000005cw8-3TdV;
	Mon, 05 Oct 2026 22:49:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/10] wifi: mac80211: mesh: use hlist_add_head_rcu()
Date: Mon,  5 Oct 2026 22:47:53 +0200
Message-ID: <20261005224950.e0db543145e1.Ieaf30d3546e8ff63ccf400f6fb26e027c218721f@changeid>
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

The mesh paths walk list used under RCU, so we must use
hlist_add_head_rcu() to publish an entry. Fix one place
that didn't do that.

Assisted-by: LLM
Fixes: b4c3fbe63601 ("mac80211: Use linked list instead of rhashtable walk for mesh tables")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7b2f71186dfb..0485a979b3c2 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -712,7 +712,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 						  &new_mpath->rhash,
 						  mesh_rht_params);
 	if (!mpath)
-		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
+		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
 	if (mpath) {
-- 
2.55.0

