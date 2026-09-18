Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0D33CC313
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 05:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789709229; cv=none; b=sCCUIg/15fiSYTzOIEDj5qvFSWNXkFY3amycKCsPj36SfWQ8k9bE2TPYJXjV6xh4CVBIeG6FJuL4AgV+QfIZKm4zv0lwlIoifI/BWF2aC8O7YpdOSsCUBh7TNxvwRHPJOF63CLffl3YYP4Mq0yKizFBzfc+zlagVFRl4kEj+bEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789709229; c=relaxed/simple;
	bh=zF1cy4zAIiJlYKAx23C9RLh4YJHdjCR6t56hrV6ljRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4yu9YWiUWnaLtiyCSHgh3Hj+0SeN2PZe2JQvqtKMbTbMMSxT4XWzpazGhFl3vCwTOIboHvlHzy3S6gSahTHuCUKDZV0ADkTPntzsQnJx2ent24fUEV+uXOZvpnf1VdRW3XfOd6KHZzMsylrTYQHGGN8J1CR04/X25qAUU+t1DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=oCfibUjn; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="oCfibUjn"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d90ba1d807so3848445ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 22:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789709226; x=1790314026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6JchP0x8f/tuUUe4XkYKSX5i3DSSetVi4XETDVTfDWE=;
        b=oCfibUjn1/ChpSfjfy25QIfbXp8i6/L1QOnwgE2up7L27fplhoeCxtI3v4JeCUCnOf
         Qnemm0cVeIzAqdNuAOKzPfB19F4B4/Wr2gRsgYGNNJBZ9OYQZzGJDPwufQzI3szMgPJM
         bKcWjDkArvSZEiYZGCZmiP9O2acHns5YFID8L6oKo8vuwXM382TY1wazT6DhMD2fu+gc
         jV2fCZHV2rkcYfhwz717KRao/BU3u0MmMI1dxCVUJYfT5aloSU0asaUkaVZhARYVa26O
         MXh9hNAD05AMsfcuRk7D/iBke+D9nKyY0eNNWKpRhLm3YA+Ak2hQvA5Lhu8ubzM93Rxt
         B+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789709226; x=1790314026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6JchP0x8f/tuUUe4XkYKSX5i3DSSetVi4XETDVTfDWE=;
        b=r8noRbbqJW1zRjxd7ZH0R0sn4TVNj+vLeeW8jHX6d7gG72OEYLbbhlAnsBY29r3hpt
         hPLf4hR3zFBdeG8BHuT4MMV2ckWX1RK0PRQLR+0lvbWmT+xLxjItMixGxfOQSVoj/dHX
         LO9u1SU4YLwTnxBjp1+rcgg7hG4Y770SISMrzNmz47AK12iRgNUxFSVa/dbBAFhHowkO
         gJ0FEmv2oYCjHGymPF1qRHaD9paw6SJtEGx+bQAof4eXuJ3SaslL3GQe6gJfunFC3PaM
         +IZMUb5tY30bsc5sgpEY+FUsbYTgeAmHUSc+rSZAKw3K7eDbugmHG+avs3iinGgrZVw1
         uOmQ==
X-Forwarded-Encrypted: i=1; AKwUvByP/kF+MdKoTrNe6CTwyaK91oEncW97PPG1p3mSALOMhGqtotuzlSJGsSLWMR34yLmEoWccaCnkXC1PSfusWw==@vger.kernel.org
X-Gm-Message-State: AFuF++kTbzodMhOgKchRNpvBIFTJ0mkMNojHWE7oQt6X6Q2eBGSFQgmF
	sGiihURTCFv7KAcuL3WNCYp0y9ShRXp8e/BllKoQonl34YnxrcYGC0q8D6PqERPxJDHy
X-Gm-Gg: AYBFou3KHttZAZjTUDQi/ZnrwGYv/6DAGaB4pqiQ+I/2Jjlc0pyW4HBhojZmPiyfaYu
	8fyTROTWedKXCpB99m6THu3C7ZCC/nz3jYHL2VnIhd7BjyNTf7BsiTBTnfAVJRz0+w14jKWbv0Y
	SGY5rUblYi/FZVdgmBjx8ncIRrzSDKl0iskr/g0aCxBng0PWp89Z2Ej/wTIRvNQ+Ksm8vggueTE
	Z2FVlJop+2KXhGZci7TR4Uw4w7Hoh5nDzggU48Cb2pLpGAIaQpFh/egL7nwfLAwrEE80DGZNw66
	DU88HjqgbUrsVdJssvZVEcx+OaMQzJgK0RsEaxnRr6ZNwKOXGNa34DyEguFNnCWmbG7XubhB/3J
	P/7Xrda1AObIowbb6MaUm3tN7K2PN4n5KL45K8ZRs5QPFdb0IDAc8ELa/ep58HUZ5J1KO3O8jlg
	28MZ6fx6jH1c2pcxAQrAVpL9Uqpjs8hDxMUydM452j5wmNdx+rEZYExsh+jBHgbi00kyfkzH9hR
	RKV9pdvsVbOh4vuO6MdQmdVkm3goQ==
