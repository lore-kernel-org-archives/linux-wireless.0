Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028444;
	b=OrfkE4ENPWn2nMZ4Ap32LtdGVd7mBSMB4aROeqOfcD7p9C9Dfw6QxIedzKQ8sMVM8nIZ
	 gvq+da9h12tqCDE3fwR6oMo6v3/ndd6JaBtTE9Hzs4xphJfXILTfxnmUFs2bfnijk3hFN
	 oT07kPSOCCWKLmDUIvxj4ziTaKrtKqQ+0n1cStloz2iDPLb4RySVhAH0j8Fn7W7wvVH1G
	 rH0DpNhLHQxSfAVWr5xNK8dcuRLQdqxdaLAGh/EsoEdjoen3/z6zJDKYzmM/wK3+Ikjz/
	 hmkA8Tcp49Qdn3rSpUzQMHe6MtVwVamUKW+EuXzZ6Xxt6AwNVNHMT8cHKIBEU7no9LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028444;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=icXw5cUiWlz5rWfTUQ0wOJr2LvS5fa2INLJ4qgOPSMo=;
	b=TD3+UYwHDCSKtfV97PEJ/QX8W+owUwd7/rqfafOmCVG1YzUc/CfIUR4MgDeuTR1Er9h8
	 rjMVU8CjBOjM2cTM667veOiHD0wIf4Z7GlJfP2NaOwCwBUzFHms7Q9ycxkjucp+uRXhji
	 cJzr54ER/WX0E+22vA+wwdXoHdAjha+5KwwI1jeszWcPcwF1CoqX0JDLvyHPGSCgRm6fJ
	 G2ByVKqHJ53zcoh7eClaTJ4fzz4ag2zapTah9ea8kPV4rwrT+4kyEZk4s8nrNrF5yDv84
	 AUOO2ufB5ZCIfQEiU7WG2hqBGcF5I4RxYNPlxHH0ZII1uJfVeab7c5RL6B4YaYelZyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bfsCPrwm;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25B5606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D25B5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bfsCPrwm
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e9995ce866so29112625ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 08:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793028443; x=1793633243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=icXw5cUiWlz5rWfTUQ0wOJr2LvS5fa2INLJ4qgOPSMo=;
        b=bfsCPrwm+ad4L4mOecEHO/1R2ve1iTljR5+QR4t0AqvyTBRIQD4Mfibr3x4ot/3eeq
         wpoU5e1PgwnA8c8fizuSC5ZjSK3A7UZMBujw0ALSFHQXwzvbblh1MkzlXARBAUFmO3fF
         u1Erz+jTf1JyqpEq77jeELaRzGmrAhSsAR8cZ9FPl/jUWGTsvTfZHG7UZ4O6PRE3WwTr
         RiWy57QzMtL32Cs/vrieWxyluqEWuKkWZF133QVLLSyiOcxQ1T9p6mkBgeXD/GcU4FbY
         6xcTAdmHWBJIeIgHuZJIcnZOhLSKPYFO5dIrOmpU6AFsP6CUJwFesWyW1MWgy9QaDmRN
         FOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793028443; x=1793633243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=icXw5cUiWlz5rWfTUQ0wOJr2LvS5fa2INLJ4qgOPSMo=;
        b=KjG46A+NBJxJW72dQPasiLsZ52hN8BtVumbfqVHhhY+x8/qOZgr0+03K2YC+3ApkmT
         agibH6uA8BUQzfvXniQkz0eCtetgbcI92ofD3EeFh6hMPNo4ayn2OdRmmegeynOfFOV5
         CF1Y+yMu2tgagzPc9cbGpQLxg2pg+UjP9ZFJoAh3qt77hJTMPsaUWrC2+kCKYAZ16TS7
         wSe9FguBHWfdOWvq6wPgytTbbZUFtMjkrFEsRo3unpIvbFBOgXenQpJMo6Z6nKmoEUWc
         WnK8WWKxg5HtW+vkgCHoE4MmC89H2TMzbIuM2Daq57GwN32yUcrfthfKyNlRCulC1tpF
         Lskg==
