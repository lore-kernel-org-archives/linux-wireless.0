Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197402;
	b=cUORbJYmLiZcZozGdwykPCYc8d5N0g+zawyejVPOgs761Nw5c2/et7f0MtfKcWBYlJTg
	 4xiFHKJzLPsJJaV0N80rlbuXgbSuKzge20klPUgtIy7YPbTOw0bOjwLb+kTDh1MPRA2g1
	 a7jrajfsx2GhgJVKmVTOBG/uNsMMU3Da5gd4jg44hZWEF7ZmZBzoRMb2Wm6nqCw3PLTqv
	 B9Ln2dGv4rYYoa6UPjBW17D/v4EGIM++tUfb/UFFxT4A9X0O4ZKeT5xTXaoJqD5TGGOpZ
	 vgB8SUrsYHKpjiUfc7bxrp4jYp9EqfXxzcrOZjW00beQx0gpH3nnaqyu90IIg+UQKlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197402;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sw5hYC5Hzc20IlMgdER73QrgaioAItA2FePP3SYzoEo=;
	b=cXXa6lWNSzd2bU+SLEjkzW8yx0yWuROl8lI5jRtDD28KoDsUI1yBguY9gWo7kfDzuSYj
	 1PCjpsht/bqvoEDGTfqVEIdO5iwX+roPk3shXu9+eCrQ/5Jci0vM0Oui9oLyV+6qR18O4
	 GhqfTRPbkO0uXP/1a9vHUDZ3R0P45FZJzSK3cx2UJOJA5/QTJB0/Aakk5AHcFs+oBcOn/
	 w2soOK1fgjz2IihnyQSIjzaX0OK1RwMqZrCwyBb7Kf4RPvX5E7ZR53hkPlkALs5xIuhRB
	 7Z8WoAEJ9BZMsPvDmQNsv5BKibh4XKEVgnoNJtOC5Zygd1h4iAyYPvSPtma+Y6SOnMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WxM9i9RJ;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E921606A31F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:23:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E921606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WxM9i9RJ
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so666049a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197401; x=1793802201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sw5hYC5Hzc20IlMgdER73QrgaioAItA2FePP3SYzoEo=;
        b=WxM9i9RJ+T8B3uX9+0p5Z7Zpzg66rygBgxwggfCVMAdjD+AKLibY4EItBOvKKvO8ws
         /ClYV+PczJIm1poh00emLxSxxwFA/FvsySed3cJWsrfHvzFewIpuZgPjoKVW5Nd++YCk
         /yv1W5l5THdTlowA6LplMx6TuwnpMpFT7l/e8miTBlgvokSR6ZC4gMcuvyjF+cbKg+df
         HWTlJmX70Ngpyqje1WaL0BUpmww+WFhXaNVItezfZtduvtDnVx71fdMzgZIrFloKjkCU
         xOKn+D07tsFaU5DruFuxns14wL6fk+xh5SixO0mQ1WjGbOL0119zM4zvC9EuB5rlD7sk
         X1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197401; x=1793802201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sw5hYC5Hzc20IlMgdER73QrgaioAItA2FePP3SYzoEo=;
        b=rFub59bjCwpMO7AEUvENz/WOO+9GK0r0oAnAiCcod7T1yc89jaciXMvq+rtBzeq5kK
         mGrgwiegOZTpK4pohg/piXj3lWM/xlin0i+hDwQ7ZL9t7iWnUcT0/t2bLN8vEGf73ky/
         oLkb/BBmhLJfJ/fY+jLO5xkRW/+ptT8rzJvRuzefhxvFZjGMAjjPY4F4Wgn+jHyxptVi
         JGSOLFf3KDoDVRdY5u1GtUwzHN5SA/hN3t2J08KVD+d9rkNUZhXek/9YTygYxdVWhCp5
         mlIHgWiEGPE+r+dezADNxdAJYNQoEBUUwbfRvmvu8mrwbDtmmq6a8d6rRcO3UbDuYrqt
         LIlw==
X-Forwarded-Encrypted: i=1; AKwUvBze4dx3Xak6gSxQ8RvLyrjDpuNydbHFFVZZCfjsAle+57c8zqb2/uL85oCYUc1mTTUhW9iUSNX1yo4eIh0wVA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJe/Xro4vGbXP2QGh7NzDhTscZ3yJHrYuE91eiFriEMRY4YmJb7
	wWZP4eUAiRSF36F8c5Ud6HWf3SelHFOJE20wbG+2V19fhsPjgY+QEo2TGIw5vR0mI1g=
X-Gm-Gg: AYBFou3eXTYseiBIJt5xY68j0b7n/qbJKuUTUiYi5wjPFa+dWSjWV0w99PCA7dbhxfc
	RBJMbfomm0SRyj0y5gbLcpgGT9meCB9BaXi+/vp3+QDn1BawNTWrM1F2yoylaKCb5Nqe+xt7QvG
	gnawvfdXUaEIycj+Z4YjimnWiDZnTlVLQsXpBOBhh8Fqy6Gx4dyvWy2UCwukeMjedcFLg5j4qQj
	9pqdx5WAza92EdDp2jMYVAvtrqYwXiySZnPEGZH193mobopc9ieYuinvsOD8eKFRhsISJHhD9dX
	quS9A1ldDfNKmktPuW4V2agV2W/WSF4rXSCZ75ex+rVngk8PKIMexoBkLoAzn4cNzs/UUsbjUMj
	94MKk7iJkOFrz/tYzeoCqUAGCoDdFieYShJy57l25BYjP0AAWQD1JkqFNXJtndL2ewdfJWGgblN
	SdqQi3dZfJXb1ov3SbZn5LvS8S2Dh7p/5hIIpYwz/e8iI+mU4w2MM+VrKecOUI9DNOZjRrTF3aG
	84fC/R+FGYZXgyZURg1HagFdAJ0HvQFC72Qo+xsRX4NCrlZzC5MMlifj3eKMaq/l7hbacr7ODvW
	uljpXDFqfnvX1VpFuQdaD6sXBoqhfmjFbJ1kMyALEFB6I+FtrB6pZ0dzwh+L/pmXwW6k
X-Received: by 2002:a17:90b:4cd2:b0:3ad:b86d:dbad with SMTP id 98e67ed59e1d1-3ae581d37e9mr1711896a91.30.1793197401182;
        Wed, 28 Oct 2026 07:23:21 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a501083sm3773918a91.8.2026.10.28.07.23.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:23:20 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rostislav Lisovy <lisovy@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wifi: mac80211: enforce OCB station allocation limits
Date: Wed, 28 Oct 2026 22:23:00 +0800
Message-ID: <20261028142302.16634-1-enderaoelyther@gmail.com>
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

Patch 1 prevents the worker from installing more than 128 stations.
Patch 2 bounds pending station allocations to 128 per interface. The
patches are ordered: the insertion recheck must precede the
pending-allocation bound.
LLM assistance was used to review this series.

Zhao Li (2):
  wifi: mac80211: recheck the OCB station limit before insertion
  wifi: mac80211: bound pending OCB station allocations

 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/ocb.c         | 21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)


base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

