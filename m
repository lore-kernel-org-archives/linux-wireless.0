Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCEE4E3ED9
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 11:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789558662; cv=none; b=I0VjxrPb9dTQnNax94PAMNnlYUd3AP/h8wH2gP0NJl09s/4WGt59JlDUE5yUimJIWWuWv1d1u1QJiPe6OiJ6TBBAxjcWtrbxdrojBK7cSNSDKdeTpoudda4HrG+wrm2cWtFc8PZ+guCpJrKdiUpfGBjoS+mt2gAx0QdGM+HUlyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789558662; c=relaxed/simple;
	bh=/Hc8uJtTDrUeU5cVZdc1ZyUkvgdb77Y94Nbtto9GWOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSnJqaVkhRHtvhC9LecZW4KhERNAYC114Z+vdGCEX+drKgo3mHiYLDzqWJOpV6BFIRuz5pimhPytIuai9UwKScjE1CZxTmTz8/qvSFnuYCbtj0vVx+Dq1XdnUV63Dkdi+1BvKF+uGDIdEPiJ800h4qKnkRJzT76BwsZQSPtDxSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TqbZiUiE; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TqbZiUiE"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d91ede8035so9284555ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 04:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789558643; x=1790163443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u71SukOk/uWqGG5KqXUmklLOaVffKeGeaoghUb9DD4k=;
        b=TqbZiUiEA+CMSix0qtFQKpx40D5mN8jlve96C1PqxDGY+d6GYO8iLxFXjeurGRkyW6
         b+sxAOZb21sPCeM35/2kNOpL3bbCbBMgyVOR4xpbRiZaMU292mcnMLEsbe1eqqtQ9qgw
         33kEn9KnAfzL3zwGhUVRM+atXUu7tkhIKfV6Fu/hy8dK7//TMVak8mOLH22gA35rFB0x
         KeiZ8kOoxsPPYFZXKlNhEhK7PoRTZ0szUCEaHp5X6b0vblxkLYeaDp3gYhu+lWx283R4
         9GIHlyueTiBghsTGtaZ1NLzRnNcvBFc7Z9Z+FtTEnif/ma7zlS1+LOakFJBLMJthUIBI
         pcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789558643; x=1790163443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u71SukOk/uWqGG5KqXUmklLOaVffKeGeaoghUb9DD4k=;
        b=MlZFCktf4FvCRveXKhHqRvzCeKCKGLqITMETQb1aem/4p2pOEn8/ejDU0gIBGJEmU+
         T3kvmix0Oo4gU0Qelhr7Ivli55/F03pQ3uAxFlcoJ1EE2OI0w/I17oMiauRc49E6LeBd
         gSFzHHkhk04CfhyTkQa595L/Pmzt41d60vAGk9CueTVP0sLQgkl9DDdy6qVsSesQnqSW
         19ztwHUxnsNFrqqGBFdDRT7e/ipM96x0If4HXUeiLxJSlAWPPqx7K2oErYlgef7tLKFw
         u46aM9WTD7qgmLQf3lFr83quWltxZHA88BdN5r1ZWdFnZMLa9qzbiMxZ4TiOw6rB5isl
         AhTQ==
X-Forwarded-Encrypted: i=1; AKwUvBz13Xyy2XfHZE2IC7gpciUnjAnTiF48q11qt8KDFKnbHM6VzVt2DLtN3cd8DMymWBhZATq+8YW6Lv47fuMCZg==@vger.kernel.org
X-Gm-Message-State: AFuF++lymGEG1vpzbaBX6ilahOQeebsjHnHEUn7saH5Je3IxSOZa9U4H
	2pZ831mRXGB/oyD2z8VWXbREN0hga+2H02BLcCXxdN/OOtlBp7hN1Wx0
