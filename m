Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A40B3A4F58
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 06:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933664; cv=none; b=qg75mK3GWO3lp0y68GvfDnBKxoh4U/Z+69lOc6xnONKCpKXccX889/RJg9cEoQG1keCAXJjxxWETh8BzasGDWzi9Fd/dz0JZ31aO7ZVM6BsDVuLun2Ryr9W2Cjx9yQ8DW19MdFOmW4WNeUicrDQgibKOCOc6CcIZtSyDYqcXWkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933664; c=relaxed/simple;
	bh=S/fzE7LggtKyXFVV+3o0QCAj32nkdP1715ppK3vGFKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zw9IKr1CYuaEZ6zRBwiOdySGdEUL06ZcXZGDXeesnGJOR6XUlcDgj6iPgyR83vyca8fT/H7+D2XzoRnmspcSV90274P1Rg73FWWXq7lT7DCK9REX3dU0DrLShrgUl0qHzZzN9Ew66Cz1OQGk2Y9Xi6PkXmzZsEFQqWOvNT0kcNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=IYORCHwA; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="IYORCHwA"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3964e480f76so6341290a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 23:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788933662; x=1789538462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gvow6oU4iq+0a+bBr6UukoAAqBxhHL+gKoXpK7iHJCA=;
        b=IYORCHwAfNY6VX+KYA/obNIlz/YoxYfiSw+BGBZqcxHhYDgs0yCT+uObG/8pGBvtEg
         e9DJE4PVljtrJ8Q1TqZc9T6rvEuQ7uctvtMjkgNM6Rjixdb/qmsQ/+dzrmgMMfOi7G4g
         nZXoZK0H4BRRpw0yB9SFLYgYmul/rMMBDy2V135anF5lzcbGQ6YLBqDRxguV6kVWhYSr
         TRgeb/hZou+7U1Bp03fJAapz4SbsWbX1RPXqFpVXRG20BAmCaLMPDiRoov0GCzIRBbU1
         ewAUs/8soSpyEmXBPdIZWd/BN6itUKi99PwbYDw7qf7MigiSa9s+IceGQC3E94Q3c+a9
         i6lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788933662; x=1789538462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gvow6oU4iq+0a+bBr6UukoAAqBxhHL+gKoXpK7iHJCA=;
        b=fp01ZZzh36rcacoMdxYQM0VhkfrSumBQXDtdOTpykPIKhzqAf0MMu+rgWNqSiHtpB2
         mfwSSMA54ZyjHH7gQd3dpWGSFziYpaLUi0gC81G4B+IRZv2ATVV1GOlX1QKM/gMo6TDs
         RhS8UHpYSv/0yCBWtReTFKwnHyIF/0mYkdjXfd+djz/fmWM9ptkg5ImEeW9+Q8MAMzwb
         7bPoO/ZQVM5iRBfaazGw64tR0kKn3z5g074S53oSSA3sQidvBGIk6zudRs/tgzRLCsyW
         twHm/uWsnwhmVftsAQA4S9dplIocsL4sSjppSNRQOMPklGJYEGKPb2DOpt/XMQPTIm5O
         6RmA==
X-Gm-Message-State: AFuF++mB6XBOwjA2BB33+V5yzSA8GHcmbE2oTT82cyoOKyi7yIYnyZOQ
	Qgav/U2aFxW9Lu6PXJM7uZCbv8xlRRKrcjPKP6mjPYOSa10oAw0l+hJONzqsQ9QGK95sMWChvkn
	aE7MDFg==
X-Gm-Gg: AYBFou2bqWeX8oYY6sIgUdW3aTmD2dV+DAVYDP87jMwWmPSMxrVcTsKwjbxcNMG7v3c
	UgRuw4/2BzdN1yEP0p7BAik92AKarzOaOe1xZuCedoytyjpr0rZrt93naL2AAGYP4NF98WKom8E
	qipxVlTHGdX0Aazkg7w+VjEN6gY+pnYfGyzuOJ8+8I1PSyVP0W6RJrKurIg38Z5b5nre/c6L2lh
	66OEnw3CSUTaXOEfkF1aKfmTb9oqyTuxR3/n5hf1uplMhL30+VS/V6U0pxzI5aloRAVLtNQJxQ6
	eHQ7z4NLTzH3+/3IAls4MOHV9GyYhxQwaDHrPwJMDVmzRF+J+3/optIP5Cd9pIANx9TZBgcCCMf
	NDAWpbKr/Tc55wFbek32C1RM7LmwL9qLgXbW5NpVDhFndYGVPL7Lx2zc1vBLvubRL7XAdsqiqyd
	+7k9N/jYABZJTiTIjEbqIgbUEmhwJ9T6nGoVymETZpWpqO3IaqeKHEOAEKzej7aNqGhgY77wGge
	BwNxDrekNqoCNflm/jDYYSMaqgfuQ==
X-Received: by 2002:a17:90a:dfcd:b0:396:4cbf:45a2 with SMTP id 98e67ed59e1d1-39b84cce5a8mr18859182a91.14.1788933662174;
        Tue, 08 Sep 2026 23:01:02 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39cfa44aee7sm662709a91.3.2026.09.08.23.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 23:01:01 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@nbd.name>,
	Ryder Lee <ryder.lee@mediatek.com>,
	linux-kernel@vger.kernel.org,
	Zihan Xi <zihanx@nebusec.ai>,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>
Subject: [PATCH wireless v2 1/1] wifi: mac80211: fix mesh fast xmit path deletion UAF
Date: Wed,  9 Sep 2026 06:00:46 +0000
Message-ID: <f0c01d0a6d7bdc3497dd62b69a884c00f0d8b78b.1788930567.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1788930567.git.zihanx@nebusec.ai>
References: <cover.1788930567.git.zihanx@nebusec.ai>
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
the cache walk lock so it is ordered with the flush.

Fixes: d5edb9ae8d56 ("wifi: mac80211: mesh fast xmit support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v2:
  - Rewrite the commit message.
  - v1 Link: https://lore.kernel.org/all/94174303640c5e1022b31836770bad75f741afbf.1788845030.git.zihanx@nebusec.ai/

 net/mac80211/mesh_pathtbl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 03171cf008557..dfcc4f3a7088e 100644
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
@@ -812,6 +818,9 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mesh_path *mpath)
 {
 	hlist_del_rcu(&mpath->walk_list);
 	rhashtable_remove_fast(&tbl->rhead, &mpath->rhash, mesh_rht_params);
+	spin_lock_bh(&mpath->state_lock);
+	mpath->flags |= MESH_PATH_DELETED;
+	spin_unlock_bh(&mpath->state_lock);
 	if (tbl == &mpath->sdata->u.mesh.mpp_paths)
 		mesh_fast_tx_flush_addr(mpath->sdata, mpath->dst);
 	else
-- 
2.43.0

