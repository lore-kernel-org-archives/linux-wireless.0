Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD322BEC34
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768978; cv=none; b=Dww09qN35oy3mEScWHolwV0Ufy7hSJoTCh6wowF6+0vQ00ABRxfr5tkboGpTxdoy+xRPdsbPu8byj9M8zaix95VH+DJujYT5Ud0Cr5h6rrjeU/0dIdE9JGDzUrWKd6PtxPuumCUdeyJZvuZjSPMhDugJ1HKvBL0HGD0SjBjkQy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768978; c=relaxed/simple;
	bh=/g5GZQYVBQ/CQ49fp4PAdaN34b1qiSmo5DIQk8nt8Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KmPqXbmxcaMXFi7CW6ly5aax4L/+AhFEBQGvHEfv76oF5CgY4cTW4IsLiRCiqt8gimNqvotZEKL7bvtSt1utFNalLCrDI2XGvmEauudrzAmvZtfWNTA8EALjJeFEMr3TZ1jIBPdzAbvdF4QqMM4iIMc5DQLuiwJ9mLeljCAN2ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EwDH09Un; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EwDH09Un"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ce98cb8165so713395ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 18:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784768976; x=1785373776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f+ZqAtAmv4uQzLrMzeqzPb4YqVdPJrtC68NMrjWT2dg=;
        b=EwDH09UnYcbzzYn6EbNcKgrAJ6Vaz0KqEMq0Y2OU6wEAHnVo2jsKXjdecUmQxJ1DMW
         OCnnHWYH3m1eJu4KNEJh3PT/T7Oz8bpjmOGwJB25goa/H+PGc4eESpiFNvaRquE5A+hU
         75/j5yzKociJahXA4kyjxNvTH0dWovyf1BQYSHJH4OspqgMwc+U7rBr+iZu/549dSKig
         TvbgIld3cSVcQCn7Vbh83q02dcbstffz69J5Gw5S5A2gZgFRpdsjRzGc/N3VWGpZ+gos
         kljhJgktEh5H9PboDOLktYek1yU//U4UL+5bdOIsNl8L6FnvNyIeBOJOhAMFcnAXUt9p
         Bgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784768976; x=1785373776;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f+ZqAtAmv4uQzLrMzeqzPb4YqVdPJrtC68NMrjWT2dg=;
        b=IDTK5Glv3WVuwe7gF2Y/Mqk5kjPMJetLksQ+GAeshXirekO9Vmu1eUfdZy29ZyDWvy
         C54Mi4Jy7iR+xzjMUEpyZisRmSpK6EgcLtdf9w0wTZgku5Xh8wKKUfdiiNrILsTlJ34O
         cFF+70vlgF390blBTJ9OcLDeH5VDMVYiT9Drd4/pVOgOvWgJff48eYDid3OWYHznmuAn
         bi2aa9SeIcGVajy2xxs5eMqrgZkMxhgkaZOpD1i2m4bEl6sJQ+Vvhx+NB7mi9pyYDbzH
         CPimvDS6mT/b8PH54omf1ZveP4uarnrK7QNPCn04dflfqDb2o5wv6OaERNf0y1Rc3pS1
         tvsQ==
X-Gm-Message-State: AOJu0YyY3nj5tnfXLC5vMGprr0nnECW+Yjni3NxlzqnqKTRImPFVJBlB
	Yj41JmJ7N2Yp8rhaaGSEYkn8MSQkWnr0xKO6KpHVmwn5phfvT9Vq83Dp
X-Gm-Gg: AR+sD11OA0rN4y5ozP1/xj2esDrt7Ff7TAQTsNajQtseTKrfHAidw+3t2WXTLBHhTeq
	u10X5Zk3y312pNRzdLr0775tzCRspKvUR1ab35vVFxo+Lo9atipHAPLOWRnCr7Kf4xYxDKKN+b8
	rdag9RqAuLyj5EpuqmXJJl4/WdrJOHVyWcPxUtnudRjVxx2QyDxpe1wyrIY8ZMz2+o91RlE7qAG
	9yXJ2dar+N6Oo7Rmu1OG3KlhR7yXOoLfq54welhy17CPkGTnqB4g0yJxSLnuUpKoTfokxaAPXXq
	n8kfNTeUcrurqxjcr92I5Rf9BP3nfZt1PePtCocZAxia021TVd6QmlcCaBiS/3teJJQAlzghIof
	2KPDvh05TIpoRyO6Mht4Vs5WiJEZJjjIkuV+bHHlBox1z167KtXmo/V1QzaPG33HmQJOZUfv/EA
	oV8yySqjZzj8OccLnDE9hV73PoBBPU8T+m6eXsp1Cj
X-Received: by 2002:a17:902:ef0a:b0:2cc:80d6:b72 with SMTP id d9443c01a7336-2cfa95286dcmr6311455ad.20.1784768976073;
        Wed, 22 Jul 2026 18:09:36 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm22649365ad.70.2026.07.22.18.09.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jul 2026 18:09:35 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lachlan.hodges@morsemicro.com,
	lorenzo@kernel.org,
	Zhao Li <enderaoelyther@gmail.com>
Subject: [PATCH v2] wifi: mac80211: validate individual TWT params before driver setup
Date: Thu, 23 Jul 2026 09:09:28 +0800
Message-ID: <20260723010928.76551-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_process_rx_twt_action() validates a received S1G TWT setup
frame only through the control byte and 2-byte req_type before queueing it.
An individual agreement can therefore reach ieee80211_s1g_rx_twt_setup()
with twt->length too short for the full struct ieee80211_twt_params.

The individual path passes twt to drv_add_twt_setup(). Both the tracepoint
and the driver callback consume the complete parameters block, not merely
req_type. Do not pass a short individual agreement to the driver.
Broadcast agreements remain unchanged because they are rejected locally
after accessing only req_type.

No in-tree driver both implements .add_twt_setup and exposes S1G
operation, so this is a robustness fix rather than a fix for an observed
crash.

Fixes: f5a4c24e689f ("mac80211: introduce individual TWT support in AP mode")
Cc: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/all/20260708195911.84365-7-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v2:
  - Validate the full parameter block only for individual agreements,
    leaving broadcast rejection handling unchanged.
  - Add the relevant driver maintainers.

 net/mac80211/s1g.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index 5af4a0c6c642..abc338e22e59 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -101,6 +101,10 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_twt_setup *twt = (void *)mgmt->u.action.s1g.variable;
 	struct ieee80211_twt_params *twt_agrt = (void *)twt->params;
 
+	if (!(twt->control & IEEE80211_TWT_CONTROL_NEG_TYPE_BROADCAST) &&
+	    twt->length < sizeof(twt->control) + sizeof(*twt_agrt))
+		return;
+
 	twt_agrt->req_type &= cpu_to_le16(~IEEE80211_TWT_REQTYPE_REQUEST);
 
 	/* broadcast TWT not supported yet */
-- 
2.50.1 (Apple Git-155)
