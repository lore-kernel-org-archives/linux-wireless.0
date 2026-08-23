Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF0E383981
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 19:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787515066; cv=none; b=SV3XYtAzVP+gj6fyMF8pPMEyeeNVjTyCGNQXde661QozvyqvBPkB5hXo5szXH3SCMjJbqvY6u2jPkkCNb/f5wU4TDbxtVpZiOELU4v424kHNCG4J/XRp20bJwfKK/lcv2JqAF69mPRkktLTuXBs/dWrQSLsL30NxFgzIKQDNT74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787515066; c=relaxed/simple;
	bh=F3FK9A6UrW6lYimnbEo77JEy89+oQLKm43N4wNGcvPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dqfueICO4oQGC6G+XPUis+9YetRGrjOMTCbHsObVMSafOHW+0s/A1XKIm1dlKWHlxIScYFyQUBeI9X21nmnFVIuXEnleF6hoJZsUMRxfOG4pFhlQMy8EKRXbqi0esG7qxuNX5DS2jXGVL+U7No8+NpavvBLfm0ez8hqKKkJO+eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=jBLk04En; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="jBLk04En"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a17cb94b26so5345196a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 12:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787515063; x=1788119863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0bIlWCpWwySa3MuO/CAtmZtTrGp52YMcYj9sBhTIx6s=;
        b=jBLk04EnoszAzrryqOQBssTbnI1z1gousww7sRgtVwI4M2exjhISTW5qtUtGdyFrWd
         GGHHeQpMDP5jZS6JZNoO82AA1RgFt6Tp9mhQ9e+SAYunyU7ltcEpxZVT3gaG466qZkV9
         AAr0oO77v2MZBa4w08tJoE9MmQjcl0Qj8WHAbjdSV8PN3dzuFOyPSOdDokMZXLeDt8VE
         b74mOXLVsktjsSueW3fSaIshs6ehb3xxTVMmPU7MAucjqZRrkNk5wtqMSctA1/1yWTCi
         RE1ycU51/jjya9X8WzfU1mM1ezbgJ1O6ygr6OZXXmndNhncskUteOYcjYlsXk0Krmfpp
         WxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787515063; x=1788119863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0bIlWCpWwySa3MuO/CAtmZtTrGp52YMcYj9sBhTIx6s=;
        b=omIyDu1s2IKoD87L2lWjLZy0S8CIcyi6OMcJUFvMjPvPpnPGpdav8BINZAuAwnNeP0
         zNGc8fdmGv0JC6I3tYX0iam+gzJj2dzUhosUx2dk0HgYHjYS96nGwiXc426M/KEZmHJc
         0Bd07Hg2UqsCNP5I8Iuo5BOLpO2Ka1xq1/F1/KxA7/v/n99Pzsd3+X53AdLr8aIXZV3v
         ks93HwJUW3fWVJznRQTy4RKY56PXxwmnWuIDyEVFyDl3HiEtLfcvxZJMiESOFlVGCR+s
         X63lhtObpJ8CY1Q5I9TclYYrxvb5lG4n1gYEgV/WsPUDGA5NWyIirtgEBPs0ViWWbA1j
         yXoQ==
X-Gm-Message-State: AFuF++kS6e+AO4QTWMhglRWzmfhY8K070ZgonImXftvY10SguZi/0glj
	ZEMGjMmi5c7EwjaBaYkV1txrY0pVVAKRMqk6DCnasyxMA5yemg/ovad2/RghdupEsA==
X-Gm-Gg: AR+sD12ZR4GQy7I/hGGYXcQny9bghwekwWjxmf755BSf9bXMG6xjrfgTJ43ZbFzNoQb
	SYim9+2Rxb5CbNxxpJvHLF3TsegO8YN+VKo4ij0TaDF4tqzIFiypdGX+NHhvMQ+a+AduXxXbQFv
	N2SF6K8j//eR/19xZ24dvNuSwMob9QNamVWA85FCE/328MOQfbO0CrBOM7zzTnnNSvs1JULTErq
	jsjsIl8d+yWVfAocaCWAucaZR03RANGYn3AcztG8lcVMlCGpXDix8pjYG6BAv6CWwDLm2KiPY1c
	dMwwAz2FuK7NoEiAyi0+s1lKcNo2lGqM6Qx/i4LQ2RqrVPNVskJonQ81IjIjfcu+1Zc2PX+Ix9S
	JRGUD0Rdt92098e5rrpUjxxQpKYzUniopRomEDQhDnGGgIgSm5u+vAMAVTsETvb9PBMLOEs5yoR
	V4BkobJZ+ytUm9Hmln9o9mPIQH5k8aPz6/SedC6aMr18UBhkaPM4VtFXW6EtQ2u546DnlxzIqFj
	G2dQpTt4BlzzOBSNe0eLGptx7ZVa2A5ZwTGZmPdoiLMXAMYsAf86I46YsM0+sBNSi/ln46xoNN3
	hAD7Po3ejmpgwYIn1z/gHabTvQvNpUjyzgLZc2R0SgYxO8qGAhwL0nTQ1zN/oR+fi54yNKYp//A
	agQ71cWUJKPbdFjlxARqdIIKJIzZjX0cBjbeG3rKlqrQj0mnRlMKwFr05c+5LTjAjxm7w1iJAD+
	pKsfZz/eKU4oFG
X-Received: by 2002:a17:907:6d08:b0:c20:5798:7b9f with SMTP id a640c23a62f3a-c246a60c49bmr2302608166b.10.1787515063510;
        Sun, 23 Aug 2026 12:57:43 -0700 (PDT)
Received: from Desktop (pd9513a95.dip0.t-ipconnect.de. [217.81.58.149])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e2e2826sm4447491a12.31.2026.08.23.12.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:57:43 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v1] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Sun, 23 Aug 2026 21:57:39 +0200
Message-ID: <20260823195739.49222-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The aqm file prints fq_overlimit with fq->overmemory and fq_overmemory
with fq->overlimit. The fq_overmemory line was added to the format string
after fq_overlimit while its argument went in before it, and the two have
been crossed since.

The counters are not interchangeable: fq_tin_enqueue() bumps fq->overlimit
for every packet the eviction loop drops, and fq->overmemory only for the
subset dropped because the memory limit was exceeded, so overmemory is
always the smaller of the two. Reading the file to tell which limit is
binding gives the opposite answer.

Fixes: 2a4e675d887b ("mac80211: Export fq memory limit information in debugfs")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 net/mac80211/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index a4d5461f6480..014f3c872706 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -96,8 +96,8 @@ static ssize_t aqm_read(struct file *file,
 			"RW fq_quantum %u\n",
 			fq->flows_cnt,
 			fq->backlog,
-			fq->overmemory,
 			fq->overlimit,
+			fq->overmemory,
 			fq->collisions,
 			fq->memory_usage,
 			fq->memory_limit,
-- 
2.53.0

