Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6EC355F49
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 15:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252528; cv=none; b=uMhEeTwMO8wMnj1wO/hJnTpaUU7fHMePUYe0j8ZzEWKgf5BgAoMe0ReKH7qoP+D0IQjOiBZCgL8gfXU/oBvTyLCptDBnxy+0G0p3UXFK87sKtXgTUuck1K8uQuHOzoY6CtGHUYUp7mvrliShtA0MLDxLRP6WADTuITkK5Ma2WPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252528; c=relaxed/simple;
	bh=fwQoOeDTQlTNDSNEsy/uQhba2KTo2Yu1gAYTjfEPrE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOjv5ZzZMoEyUw+JQrW8SF8lVceCMr7X/dZ4rON66AVZYT9u4Y1LVsq3UjcI3t3MsbH8uS7ws1gOgaJUaXjgCvKGANpgjZljuvU4TKSQbeZ9gJAqN5CXoKke0k8utnrKG1jHlHPWM65h9xdj6jfaz8dfhGQh3K0tjzEdvBNqrpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BngkCo81; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BngkCo81"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a16af2a232so6436205e9.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 08:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792252523; x=1792857323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QXeG/wl5F/jg0l6Xe/HSiMbiwMms1qM0ittRrXdiaCY=;
        b=BngkCo81hR9LoUynARC5DzL0MOm3z/89+iVt8NG8aKmUSvb5xx/3t12mJjgj/4hjgt
         vdTgRRnKOhEkXGQO8KBRCF0i1qaYt6yeYdYcF78O8mg5HhxiYl7wUsAUv3yWqbpyEzX2
         vrrKdMU9HPYMHbSDNn7w8APkHXvfbpfZenNzFK50RzzDxQPh9fvJymhvvchMMsJ1Asyf
         CHQrE9FDYOwRZrN0rcTFs0+05lyfhj0CETu0TlpTj1oSqD3rJRUS4o6uFsNDLoP/OeCk
         NuETrKYNXRKU4kGVDboR4HK7GYm+AFvJBaxHT3FY6eZDaBu9juTlM9XHHY4Vs5wbuA+F
         7fHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792252523; x=1792857323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QXeG/wl5F/jg0l6Xe/HSiMbiwMms1qM0ittRrXdiaCY=;
        b=FY7/k+DhQ4+YR67sQStz17i6xtSrCVQZntM4Raq87YilO/9lO4iVkEvxh5wFmQbdhK
         D9be0Uw0D6HiwBSsUkaXTJWEwgsk2zxHt5L+tbP/LoaSyvZ0pdN21/q7dU5vN9wfxxOj
         lbROC1+VzvH0xXCXX+eR7ZGP9Oq4QDjc5DgTVGaNcOh2g6I4aAb2cu80RqFFb+KqM2QB
         iPTatkS8iPZA3iAlAVpqd6YVTX4npNdPFtfIGm1164C4OoulErsBqhcN5zcsg4hPpCNn
         BebnAcVL5oxHDnQcWjLBARaiPiMsIEYk/QMH4eElqPNQfR9+Xf9egh8IMWZulXq+JSLc
         C46g==
X-Gm-Message-State: AFq9FYLcZ7FLS4uajCXnXjpIMAv4PftocBeeJOyL5CBdNPq4wKEU8vjw
	OK+7/I1/hXSDWwi5Nglv74ziZhFTBoeEwgB6NGjIrIfS03COMlnltQYj
X-Gm-Gg: AYBFou2fi6EaC5vYeNnqyRw5ln+R3ygjoWWVjkc4dENvJZL7UK0g9/rxhRvH/nBqF+g
	Vx5DPCnZHcqx3cJq6pBP1quq0b7l+foTLJgdgAhLLq8mwVb7MHcagrqbSCyD62WqP2KWrYdhG0Q
	i9vCHLeCLvklH8Ht/MRJwueWjEIQk62KLiOmMomewc+c+6n2ct0hvnghyC6tAMRX34Ns1+156Kq
	WCDkl+RSk+gAKWxXmCdfpH+qL1dZMnH78IRDwTaXUoPHrfgghNx3uo7p4muKhcXB+R//ekTR1WQ
	7XvSZy8JNvYrN8XbmsiQPyofdZYaC8gXmNkycqqbj/uiXFa4Ug8b7iOBbH3I4ORK7rq8UCcIBl4
	Ci7iMQvequc2ZmPNhdPrH7mJvUH77rtsfizyPsTA9OLCG5SYefD9G+q7xjVnG1yTphuIbVpMSaE
	B920cDIJSeF+5zjAIrGZAgv98SH4hs5soOGgzLUT0rCiPYm0psPwZU5K51QUNQ1NgYIewGq2wt+
	hOKVySR
X-Received: by 2002:a05:600c:3b91:b0:4a1:e0b7:ff09 with SMTP id 5b1f17b1804b1-4a1e0b80060mr7487875e9.33.1792252522454;
        Sat, 17 Oct 2026 08:55:22 -0700 (PDT)
Received: from potato ([31.176.162.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1dea678cdsm42335505e9.1.2026.10.17.08.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 08:55:22 -0700 (PDT)
From: Omer El Idrissi <omer.e.idrissi@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Omer El Idrissi <omer.e.idrissi@gmail.com>
Subject: [PATCH 1/2] mac80211: move static function from header to referenced file
Date: Sat, 17 Oct 2026 17:55:08 +0200
Message-ID: <20261017155509.128114-2-omer.e.idrissi@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
References: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move static function from header file to only c file it's used in.

Signed-off-by: Omer El Idrissi <omer.e.idrissi@gmail.com>
---
 net/mac80211/debugfs.c    | 15 +++++++++++++++
 net/mac80211/driver-ops.h | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index e38631d7cfb4..cce8aab1dfa6 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -589,6 +589,21 @@ DEBUGFS_READONLY_FILE_OPS(misc);
 
 /* statistics stuff */
 
+static inline int drv_get_stats(struct ieee80211_local *local,
+				struct ieee80211_low_level_stats *stats)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (local->ops->get_stats)
+		ret = local->ops->get_stats(&local->hw, stats);
+	trace_drv_get_stats(local, stats, ret);
+
+	return ret;
+}
+
 static ssize_t format_devstat_counter(struct ieee80211_local *local,
 	char __user *userbuf,
 	size_t count, loff_t *ppos,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f1c0b87fddd5..49654958531d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -364,21 +364,6 @@ static inline void drv_sw_scan_complete(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_get_stats(struct ieee80211_local *local,
-				struct ieee80211_low_level_stats *stats)
-{
-	int ret = -EOPNOTSUPP;
-
-	might_sleep();
-	lockdep_assert_wiphy(local->hw.wiphy);
-
-	if (local->ops->get_stats)
-		ret = local->ops->get_stats(&local->hw, stats);
-	trace_drv_get_stats(local, stats, ret);
-
-	return ret;
-}
-
 static inline void drv_get_key_seq(struct ieee80211_local *local,
 				   struct ieee80211_key *key,
 				   struct ieee80211_key_seq *seq)
-- 
2.53.0

