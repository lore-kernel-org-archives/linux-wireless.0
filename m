Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B443624C2;
	Thu,  9 Apr 2026 03:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775703951; cv=none; b=udAi10MWTDBv2Ocki+keiWX48XM1Jd9Ct4YNCQUgZLrYhToscdPEuRSJlmpT/VfoyH0QCnOs0fulbV7SifRxZQfF3V6ZvSKiqYAJ+W5IKFEJuI5Eb/6k4OaIQNIJg89v2PI0lUOmcRQ17uf17Iw/jsH+7iJ+Z6PdBJmPTp+cDFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775703951; c=relaxed/simple;
	bh=a73RdjCSQ69c0R/PRvxNTLkVK9B6Mzvky1lgrGHlDs0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pBdP1tFc8gy0ZpY/+V7hAGFVOim5zSaKPv2NwFftoxsmdBu7JthZLxuyxOZgtaclawnHvD4gvYjLQ7lySRCIASIbgjZ25EJ9Ibg1gLoEr0NNWUqlZsbTS6/Imyy39p0vrCzcPx5eoCOOrNvGcMFgw6Px4PpOvbBd8Gl5BW5kUVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uNDep+1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uNDep+1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2436AC19421;
	Thu,  9 Apr 2026 03:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775703951;
	bh=a73RdjCSQ69c0R/PRvxNTLkVK9B6Mzvky1lgrGHlDs0=;
	h=From:To:Cc:Subject:Date:From;
	b=uNDep+1gKeYvgWgxfZqGg783jyJkdQXD86Zx5Pt3y9qbu0Fwuh4mPPk1gCivMfDQh
	 JW/VykzXNvTjuQfWQpYMa3iFQHiqLYqqaOyCC0NX/B26NJuULOVrv9dLf3EnQ6sUid
	 j0gMkT4tzkFFONEKtnwIGDaDCgKyi1tkAQufaKxMnF1/8iUS7SyZsULPQB0Py+9e4u
	 GwB9aVUinYD25UCsRSBrYZhWylvS/FSN2uThdwCzypQgJFXOw+OXSE8UknZVvhaaBm
	 LMNWQl6gAPqArzdTLpL2ns8Z7as7YtR5A8suKloQcJuGrSLKY195PinnQrXEmDrYkc
	 YK0rx+L1HZwZA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH wireless-next] wifi: cfg80211: Explicitly include <linux/export.h> in michael-mic.c
Date: Wed,  8 Apr 2026 20:03:33 -0700
Message-ID: <20260409030333.13024-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This happened to be included transitively via a long chain starting with
<linux/bitops.h>, but it's less fragile to include it explicitly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/wireless/michael-mic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/michael-mic.c b/net/wireless/michael-mic.c
index 50cdb67f0503d..ec5164756e0a1 100644
--- a/net/wireless/michael-mic.c
+++ b/net/wireless/michael-mic.c
@@ -3,10 +3,11 @@
  * Michael MIC implementation - optimized for TKIP MIC operations
  * Copyright 2002-2003, Instant802 Networks, Inc.
  */
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/export.h>
 #include <linux/ieee80211.h>
 #include <linux/unaligned.h>
 
 struct michael_mic_ctx {
 	u32 l, r;

base-commit: 929298742bb5dfacd53ea99cf989cc81210f90a3
-- 
2.53.0