X-Received: by 2002:a17:903:2ec3:b0:2dd:68a4:16f1 with SMTP id d9443c01a7336-2ddb1ade65bmr33394445ad.11.1789709226272;
        Thu, 17 Sep 2026 22:27:06 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75f2d3asm2122795ad.72.2026.09.17.22.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 22:27:05 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zihan Xi <zihanx@nebusec.ai>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>
Subject: [PATCH wireless v3 1/1] wifi: mac80211: fix mesh fast xmit path deletion UAF
Date: Fri, 18 Sep 2026 05:26:51 +0000
Message-ID: <1daa7a98199fe6965c2da7c42717073a6fd39a0b.1789615568.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789615568.git.zihanx@nebusec.ai>
References: <cover.1789615568.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mesh_fast_tx_cache() stores raw mesh_path pointers. Path deletion
flushes the cache and then frees the path with kfree_rcu(), but a
lookup that already holds the path can insert a new cache entry
after the flush. The cache then points at freed memory.

Set MESH_PATH_DELETED before flushing, and skip inserting a cache
entry if the path or MPP path is already deleted. Check this under
the cache walk lock so it is ordered with the flush. Use WRITE_ONCE()
for the deletion flag updates because the cache check reads flags
without taking state_lock.

Fixes: d5edb9ae8d56 ("wifi: mac80211: mesh fast xmit support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v3:
  - Use WRITE_ONCE() for both deletion-side MESH_PATH_DELETED updates
    to match the lockless READ_ONCE() checks.
  - v2 Link: https://lore.kernel.org/all/cover.1788930567.git.zihanx@nebusec.ai/
changes in v2:
  - Rewrite the commit message.
  - v1 Link: https://lore.kernel.org/all/94174303640c5e1022b31836770bad75f741afbf.1788845030.git.zihanx@nebusec.ai/

 net/mac80211/mesh_pathtbl.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 03171cf008557..fa5eac8f0c2ee 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -577,6 +577,12 @@ void mesh_fast_tx_cache(struct ieee80211_sub_if_data *sdata,
 		goto unlock_sta;
 
 	spin_lock(&cache->walk_lock);
+	if ((READ_ONCE(mpath->flags) & MESH_PATH_DELETED) ||
+	    (mppath && (READ_ONCE(mppath->flags) & MESH_PATH_DELETED))) {
+		kfree(entry);
+		goto unlock_cache;
+	}
+
 	prev = rhashtable_lookup_get_insert_fast(&cache->rht,
 						 &entry->rhash,
 						 fast_tx_rht_params);
@@ -798,7 +804,8 @@ static void mesh_path_free_rcu(struct mesh_table *tbl,
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
 
 	spin_lock_bh(&mpath->state_lock);
-	mpath->flags |= MESH_PATH_RESOLVING | MESH_PATH_DELETED;
+	WRITE_ONCE(mpath->flags,
+		   mpath->flags | MESH_PATH_RESOLVING | MESH_PATH_DELETED);
 	mesh_gate_del(tbl, mpath);
 	spin_unlock_bh(&mpath->state_lock);
 	timer_shutdown_sync(&mpath->timer);
@@ -812,6 +819,9 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mesh_path *mpath)
 {
 	hlist_del_rcu(&mpath->walk_list);
 	rhashtable_remove_fast(&tbl->rhead, &mpath->rhash, mesh_rht_params);
+	spin_lock_bh(&mpath->state_lock);
+	WRITE_ONCE(mpath->flags, mpath->flags | MESH_PATH_DELETED);
+	spin_unlock_bh(&mpath->state_lock);
 	if (tbl == &mpath->sdata->u.mesh.mpp_paths)
 		mesh_fast_tx_flush_addr(mpath->sdata, mpath->dst);
 	else
-- 
2.43.0

