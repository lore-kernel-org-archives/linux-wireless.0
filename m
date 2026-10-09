Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524A42475CF
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557839; cv=none; b=q4xJ7c+C8PrQZ4v6cuv00anzv1k1yUczlCkRkEbmoFwF2d1ibhrPnZpeSjIveHwdBEXnen4AfeACm1feBearfhZAn367H0qYWeEsBjn94OnWg2oGTLQnR+QGBGXOifKHBywXfvmqgk0K0Gg7dlmP9zkafLcIEm1u9aPgy8Zk5+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557839; c=relaxed/simple;
	bh=PelP6hTuiUvXdV4AGMSi6Qh5lAZDjyGinbnNgWFShEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBMNPYvHkNBPTzuPQyZKGZfDp4FRTQt7eTFUOR7UXtH7SI7Yq5yOE7cNbKTT5/4IcJrGWw5xab5G8sNJuUftDfSpbNeHsPZ6FXEEXNjdyU2hAQbTbblKASINYRRi+CV03yMsTdl3c+6UXmYnd7hgvWkXY8qDFOJ/Q1Ium2sr8PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=sAdPNo5U; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="sAdPNo5U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zWM1kdBTXljBv4eDABWbqSDjrgPcLoPQ5IINtiMzFeg=;
	t=1791557838; x=1792767438; b=sAdPNo5UgpqQZnXUglYdcK+AFn5V3BhKud1XcKgCVNO5TKE
	ZGtwjehlhrCgpCzLIX2+LjlNNmjHfvngnlmxsrZAsgcs7HLqMedMFEF0cTi4ScQrt263BmCszyO+F
	VVWEKzq9sLjfOvEOVTgvOz/ujQr1/x2VoEGta8TP2ClNe4mcUKiB63dPeZGvwJS7HNFwBwVAE9Boc
	ULieVmQ9mkcANyu3qz/rlow9WqwSbJLf0pCGzLu/80Wn96JLYY9syk0Cz3HBj26h6yCrW//ZShKx2
	M+oE7tcK77vDqeBfmKFIQziYvm6x4R2BBstXye7YHL6jgQAQQE01bG5S9E7aa0Ww==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFC22-0000000AlEW-2Spb;
	Fri, 09 Oct 2026 16:57:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 4/9] wifi: cfg80211: switch wiphy netns under cfg80211_mutex
Date: Fri,  9 Oct 2026 16:56:19 +0200
Message-ID: <20261009165703.fe050bc9a513.I7529b9055f522cfeb8a26ae3a85c1b71a98e8192@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009145703.243031-11-johannes@sipsolutions.net>
References: <20261009145703.243031-11-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Hold the cfg80211_mutex across the whole netns switch, so
we can walk the wiphy list without worrying about a wiphy
switching away to a different namespace underneath. This
will allow removing RTNL from netlink dumps.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 3 +++
 net/wireless/core.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 01b077909179..d648df6b8037 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -171,6 +171,9 @@ static int __cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev, *tmp;
 	int err = 0;
 
+	/* make the whole switch atomic for cfg80211_mutex holders, e.g. dumps */
+	guard(mutex)(&cfg80211_mutex);
+
 	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
 		err = cfg80211_switch_wdev_netns(wdev, net);
 		if (!err)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index dfcb9ed5035b..d327c7f4fc12 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -19,7 +19,7 @@
 #include "reg.h"
 
 
-/* protects the wiphy list and regulatory state */
+/* protects the wiphy list, wiphy netns changes and regulatory state */
 extern struct mutex cfg80211_mutex;
 
 #define WIPHY_IDX_INVALID	-1
-- 
2.56.0

