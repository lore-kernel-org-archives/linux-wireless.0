Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3709535CB9C
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896945; cv=none; b=RXfkvSAX4777TkWRtOUiQEtWgP6X7lBvFGQgLqxX5EC9lhHPAb0Fds6F9rdfpIkN3tu+NbAbejxTQKFkvhWI+DOUU9IDeoUasKd+1oKyPis4gfbdr9ukYjJZO1IwDaqPBKctVUioxgkIh2qHEPij/z6uxpht1+sGQYDd09TGrus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896945; c=relaxed/simple;
	bh=UE4F/36Y+VB4RHmj/x7vrkLgQvq2N9uVLvA5mquovwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sVTK/WyztU+rytJTCwqZx+tEG6ss+7v+EAf1WKGg7aeRfPBnV4kw306CFAvt8BGUlrZ+a3/6IqCfLmCDnQ5ny+0hS/DR8hYvWnQLnGbGRcCICCNt+8n43FKXIMvCAKeE87NKcMAw1Kv48rj8GkD/DSd4ySCuSL2IAfyc+Ki8OKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=G2sTN9JH; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="G2sTN9JH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=X+MhEjcikQzxfjLoMsm5k3r8N/EGvG96nfVcU7Yv8kY=; t=1791896944; x=1793106544; 
	b=G2sTN9JHJGrECJrAIjMQ8ZTpH4XrA+HJAgwNv8awI7m95YKil4Y6LUT2MrGz7vXndenjzlSM/a3
	RKAPu8bnVyLzS5SBFiIlm9di57TWfQcf5zZadMkH6C+3LYEz3MulQ53JVYFennkVZi3UTTWZ9mcEY
	wFr/bbyr+8V30TMUy57bRcM+0epMiKMOCD/Vuws6n7hmEtzo1grRg+seo7OY57NDMIu+OzkqoXFod
	/NMIPQR463ddzVAGok6pwBFr/A8QqQesWlxFgr/VJFgNSw/IEoi5aQL4dySA6mWhYFxFGHRLTbbGa
	ZbfNlumi2UcMZxx1lp0qva8qy6LfmH7GOebw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcFY-0000000HPbN-3EaY;
	Tue, 13 Oct 2026 15:09:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: mac80211: remove wrong unit from TTLM buffer define
Date: Tue, 13 Oct 2026 15:08:59 +0200
Message-ID: <20261013150858.1120d070af16.I6a6ea0b8d8f3eddfdec5c9aeb75e597745a49ae3@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Having this called IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS when it's
actually in microseconds is wrong and confusing. Just remove the
unit since it's only used in nearby code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index eebdd8a12f52..9216756e2307 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -45,7 +45,7 @@
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_ASSOC_MAX_TRIES	3
 
-#define IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS (100 * USEC_PER_MSEC)
+#define IEEE80211_ADV_TTLM_SAFETY_BUFFER	(100 * USEC_PER_MSEC)
 #define IEEE80211_ADV_TTLM_ST_UNDERFLOW 0xff00
 
 #define IEEE80211_NEG_TTLM_REQ_TIMEOUT (HZ / 5)
@@ -8004,9 +8004,9 @@ static void ieee80211_process_adv_ttlm(struct ieee80211_sub_if_data *sdata,
 			/* Link switching can take time, so schedule it
 			 * 100ms before to be ready on time
 			 */
-			if (delay_usec > IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS)
+			if (delay_usec > IEEE80211_ADV_TTLM_SAFETY_BUFFER)
 				delay_usec -=
-					IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS;
+					IEEE80211_ADV_TTLM_SAFETY_BUFFER;
 			else
 				delay_usec = 0;
 
-- 
2.56.0

