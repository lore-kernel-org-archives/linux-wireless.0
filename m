Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448D33EB7F4
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 05:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790055785; cv=none; b=WnSjP9uu+UXmIPr6+uQdhTXjiTvKHT3X3AINcQ9HrCWXmG9+ATxGNbOwArq2IJoL+i9ToECfZUTTNLht2x7Iq3WLaGGCavksc4brXAt/JSUWJer6pIwwEjw5LSX4fBnlfVnNWro8ZH/0q/NulWBAHD+Vz2+Try6Ctz8McyqEa3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790055785; c=relaxed/simple;
	bh=qaR7d/zM90YPWHcOm3TYV77R2th6xdwLV93lEheSkeY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uQ5pxOUNQ1HsjIaRkineb9+XNEaGdqsia4gG1klj/VybKrn0RsUP5JfLP4x/3430VC9wXEzK1KioKeBEr029KepkC93oMuDZ1fGB/XawkRc28FK3qkdHVoESPT4TEgcmUJryiaNrZpwJX9ENhNQ94l3+MAW26GCuVbjnda4O1Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ie8Cb0ip; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ie8Cb0ip"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea4c79fso1602495a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 22:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790055778; x=1790660578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ss6yyG18xKmL3ChDu352XFK2c5fShKuGkPx5v64MPyE=;
        b=Ie8Cb0ipIlW8LQAyMJbvlxNypO48a+OIbWvEEkf2WdnZBuDaGyECiL3u5+4TcReJBx
         dD6YS3eAV/KQrqStDLASXBrbTxavOWlYf4Skkky9x2eYjmihfsXzGuQ78yQPrpC/mjL5
         wGPUTUJgWHG3plmCEs5PWNVjCqa+C2EkcJRvTvUQ/sS9gGxkkTxatVOLYkbi2FtMX4Ul
         suL0fGq0aMVOWWwjvckYR6qEvqTua7Ook8HxO1E50ajJMdr5oI8wKnJ6luyvev6F3XAx
         iUmfA0ahdydFxSV7yZuxktdePP0k3MVgJZedAhFnXIk/S8ade2Cg91IbnRuhymHVvmnt
         +JQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055778; x=1790660578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ss6yyG18xKmL3ChDu352XFK2c5fShKuGkPx5v64MPyE=;
        b=LcrKV8bQ1T/s7QUu7FISdv06VAcu0WfZdnFTyw9d9xZ0X1I05UAFx2K0FwutKYAUqb
         DhnrKM9TdoKW7P33Xhs9rutKLihP9ab4MKtJ8iv9fzqCFfMj2w2KYNvgVCCt4xFEGOcy
         Wnl4XloWGRo4YITYE/8wbCMiQR+vhbJrnMGF4O+STGOJ1RoH8c6XvlDzkVqLKvPNtOYV
         ArgpvOWxnaJ/hTClZxANhfKFrSLQOcBr7zxt0sYrBgqo8OXG1B8bMDt539Wjg3JuygWM
         9vuF8T4igCfWDt4bInFJxpzYSnumUMKbULPzd26gXTcNDcExaXJlwzK+BEMhORT6lSa7
         x6pA==
X-Gm-Message-State: AFuF++l11m2HY8Siil5PMQKQCCSeSXiXfR39ZI815a/0CND7WzymUXh/
	vRyWU4rUoWgp1qSwv3j2g/zR6vYLk6wrleNO3IGGg5Lxl94U3j/OsZd0