X-Gm-Gg: AYBFou2cBxvUC5M5iavdJ2RNaot9sqBQ4UgRTN62gVIgR45ALzXW25srbccLv+rEzdm
	81zUstqxcapunZHq7oZ7vtxBBYE9sdrAgp5CPRi8C7SMV+Pf12UKgqR2VWt6DIKSAmdMzIpbvHY
	UQfkp7GHN/7v9Fcp1R5Dva4XmCMIB+vMUsy3zXc3TvOTxsxPWrS/luxbWYQTXQUzs1c/M+PJ4Y4
	7QkDaKTpkJxqabZIImGCPF0OVwGfZry4dmyQCxOutA63CXR50cfjhrIeCdLX2KLd3e371lkOprN
	OnhJUf7+Uwft0J9CYz8kVj5bcBbW+QbUH2kFxV8QhCuMLnB+BocVORQIrtlak0QvgEAav5hA8DI
	zPqeoWjAD7YXSc43a0qO7Rl4Yb7uot1mLxhM0H5ZJHAIAhAnsFiLW6tfhWYCQuzA4q7T3mGaMMo
	fV/nwAkF7FqDvP1RThMh4mWbgEkwWDiNZOv/eIL1iipj4ihFQf8Q/xw+t17NA8EefqNMhXaEKSx
	MEHlLpfilzkyySpR+gMQOVUY21UTWQVZA==
X-Received: by 2002:a17:903:1b67:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2dd8e51df8amr47363745ad.14.1789558642410;
        Wed, 16 Sep 2026 04:37:22 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f02fc2sm9927045ad.59.2026.09.16.04.37.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 04:37:21 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] wifi: mac80211: account proxy paths against the mesh path limit
Date: Wed, 16 Sep 2026 19:36:49 +0800
Message-ID: <20260916113649.28315-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916113649.28315-1-enderaoelyther@gmail.com>
References: <20260916113649.28315-1-enderaoelyther@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Proxy-path churn can drive the interface path counter negative and let
later mesh path additions exceed MESH_MAX_MPATHS.

mesh_path_free_rcu() decrements the interface mpaths counter for entries
from both the mesh and proxy path tables, but mpp_path_add() never
reserves a slot in that counter. Removing or expiring a proxy path
therefore returns a slot that was never charged.

mesh_path_add() uses the same counter to enforce MESH_MAX_MPATHS, so once
it falls below the number of installed paths the limit no longer holds.

Reserve the shared quota before allocating a proxy path and release it on
every unsuccessful addition. Mesh and proxy paths now share one
1024-entry budget, so mpp_path_add() can return -ENOSPC at that limit.

Fixes: ece1a2e7e860 ("mac80211: Remove mesh paths when an interface is removed")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation:
- GCC W=1 and Sparse C=2 produced no diagnostics.
- A controlled production-helper matrix drove the counter to -10 through
  proxy-path churn before the fix and kept it at zero after it. With 1023
  mesh paths and one proxy path installed, one further mesh addition
  exceeded the combined cap before the fix and returned -ENOSPC afterward.
- A two-point hwsim 802.11s run reached production mpp_path_add() from
  received address-extension mesh data. After one proxy install, the
  pre-patch counter was 2 and the fixed counter was 3 for the same three
  walk-list entries. No physical-radio or layer-3 success is claimed.

 net/mac80211/mesh_pathtbl.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 770fc16b439b..1c55b14c2ac0 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -736,10 +736,15 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(dst))
 		return -EOPNOTSUPP;
 
+	if (!atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS))
+		return -ENOSPC;
+
 	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
 
-	if (!new_mpath)
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.mesh.mpaths);
 		return -ENOMEM;
+	}
 
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
 	tbl = &sdata->u.mesh.mpp_paths;
@@ -752,10 +757,12 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
-	if (ret)
+	if (ret) {
 		kfree(new_mpath);
-	else
+		atomic_dec(&sdata->u.mesh.mpaths);
+	} else {
 		mesh_fast_tx_flush_addr(sdata, dst);
+	}
 
 	sdata->u.mesh.mpp_paths_generation++;
 	return ret;
-- 
2.55.0
