Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDF53FC5AE
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 11:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498746; cv=none; b=NbKJNRVDiVbq718oomieBnTGYYBytAc8zm6EsTmLv05UYN2dnwfgW2/4GDk2XBnNijQeASq3l/szXwVRCEhNHpkWaF9CiQuvB91DNvjIVHvstHUdUWm63zR5YmwXitnLFrP/qHYZUKUtBDs6ZLrr0GbnPA34sMqffs5MzzizTD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498746; c=relaxed/simple;
	bh=Z/3Y0cAOy7pvswJBpGCWGgs2GK/LVqXDUk1EHBmTtz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=niQS8woXkgaTxU9i14tua+S8y4DYK/TOy6orW0jbp3xro1rXn4y4GkS7Oii44bsI399LsP7ERH2apdpBUs0y41wcbj+Krzir/L2m4UuoDBZdDCeRAHGX2pFVte6hk8Ki5ELBITrpR/C3PCFqSnYEs2wuM23FVT7LyUAdWoTMM2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=p2YrEoIk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="p2YrEoIk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=UqHsbgRtCsLYkYOsPHwW/i6AUDd6bkjdtb8eKGSoF7M=; t=1785498744; x=1786708344; 
	b=p2YrEoIk/Zn3tiL+va7ZswCSWI1xt29aMSMLsMYIkDns/DBs9DYp7Wz6Ta7U9wKS+kwiKMrV1MC
	Be7t4gy7VZwr7WDOwwSCEO2cv0oXEBAB15OkF8W/8gmcUC6X0LTtu4mIAgm/I2+xu+/Nqps1goQiZ
	uJvZmDnA4v4FhtvzOjhvyAnGHJk6JyZOyYv8wHUYq9oyI7qYZS9X25zB6HCY0/o6qOa0376QKpTG8
	SY3e5sL1uEU3kMlZ9vyo8QC4z1e+ryAKM1wuVrKbxq6UFEV9wW06r2lSjyZC4FuuM+7zr2lgvSLDs
	DurZ44J2ejG/N3I2DRnJ93pbgfh+Oe3fPvZg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wplmn-00000001X3M-21UP;
	Fri, 31 Jul 2026 13:52:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: mac80211: tests: fix memory leak
Date: Fri, 31 Jul 2026 13:51:23 +0200
Message-ID: <20260731135123.ba9fcad77dae.I89c5068a3472e6296baf5a2d6832b733282d2b24@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The code allocates the bitrates twice, but really
only should do that once. Remove the unconditional
allocation even though it's the same in both branches
of the switch, since the cleanup only handles those
two branches explicitly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tests/util.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/tests/util.c b/net/mac80211/tests/util.c
index 0b01264af577..89ff4f389de3 100644
--- a/net/mac80211/tests/util.c
+++ b/net/mac80211/tests/util.c
@@ -2,7 +2,7 @@
 /*
  * Utilities for mac80211 unit testing
  *
- * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2024, 2026 Intel Corporation
  */
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
@@ -226,10 +226,6 @@ int t_sdata_init(struct kunit_resource *resource, void *ctx)
 		sband = t_sdata->wiphy->bands[band];
 		sband->band = band;
 
-		sband->bitrates =
-			kmemdup(bitrates, sizeof(bitrates), GFP_KERNEL);
-		sband->n_bitrates = ARRAY_SIZE(bitrates);
-
 		/* Initialize channels, feel free to add more channels/bands */
 		switch (band) {
 		case NL80211_BAND_2GHZ:
-- 
2.55.0

