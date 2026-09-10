Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB29E3A7F54
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 04:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013459; cv=none; b=aF4BwEWAZu/INdWd4Bc2wGj2d7wVPaLYzXvxwk0TRv3wWDOBaBgfx6bnpH8NSjNN7CEvFj6ITNKZKdJ0eMEQzDXJLBwWdqrIvMoQzOdi35JW0j2/RK+b29bkwSauBXhfQ1ja3aRKTvXqNmcWaGaE9vWR491AQt9aBexupY4nldA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013459; c=relaxed/simple;
	bh=VBRMGDnmTSoBVAayF4EJRhtYQQ+ry7lr4E1+xx5Eja8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QYvVr8UCh8w2r+3b9/rWBEsBn2OA8KozqZnPMawTwjDUvBQIsSsOsUbztaopqYQy0ZQu0qD2RHvi5fZNMce8YxEeVzF4PdF/Xw3RnsHLLbnd1l8l7KXFyQJIm6RF3CJYnI1FKx6k0H49CpxyYmWl8dEaAAnDLGyiuyxGoAArFk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YPlmY8+A; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPlmY8+A"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2dd05e8b98cso10225295ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 21:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789013455; x=1789618255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cFzG545OB84YQ9peVUsBUfgFXji1m++Ini1JNnUg6R8=;
        b=YPlmY8+ASz0JGYPLS4Et91RzYmWDa0yn59n0tNEyjYa/kUKSVysvSUGZMQRssIXQqr
         klZ78DneUR9kq8rcwosahdk+rWi81E4PCgzTsjh4n7HvAwQN2fn23hJxnAleUgIS/bvG
         pzlxN5btWvOiYRB3CXVFY/RV6pYBPAATlrGum/QNohpqJnBHfhKNjyPT1aEg5OxfjT+I
         UnZwMEkz6y9kX6R62AGXVEVch3AT2hxYtfWcsV/B0oMIYAMhMla3oIJP/HJzZiHFf4Li
         Rd+26vd8VNoUZBtPmEPwrkBUXDfp7brX2we7E13KSVBEKXz7tzu+Ad1NUpXLytjNr6lt
         tkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789013455; x=1789618255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cFzG545OB84YQ9peVUsBUfgFXji1m++Ini1JNnUg6R8=;
        b=k678WADHrsRtVs/E2fvsZXTiYOnXPfU6NXQ/OfZ2TkdC0FzM/UJXIAf5b5iU5BWeb9
         iojRO/rggBnz62IVpteLD7Qt6zenSktUvPB1KXUcMzZDO3Oxza/7zssNljrD6Mc0SBc2
         qd2zEHwRPmNTozbRwoh8njDZ5tbkKvzb2skubeHZl51JNH3jLtSANq/1yfj3t1nxRvnd
         OC4FR4EmyorXGf0OGJtBMAiH8c7q1T+4KUi0eloBJExwM8ssGvtEiamy1x1P8tSPihmn
         805nhvGMF6anPHwo2Rlkb/mXpyQ4WqIkJ/wxpjBQiZSEQ7xF56L6N7QzBSPhTxc5LznJ
         YNcw==
X-Gm-Message-State: AFuF++mGKDiS+prcBzq89Rksc2XxGpZzRK5UrVhIVgBQzCiJNzP0SNlB
	v2t84wYOqT5bdDc/fJsK5oNkpydLuZhttmpKyfUBnF5YZ4+D7DXn5dZ3
X-Gm-Gg: AYBFou2+2Ex1rvllBiuK4TrUuQfl8Hw7KWqMj9OnqEXRStSXTPmgX02HLT9RLfLwljH
	V5V72IZLp9eVYeNs2Y5VXm/fdbLIoVWojyoFWuHfwKSBC168ZXfBVkH5TPsbBc0WG2NfQm5o7yR
	IEfZwKmw2uT0zyKWOQx6ZrPufrgcd0vZmPYzoZrFRnBxLJb8nZof9znYTliW+P7jfa/XAw9i8RI
	6IS2FsexC0xkMkcvNUlqBBpLANGqbNdD0mtelSfeesXoJE9h5B6nWGLRZfpsZX3RtSxUDQn0lIt
	G9OnLFZPcohDmOP0h1BO/nQvyisGmYv1TidUXlIWajpJdBuLJxaeYdQd02azW7aD8EVmg47RemO
	o7OoFVMlR/H8BlDcuun3uV2qlNm3dY4QK7EqjRBYrWhjJHWpHdAPqvEOPeWSeIiHrb4Cu5Pw0oi
	H1L3T047ydLId7JboZBpQfEp821cRkuzOjNGBfpGS1cmXWHqIXoC2AZc9po5L2jDzKcg8QUH9mB
	WI/0AUv0z1/dNiOSa/eWt2MZSycKPgPhw==
X-Received: by 2002:a17:903:284:b0:2d9:464f:d45f with SMTP id d9443c01a7336-2db125ca396mr552411175ad.5.1789013454662;
        Wed, 09 Sep 2026 21:10:54 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:383f:19a1:b573:237:5f99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db149c2850sm82946945ad.62.2026.09.09.21.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 21:10:53 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+d979bd35c8a76fd1b6f5@syzkaller.appspotmail.com
Subject: [PATCH] mac80211: fix using smp_processor_id() in preemptible code in ieee80211_tx_control_port()
Date: Thu, 10 Sep 2026 09:40:47 +0530
Message-Id: <20260910041047.24437-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_tx_control_port() can be called from nl80211_tx_control_port()
in normal process context via netlink sendmsg(), where BH/preemption
is not disabled. dev_sw_netstats_tx_add() uses this_cpu_ptr() internally,
which requires preemption to be disabled, triggering a
"BUG: using smp_processor_id() in preemptible code" warning.

Fix this by moving the local_bh_disable()/local_bh_enable() section to
also cover dev_sw_netstats_tx_add() and ieee80211_tpt_led_trig_tx().

Fixes: d5a014204a3b ("wifi: mac80211: tx: simplify control port frame transmission")
Reported-by: syzbot+d979bd35c8a76fd1b6f5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d979bd35c8a76fd1b6f5
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 net/mac80211/tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 74ab27534076..7b1a3c63e5dc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -6687,10 +6687,9 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 
+	local_bh_disable();
 	dev_sw_netstats_tx_add(dev, 1, skb->len);
 	ieee80211_tpt_led_trig_tx(local, skb->len);
-
-	local_bh_disable();
 	ieee80211_xmit(sdata, sta, skb);
 	local_bh_enable();
 	rcu_read_unlock();
-- 
2.34.1

