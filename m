Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC9E49553A
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 16:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648313; cv=none; b=BhD94tCsWOMF04TPyhv2peY8bPJBGZZhh+wxsLhcxLAExEgQiuFU0YoXOexW6olE6ea92eIpC9c5VZ0Uj12atbX2eOCbbhmapYZabiNHJ/w8dh/G38xZUd4KNOlIQ+0whPR9q9jWy9OjkT5M0xRF8fM+YKeShhbsbJgvWykYAvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648313; c=relaxed/simple;
	bh=PelP6hTuiUvXdV4AGMSi6Qh5lAZDjyGinbnNgWFShEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ntd3H2WbQBopFUgJKvYUyvltqFjmJaphYz3T1IhXtddlPzsnVXe4Q32VKRkby5aTDS4xRjYBNpfVc/Xkqq5z+Tp3/gYTuaKL+/yRt+duAV091BmT4H0ZTp6OLj0+zIYjlCePx8eH/MuU5h8EBpuraDo+gCOH1V5ykB4fraRhL3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AE55i4Gl; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AE55i4Gl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zWM1kdBTXljBv4eDABWbqSDjrgPcLoPQ5IINtiMzFeg=;
	t=1791648312; x=1792857912; b=AE55i4GlN1N8nzuP0Pw8GfMFGqrMF8WOyvmg00BdWY2Jbta
	A6D5FjrbhDIh/zWutc5FKg4bmCWbYiMu56hn/ju/4R+bILt3wo5Zd0xDhbC3B+cecJ9HO4YogQK2Z
	rqIfBvgSSipR20CYWmSmhYHALas0boPdclDx7EmcgyVEBsDKrr1VnAdkHKknydx0P8kIDCBlnDWLq
	Kd7rlRv6nV/0RiZD+12hR5MHNJCv+pEGSc8U4Ob2Oupz8keuKs3Czo9v9TWQrz+VMJPiZUEbf9EQv
	zfKcvhOzmoengTLAAViUPL8/UyuRD5a+obruLFCqsWTyuhqSeP3LpBgJkoPmplhA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFZZH-0000000CP1z-3Rgy;
	Sat, 10 Oct 2026 18:05:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH RESEND wireless-next 4/9] wifi: cfg80211: switch wiphy netns under cfg80211_mutex
Date: Sat, 10 Oct 2026 18:04:16 +0200
Message-ID: <20261010180459.89f391aea519.I7529b9055f522cfeb8a26ae3a85c1b71a98e8192@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261010160459.229064-11-johannes@sipsolutions.net>
References: <20261010160459.229064-11-johannes@sipsolutions.net>
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

