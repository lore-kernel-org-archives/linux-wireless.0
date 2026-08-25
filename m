Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53A470117
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666249; cv=none; b=jEoaj94imd5fpS/9ILg9yQPEoqhhDiJekarmzOlkq9DKoN0+Su1GNMIRTUCo6NZeAjlxWh8WD2jiWBWcLOH+wxVfuReoCG3Ha78g9qn57Tg/LMpCwA5nBEzMxZQ8pVC+w7MiExiJfB7UdvdCLO4LnTHROt9mUtXcT5w5KqzmuDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666249; c=relaxed/simple;
	bh=UFtLMT3Fxnw7/RT65UJ1XKrTurxgn00MSUrsAnDVnB8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BebJMlPej5Pe/8KtoziOmzxBk4yCfvYfQxvs6759LkIJoyvvkQpDwF32DsOwTjDIhAC3FM8Pim8vo+y0DYKuwUcLvo+LfwgDb6G8QuzBXhnGwaf6ZfmDHvrSo5hmgt5/PaLmNiy/u3NTSLvxoUtTiQqbJ8DkS1PrVxb7Mp3MwJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBiBFf2a; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBiBFf2a"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4b1be215736so4115422b6e.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 06:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787666246; x=1788271046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8oDnBG5pUQk9HJ4XVASc62aB/OctYIg5uarmUC6J2ho=;
        b=hBiBFf2a8gjbg7zVe3FRfIR+ZRhQSvyRx/8/OZA5wk+5PgNO/7kAY6jXPvqlYmacrJ
         7V+XCjZ4onLQKWwkIzscEo2ASL5ioVnpbPrHOp716n01EEyoqRL95HN4sM/qNGSJwm4I
         1pXR9xdtu/uG8Z2l+HdO84Uj2nw9Jdps1moHsa3tpK0yLoK97xLNNjqsKtW2du5xQl46
         f1YDL/EEkEKcb+5bZPLuGqoT+Xwm+LIuFkdDTx9dn2NGLzLBeOVSXydRdHVz5LRolbot
         AlnzUQrc44DSYpqw8wTlsmmgFzmQEKvAqLaLDUH0MHQl5tFmJtkjutRv0DYTrjvD3blf
         WpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787666246; x=1788271046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8oDnBG5pUQk9HJ4XVASc62aB/OctYIg5uarmUC6J2ho=;
        b=tY4rCQFSj4O2vKnwIdzdW4TSAuUYgD3R72vJCT4PVqSUYW7IvbfEEIOpjQObaz2F85
         z6JIXS6oihli5kkvvvBmmBbimtxojqZXntvWijY3tn07htB8VXh66CP7x3rhvuNomXab
         T7M+xbt0Iy8n4tcbqvlLCoIrRUa/mK1X6iChrfu//VHXOSk06fUP+tJsMH7d1uW6idYj
         g9xCsygrPBww3WfYnrgG+rDzkwZh4wVq3ERDTmi23SKNeBMlzD1SPc7FQjjmRJUd+9D0
         U3UQQkofvgJ3tXE7ZWKhMuph7XckSiaLEvMnzGx/GTOT9n3qxdV29oTE3lb1vag0CaDW
         FWFw==
X-Gm-Message-State: AFuF++ktYFhMcAmTS4jdwmYFr/qEN7D2+3oOypW4VOQZwBWuLZmThGFN
	64GA62DAwQijtJ1z7u+xwvW6lcvUvyRSJZLprwVHXynH1vp7AXWfSu9ZRX1AM+us
X-Gm-Gg: AR+sD10xOzS7iuB4qFD26VdYIH15kjl0dCfa0q9YU1gSgpsTPC11AM8gRBXP0jW3uPa
	513+esJIGAIo1Trh7VwMMFbSaXtHNhPNeRxnkK/BcZqN2DU8Sk7Xdz2ggglUp+O+bxH7iR8er6t
	UVa23dcw+Ms4d8IsA7RPRwBKTFgMMbPPMjAs4ARL3Jq3/C6/oh9kavjOasuJhxUdZc4PEEJxTJo
	y2QKigtzGhsCCD6qt/VlVZcOdzSq66PbnTTqP7YCZOQ1oKypDP7V48j86pVg7XGjmfpkXf1i6eN
	FvsVzOY1x42rvDlcUXeefUlPuc1vGne1m8AfcKrtQxoHsx067MDzl7+YP0SfsqDxYqHTxWYPHue
	60+hvZmO81nD2zxS9ysibpiv1kxKVMzWrT0+LtxLBgm3EsYZYtWQc8GSecaHyTwG+OHX4wCavM2
	1Y03XtHPZ4zUzdQh2EbmfxZr5+qmjL+GvYgtFr6yPc4fwx0An29deqb7wVgl4vfylD+enK1d+bm
	ZLhZIOnko4+7jEO2wB6HGNB
X-Received: by 2002:a05:6820:4308:b0:6ac:a45e:ff84 with SMTP id 006d021491bc7-6b16b399d68mr16973319eaf.13.1787666246291;
        Tue, 25 Aug 2026 06:57:26 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:383f:f0f8:e2e0:b981:3cba])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463834af0absm7804076fac.12.2026.08.25.06.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:57:25 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: johannes@sipsolutions.net,
	nico.escande@gmail.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Subject: [PATCH v2] wifi: mac80211: mesh: free pending CSA settings on interface stop
Date: Tue, 25 Aug 2026 19:27:17 +0530
Message-Id: <20260825135717.36369-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ifmsh->csa is allocated in ieee80211_mesh_csa_beacon() and normally
freed in ieee80211_mesh_finish_csa() once the channel switch
completes. If the mesh interface is stopped while a channel switch
is still in progress, ifmsh->csa is never freed, leaking the
mesh_csa_settings object.

Free it in ieee80211_stop_mesh(), the same way ifmsh->beacon is
already handled there.

Reported-by: syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f5752cd6b94fe38be666
Link: https://lore.kernel.org/all/20260824054611.29728-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v2: drop unnecessary NULL check around csa, kfree_rcu() already
    handles a NULL pointer (Nicolas Escande)
---
 net/mac80211/mesh.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d4507e4e6ec1..48015dcb7add 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1201,6 +1201,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct beacon_data *bcn;
+	struct mesh_csa_settings *csa;
 
 	netif_carrier_off(sdata->dev);
 
@@ -1222,6 +1223,11 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	RCU_INIT_POINTER(ifmsh->beacon, NULL);
 	kfree_rcu(bcn, rcu_head);
 
+	/* free any pending, unfinished channel switch */
+	csa = sdata_dereference(ifmsh->csa, sdata);
+	RCU_INIT_POINTER(ifmsh->csa, NULL);
+	kfree_rcu(csa, rcu_head);
+
 	/* free all potentially still buffered group-addressed frames */
 	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
 	skb_queue_purge(&ifmsh->ps.bc_buf);
-- 
2.34.1

