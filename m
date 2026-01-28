Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249DF274FFD
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2026 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769606663; cv=none; b=l+gz7WhfFdlImJAran9k/nFcpXf+HSvzHecmrDmzSNedwKcL5SbnhEan+wcVni6P8HTTeeERVBERN3uiZTLAiw6S5uDDnRo02S82IZgI68NCxjrTtb7la/o2+3Mw7k87WaSzlgRG4DR8m/yDxgomM6w6Ja4LMtYZXfEna4uhnSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769606663; c=relaxed/simple;
	bh=/tzf+cJgsv5eG+3z0BwZuP7a6sC/9iLYcrKLRlQxDok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vcd/twz4ONcOHn5albKx7U4oE16Q1Fw8CqFWA7xKqpfwCQO3ND+Mrw3vvo0K1wEcoa1tC7f0zoyCryG2fh0BcTDzygLqgFNoQIIsJVDtKnWqn9r5+VMDKaTrRQiVcu+cbMltGaJGMhbw4QDYi6B9r3UZCU/1o+5XpGUqv0/+HnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aGWo+DHR; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aGWo+DHR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=XEEN2WEfATm/8/n72PnDahNu2kGpXiJVmA2vo83LMLI=; t=1769606662; x=1770816262; 
	b=aGWo+DHRtJxsvQIJCYq3CZDqPW5dw6eH0vfhw+/JukUbSSx3D0s0/v1OYkWLnOVbSxwZ/1XQ2G5
	QZY3wGgf1GDGcJ61CKvTt9F6G8IB9rI8yym6wu2d39R/zGjk5MlcntFgV4NIbbopD1JDl5e5L+Si0
	2+WMSJ62ignQueRb7VaR9+bNFsGsjCqh1wlRYPC2A2VRTGHE63fbQcygEkulLBv2GOzFvydl7TS+3
	Jcd9oNiXDpiRjb+TCay+SaaT9ycsurgW7lzjqCOhgkXfyx+KlxQUEeWBJizAMfOrsMuh1c/G87xJt
	pre6SQx1ZDOaHLUgGKRzlZq2JO+gQhB/SQtQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vl5Wr-00000005rMn-3Vf2;
	Wed, 28 Jan 2026 14:24:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: give the AP more time for EPPKE as well
Date: Wed, 28 Jan 2026 14:24:12 +0100
Message-ID: <20260128132414.881741-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

EPPKE authentication can use SAE (via PASN), so give the
AP more time to respond to EPPKE case just like for SAE.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index df170556825f..4f4d6449555d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -8408,7 +8408,8 @@ static int ieee80211_auth(struct ieee80211_sub_if_data *sdata)
 		return -ETIMEDOUT;
 	}
 
-	if (auth_data->algorithm == WLAN_AUTH_SAE)
+	if (auth_data->algorithm == WLAN_AUTH_SAE ||
+	    auth_data->algorithm == WLAN_AUTH_EPPKE)
 		info.duration = jiffies_to_msecs(IEEE80211_AUTH_TIMEOUT_SAE);
 
 	info.link_id = auth_data->link_id;
-- 
2.52.0

