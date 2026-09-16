Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9994ACC86
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 09:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552700; cv=none; b=Qa+DEqmZZKb62h0sYFvMHRrZc25zTavFdJj/TqSzZ3jiKebyzqbBMj5JeY6tVRx+nVD0czPbMI586DUGqhCk85nTZT0ebL1oo/Qw89sdxL794+FjyD1f2WlTIZXzLK7CT8sAG+nJRr/pL8duOxbFSlu1OVr4ZUrz50Cq/ca5fB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552700; c=relaxed/simple;
	bh=vCWl21GCoRYtwYroMykKmfz7z4Gdpunh4+uaruv6dY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lE0Bm/KlUU0jYN4cP94rXFv+mxPXwdGAGWVthvBH35AOBDd2DmIWK5PZCd0cKLnPmqQ0r+e8F8/wzmwLQvknu9al0w5aLD4pvZkIo/8IvtJ9xG6AOoMnMbyu5Cj90IQaqhGs5hRdX4R2SX78uVN1eCO6lHeUoUh3J6Y7CWdyuSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LWTHXnDL; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LWTHXnDL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=UK1/CISKs0cV1RKxaYgcV+iHATzgrxylKv1LHZRnJPI=; t=1789552687; x=1790762287; 
	b=LWTHXnDLnSnxGX0rKnwc9Lhu3ef9dRMuRjViVv/aiT2VN45quhPcOjB726koRuBFgwWgazG8/em
	DpElThs5uNe5mfrdpv81QtjOBpvf2TRjURP9O1pec8gAbAfCRVBgCNHDvVLvgQPdHdoRWMJn4G26W
	jutR3Xxih41HjLmdzQ89rrwxCGzwOnv9Le9Bif3EpwK5yBTTxValgq9hHiehCVq9qNiPKypRZFn2B
	uX8lrnoiof3caLFf1cZoVTPi7d1oB7bm//pOh4tf4NfO81ywsvxcZkGQcgsnz/2LcNc6+OJmb//vM
	Dg7ln4ZF+q/7hvq8DO+nwnFTUJ6v8BCgikOA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6mOv-00000000bMn-1uUm;
	Wed, 16 Sep 2026 11:58:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: tests: fix memory leak
Date: Wed, 16 Sep 2026 11:57:59 +0200
Message-ID: <20260916115759.2cd8a91ed99d.I89c5068a3472e6296baf5a2d6832b733282d2b24@changeid>
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
This got lost somewhere, evidently.
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

