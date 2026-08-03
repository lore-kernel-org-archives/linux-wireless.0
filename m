Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC479386572
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 04:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785730081; cv=none; b=gcNvwP5hp5gRwW7OmFT4FTf0peEXr3qC5nGHudYk+Iym7clwv86KsZd8tNz98UL2OUier4WKfPZ9pcyQohg+9bErzhAJZ48n1BuEJL7HATWTegPgfthsU0TzX6+9tEKRGZm6ibRO49I/aidZNkn+Z+1NVmTk5Otn+mMgwgHJg78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785730081; c=relaxed/simple;
	bh=bpSNGOSAM7T3dGw/BD8FMokVyey3cDpEeSAszqfjJtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqTqAxJAC4gC/FG/iu+PWfwdhfv/JQi6D6tqOu50bm64YSDNxAuAVV85HoWdQVQVkMHG2SDFwnFZKPZ/Jr79A1eJ+3pfQJEio/OS70k2qpx1TeXmtHdPhFXbtBcN63o5aLKmsLdKGSyzMW2AVLBaN0hu/j5y0iR1fjAl+tkj5yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=aeYYinIT; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="aeYYinIT"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so2386086b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 21:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785730079; x=1786334879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DaD5dMbB6ky6wqKaxOKLm5Hizp82EST6iCJrQodxqTQ=;
        b=aeYYinITk03d8C9PF6iYjDOEfrDyGpbkW8EsGJAMsAVz/UoskZYXpP++mLhy6+0FaT
         u8Z0nI69cyGeParyR6mXGkwqNmqbLits/Cv5JT59fk7QHtF7GPOJIfaDnOaTOaKFXZ3W
         M61MuameEbjIa/ocb4RSzGNWUJmeaX/HlwOVWiZwG/Ud9uNwaZrq0hyZfZtgdkVv6Usa
         Uz+wA86Ehk76XNB+OhksM9zRP3xD64vwV/lxUnpiEqmzf0Bu0T1L6u8KTy5FdlzAUcD9
         0ff7AfpqNC1Y2PhBReVgDZIWFixBG8kaDOLHcWoUuAfB98iwtL8PLwbpwLcmBd1I7QIZ
         j2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785730079; x=1786334879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DaD5dMbB6ky6wqKaxOKLm5Hizp82EST6iCJrQodxqTQ=;
        b=ryKSAraiGxSCwP3uIZxqLd3VV2Yengt7zHlSafK8J356gsZ0WKma/69kSAGogKvoxh
         ywEQ8amHpKMOWrCxs7Yok/u0d0/+O5GunlUQ8393d+yYEJFRKAy5K+EBr2vlzM8hGzX1
         srNgL9eGvgK9/WCatXMk7DcISt1RG0ndUrgpQeOVXglAEJjhDS+K5UhgT9tAs2siUtXK
         yTFUhkLjzVd1d4i+1grnzOu0tOTu8AoxUj67wdijSghp4ooPL+LI931/6efQHrjYotlu
         ipaTZ+7iCDJp698A53QpN13IJSo6eOptnQMxgbcV0mWCVgbM897R7rtjspoP6/fX1KAA
         82+A==
X-Gm-Message-State: AOJu0YxlJuamqeqz6hxyRg472JEKcujTHk2PMYR9iZUAX7Cwk29qpNL9
	v2YSq2VwIgDwRnLMx4LzAnT0QISpXZ6E6v9OZc4gbHfZh9GfMb6IxoFBETFnIUQwIdGhQ4wegpp
	2qXeqz6mn0sNJAA==
X-Gm-Gg: AR+sD12yRc1nXxQRflWcX0T88TOUKA6rR3Hg3uzrNVVlXAiwnW/8ag4U/m0CtGLAu0I
	zzAljnTi7yDDeL64rqWBAm6A4GKN3nnl/H3bVvpwhL9uJXIxyy9oC9qporlshJD+Ddiipue566L
	RjAMbYJ0zUA9HmX5eXhkQADNOgm2ajZgPt1ahdP1klVgGO+rmBk7mIJ4flV1+gk23gugJ8C7arh
	0J69/QEaYLnoX1C8e0/5kNH3JQ3dYlohYv0Y+IAUA8p0CZaRNJaOVaHWX5hSkiMmqcwRLdyhudh
	Sc89B1t1wJocjTeRQj+8GOQF5kERJpCAHMAuFDL5eACJvW3dU1Gi1TBl3fJsX9EEx8KM4QqO1JK
	5Hl1DRQAlUmFtSzpZPtSBNt8pRA2ycPFpGSXb6NCfgR9GGnvV2gq01AvMj0zw3yTSCowQnM3TeT
	ixDqCGoNP88zCne3oStCS25kLk4JJjRKLQ4SujW7F/qdOcO5IH9e8C/U7SEUBjSFdeFPnD6daSo
	A==
X-Received: by 2002:a05:6a00:22d5:b0:848:2f74:1d63 with SMTP id d2e1a72fcca58-84ee49820efmr7739650b3a.73.1785730079038;
        Sun, 02 Aug 2026 21:07:59 -0700 (PDT)
Received: from Roxy.localdomain ([202.8.9.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbe791dfsm3119723b3a.23.2026.08.02.21.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 21:07:58 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	gregory.greenman@intel.com,
	miriam.rachel.korenblit@intel.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 1/1] wifi: mac80211: serialize debugfs netdev rename with recreate
Date: Mon,  3 Aug 2026 12:07:40 +0800
Message-ID: <76eecaf74ca2d4e4aedf46c3ee7505917433468b.1785729184.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785729184.git.zhilinz@nebusec.ai>
References: <cover.1785729184.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_debugfs_rename_netdev() renames sdata->vif.debugfs_dir
without sharing synchronization with ieee80211_debugfs_recreate_netdev().
When MLO link updates switch an interface to or from MLO, the recreate
path can remove and rebuild that dentry while a concurrent netdev rename
still uses the stale pointer.

Serialize the rename helper with the same wiphy mutex that protects the
recreate path so the dentry cannot be removed while debugfs_change_name()
is operating on it.

Fixes: c942398f95efb ("wifi: mac80211: handle debugfs when switching to/from MLO")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/mac80211/debugfs_netdev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index f3c6a41e49119..10f8d77852a1a 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -1024,7 +1024,13 @@ void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
 {
-	debugfs_change_name(sdata->vif.debugfs_dir, "netdev:%s", sdata->name);
+	struct dentry *dir;
+
+	wiphy_lock(sdata->local->hw.wiphy);
+	dir = sdata->vif.debugfs_dir;
+	if (dir)
+		debugfs_change_name(dir, "netdev:%s", sdata->name);
+	wiphy_unlock(sdata->local->hw.wiphy);
 }
 
 void ieee80211_debugfs_recreate_netdev(struct ieee80211_sub_if_data *sdata,
-- 
2.43.0

