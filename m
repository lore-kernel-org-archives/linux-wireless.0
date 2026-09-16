Received: from mail-pj2-f31.google.com (mail-pj2-f31.google.com [74.125.227.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C7E48A8A3
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 11:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789558657; cv=none; b=UQPGWKnDjbt2+cShssCqewCmOq9oCWCI4qBQ8UagbhuyaORIEg9eq0NPpfVSHHD2oENAFhDQb2Xi2Yo00ftNQ9ovY30DcmFwKnKSDf8W5J98PXghJC3Tey85sKdWCfosD0BVv9H6ZZeEj/+gVLDb74ESkl/4na5/BcHSnt4mR5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789558657; c=relaxed/simple;
	bh=3uaObKhY36qkdLUb4pvRy/Y7taGooeBUyJJlfhXMPyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTlBosRd+cVmUTRbuAKMzZuagxwvvEzdbJ1+WQIUmqGN89s1iUOSXqERPTjLAMXbhlk5tkMOnGVDmQKx5xuIdiff0BNsMZIFZF7uLLqvmnzVobkmiy4tLzo6bpcgKPZxgEYKu1ktRD5eJA9eGoilSza5g5h+eCw1J5oft4A2lbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8N5Jcs3; arc=none smtp.client-ip=74.125.227.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8N5Jcs3"
Received: by mail-pj2-f31.google.com with SMTP id d9443c01a7336-2dd53691be5so8005715ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 04:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789558638; x=1790163438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oOQF8lSD7wdJvBSJlzI6UX4BPG3ivMWDQsQe23mQk7c=;
        b=X8N5Jcs3hPDyXmeaSlRypDxXcs9LPre+NLB/t6soDQBJyMteLrs00qojbyXgS3gjIQ
         353omtc5s0xw4Tg/EKD9jPpIkoPccKwqDzAqnrVjPGOexvVO1Lkufq5V9XzL7FEMKjCc
         up5//J5YvW1fYOW71km9urGjABEhVqvK5NGzpwwU+mMpKJxJ/6l2hbLPOLX6iCAMzGQ5
         PiF7m+8vUcopxDQV2qjQNhZNxEu9M6DCgs2vmWfh2E3M2DWda3+Lo9B0oSqVIjgD5p9c
         c2IWu6S6/aIHMDXzJlylkMCI7Op2QMY2/7u8Rs+Ur35ZE4vY86Rskasa0W2iazpydER1
         dk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789558638; x=1790163438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oOQF8lSD7wdJvBSJlzI6UX4BPG3ivMWDQsQe23mQk7c=;
        b=eHgpABVW6H+JvtmZb8AY6IIECGU70LYeP+Wq/LWYeIEKyjcQBO5zbKr2ihdxRVmiKQ
         WRSBjRNi/WL7kTWDNswA6jTIVbsxQUjvHuTWZBFtWSNQZazIMM0Sk0+e8GTfSmHGV1H4
         P/JwuVuKBIx9agn6URaO3h/evQYBseG2rp38Cm6PhHNCmJcghFTyRXV2skDo12RUjiX0
         +wQzZazjYS28+X+Rwq6KqYS+KPDPdoUBACX+g8LQoD0ScJO9IOGvusITej56Rrr3VJ5g
         i+P1OVFvWYnWSVsRJaYTxlWhF5qNsulJp0ajhjjZsKT2Ygr/Q6lRCoXl3gwa0YMOiseK
         6uTQ==
X-Forwarded-Encrypted: i=1; AKwUvBxAoMaC7RJEOX0eu7C7RJtetvKVhIr7zWgvDTks7T8zqfDJkqpXPl64MmCLJgukwNAvT1g4XJxvUNrXWtXhWg==@vger.kernel.org
X-Gm-Message-State: AFuF++mlQNca3TItbHHFp8nNNistkvY9ZKHTcVf56LK62wsIQcmAHrje
	0fxxKhawo3c2/4HkD/xzYImOVGk/CzmE5z+ojWStjltnRgFqAVKmmu8D
X-Gm-Gg: AYBFou2xu4hh0e1p8ei6zUUPKwaqYXyAtIUN2mUewW+7M2zp2FnTxuYLAT97v5wtb50
	Mq9YmMB13OBHiUXmS+XGsmlXsA4uOtOKaY7r6SQuWnRKm35eeyb8MUJttQCocGMiqBajFdNqhNN
	+IVuoE6DFn6GLj3M+5wXDHGYxKGbkkAv3iTr/phpvvqa6AbvRfJYQw8/tGnaqQFEW6s52DVfupo
	JVyiPrq/6Azn791LVxKD9UdBpPLa5Ge0YDdq8u+IY52JkkYOAZclEJF00ympdGORwPTCQYWSY9d
	V967EhTWcaCQDARvMDoxjRgfUWKnogUOyD9+/00gCPP0Kzr/y7nHyPOqCpxQk3PEoYK0sJOjA7f
	CpuzyWbUtG8cXiWdqN7rxVMaUO/eVD+5oybvMLrFEWjAaVK+BwWaDoFyrzgm6vA4iz5uj8LQkXm
	S7wE9Ud0suLosbd94lCMbPsuLw6qC4k98vMx5vDDjCbIq1RngSWUO7ZP/rDFzXtjqKRz92w9Vz4
	Ok9M55EL0DasBv1YNwJH6edl1dpFYDKuQ==
X-Received: by 2002:a17:903:46c7:b0:2db:8ae7:a5d2 with SMTP id d9443c01a7336-2dd8e026db9mr44702525ad.9.1789558638056;
        Wed, 16 Sep 2026 04:37:18 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f02fc2sm9927045ad.59.2026.09.16.04.37.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 04:37:17 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] wifi: mac80211: release mesh path quota on failed additions
Date: Wed, 16 Sep 2026 19:36:48 +0800
Message-ID: <20260916113649.28315-2-enderaoelyther@gmail.com>
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

Repeated failed or duplicate mesh path additions can exhaust
MESH_MAX_MPATHS while the path table holds fewer paths, which stops new
paths to reachable destinations from being created.

mesh_path_add() reserves a slot before allocating and inserting a path.
If allocation fails, the function returns without releasing the slot. If
the rhashtable insertion reports an error or an existing destination, the
function discards its candidate but retains the reservation. No new path
is installed in any of these cases.

Release the reservation whenever the candidate is not installed.

Fixes: ae76eef027f7 ("mac80211: return new mpath from mesh_path_add()")
Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation:
- GCC W=1 and Sparse C=2 produced no diagnostics.
- A controlled production-helper matrix reproduced the allocation,
  insertion, and duplicate reservation leaks. Allocation and insertion
  errors used test-only fault injection; 24/24 concurrent same-destination
  trials leaked a reservation before the fix and 0/24 after. That case used
  no forced-failure hook.
- A two-point hwsim 802.11s run reached production mesh_path_add() from
  mesh_nexthop_resolve() and hwmp_route_info_get() during PREQ/PREP
  processing. No physical-radio or layer-3 success is claimed.

 net/mac80211/mesh_pathtbl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 03171cf00855..770fc16b439b 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -694,8 +694,10 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 		return ERR_PTR(-ENOSPC);
 
 	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
-	if (!new_mpath)
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.mesh.mpaths);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
@@ -708,6 +710,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 
 	if (mpath) {
 		kfree(new_mpath);
+		atomic_dec(&sdata->u.mesh.mpaths);
 
 		if (IS_ERR(mpath))
 			return mpath;
-- 
2.55.0