X-Gm-Message-State: AFq9FYL0Ud77CuNwRIxyauBA+dW5fkYRapf3UFi5kChAORKMrjPr5cA1
	EcfFBYzwSeXEi90Cq0hJIfzJHnI27gJo0M+abid1vjk2dFVtMzDn8EhXIt2g8jjR
X-Gm-Gg: AYBFou29/J6XZ/xjMzBGBJqIyB0Y5Sm0yZg12X8YNI5oOenfer47DVilR0xNgzJOJWq
	pysHctWaUVsBO3ag0SYlEyLVC8xNTdHuAR6OLxXkRFWYVHcQaPOcQaPY8YUBGLhe/cBZ4CSV+um
	07VH/rMZCQlLE21SZOU2Xrgk6HpVbNI4CcI667F5GYHYVdwWHfECETci+zANxFI0VGpOMtQobAS
	CfeqaPQfk71DqV4BmTOiGdvyiuszvheOXSGYjIzpQAh9TV3Gq0nrP2D5tHtLnAn8RP2QXFGBG/I
	RzzJtCXwoLvmMgCW0zLngslwWKcFi2gMgqoPyssgofNsX7J5Uq9MU3qaQrOT+UAw06s1K8dz+JC
	B/Xc7pAsq1lDeuMIbDs0pYOEnPQ3kyYNGwfqpeRy0ddk84bh5vHUbqS+J9/8NGrTzinwkvSs/He
	QUNZ6flgBP1KvCbs/QEaCDYluX5R4fqn1Dth4syu77bVvK3NzePgZkonxdxeoVKFSVOJ6OXKuA9
	kMJERaF2SGS8Ay7yqDmyv6vV4UYU0aLVVP9iZa+MnTsLwL1A//d/+lAZYnrbFlqVGwAwhipebPe
	jI+L0XM8J69rWpnxjr4ZNg==
X-Received: by 2002:a17:903:234e:b0:2e9:7ff5:545a with SMTP id d9443c01a7336-2ea9c67c29fmr66184465ad.32.1793028442579;
        Mon, 26 Oct 2026 08:27:22 -0700 (PDT)
Received: from KRHW1CJW23 ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea9af32085sm18713105ad.2.2026.10.26.08.27.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 Oct 2026 08:27:22 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mac80211: fix use-after-free when MLO link setup is rolled back
Date: Mon, 26 Oct 2026 23:26:54 +0800
Message-ID: <20261026152654.80697-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rolling back an MLO link addition can free link containers while RCU
readers still hold pointers to them. ieee80211_vif_update_links()
publishes new links before checking for duplicate addresses and calling
drv_change_vif_links(). If either fails, it restores the old pointers
and frees the new containers without waiting for readers.

During a non-MLO to MLO transition, the published link 0 replaces the
deflink, so existing link 0 users can acquire the new container. Readers
such as ieee80211_csa_finish() and
ieee80211_obss_color_collision_notify() can also queue work embedded in
the link. If they queue after ieee80211_link_stop() cancels that work,
it remains queued when the container is freed.

Wait for RCU readers after restoring the old pointers and before
stopping the new links, so their work is queued before it is cancelled.

Fixes: d3e2439b0f33 ("wifi: mac80211: fix link manipulation")
Cc: stable@vger.kernel.org # 7.2.x
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
LLM-assisted source review and patch preparation.
KASAN test-tree harness: pre-fix 22 reports, fixed 0; wait after stop 22.
Sparse, Smatch and driver-failure testing were not run.
Older affected kernels need an adapted rollback hunk.

 net/mac80211/link.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index ce1c95b40cd9..34d313a2fef3 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -401,6 +401,8 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
 		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		/* drain RCU readers before cancelling work they may queue */
+		synchronize_rcu();
 		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {
 			ieee80211_link_debugfs_remove(&links[link_id]->data);
 			ieee80211_link_stop(&links[link_id]->data);

base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a

-- 
2.56.0