X-Gm-Gg: AYBFou0fo47IH1S/RItCdeKN76cuwPHu+hoir/7rCMraNdfXghNNWM5GOc5zNFe4XYG
	NdfmiXAZhx6/fPjmRA8F5kwh2Ah06BxDdSQ9skj4k76qly3oJfOm+crysKg6Qn2/t/giZmPKvBG
	Xi71yeHT/jIKTTQUdH6nDvgjJuddP8DH0rZb0CTfZ5uxzrPdG78SCYuzRwhMgjcC9IyCeD8VGWN
	ZiRX4nNJ67PepoeZag3AK+czQ13CjfjuxOUNe6pb4iqsJrGCe3EhyBWJLRicI3F/UcRmXHTEdc6
	RfkylNFdF4sbVAmCgkYvlz1jJZGFoVjjhndT70mM81+tuZn1VYAonXxpk6wJirQSGxZYvNrwJu2
	Kd4cITZwkToUSN14yGimUMdm2bgO/X8XhgqO/jI5h/5lyIcBwD1Jx3v3dgoMxkZxDsesZIrmDdq
	Sm3qMgkFGR4ISf8qY9/92dfGc3I5v63pVJM1EJs8UOQShM/ytyUj0/GakqG7WlzDwrZQFhzUIX3
	J6GwhN/84NWxl27N/apX4YRhmRso+lB
X-Received: by 2002:a05:6a21:9185:b0:3dd:d91d:e2c2 with SMTP id adf61e73a8af0-3ddec7c94fbmr77047637.48.1790055778001;
        Mon, 21 Sep 2026 22:42:58 -0700 (PDT)
Received: from localhost.localdomain ([202.189.109.160])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc756a317d7sm295136a12.16.2026.09.21.22.42.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 22:42:57 -0700 (PDT)
From: Ginger Li <ginger.jzllee@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: Fix a race when expiring a mesh path
Date: Tue, 22 Sep 2026 13:42:53 +0800
Message-ID: <20260922054253.11976-1-ginger.jzllee@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My static analyzer identified a potential issue in 'net/mac80211/mesh_pathtbl.c':
mpath_expired() reads mpath->flags and mpath->exp_time without holding
mpath->state_lock, while mesh_path_fix_nexthop() and the other writers update
both fields under that lock.  In mpath_lookup() and
__mesh_path_lookup_by_idx() the unlocked check is followed by taking the lock
and clearing MESH_PATH_ACTIVE, so the check and the update are not atomic:

CPU0 (mpath_lookup)                    CPU1 (mesh_path_fix_nexthop)
  mpath_expired() reads the stale
  flags/exp_time and returns true
                                        spin_lock_bh(&mpath->state_lock)
                                        mpath->exp_time = 0;
                                        mpath->flags = FIXED|SN_VALID;
                                        mesh_path_activate(mpath);
                                        spin_unlock_bh(&mpath->state_lock)
  spin_lock_bh(&mpath->state_lock)
  mpath->flags &= ~MESH_PATH_ACTIVE;
  spin_unlock_bh(&mpath->state_lock)

A path which mesh_path_fix_nexthop() has just set up as MESH_PATH_FIXED and
MESH_PATH_ACTIVE then has MESH_PATH_ACTIVE cleared again, and forwarding to
that destination silently stops.

Take mpath->state_lock before evaluating mpath_expired() so that the check and
the clearing of MESH_PATH_ACTIVE are atomic with respect to the writers.

Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
---
 net/mac80211/mesh_pathtbl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -247,9 +247,10 @@ static struct mesh_path *mpath_lookup(struct mesh_tabl
 
 	mpath = rhashtable_lookup(&tbl->rhead, dst, mesh_rht_params);
 
-	if (mpath && mpath_expired(mpath)) {
+	if (mpath) {
 		spin_lock_bh(&mpath->state_lock);
-		mpath->flags &= ~MESH_PATH_ACTIVE;
+		if (mpath_expired(mpath))
+			mpath->flags &= ~MESH_PATH_ACTIVE;
 		spin_unlock_bh(&mpath->state_lock);
 	}
 	return mpath;
@@ -290,11 +291,11 @@ __mesh_path_lookup_by_idx(struct mesh_table *tbl, int 
 	if (!mpath)
 		return NULL;
 
-	if (mpath_expired(mpath)) {
-		spin_lock_bh(&mpath->state_lock);
+	spin_lock_bh(&mpath->state_lock);
+	if (mpath_expired(mpath))
 		mpath->flags &= ~MESH_PATH_ACTIVE;
-		spin_unlock_bh(&mpath->state_lock);
-	}
+	spin_unlock_bh(&mpath->state_lock);
+
 	return mpath;
 }
 
-- 
2.43.0

