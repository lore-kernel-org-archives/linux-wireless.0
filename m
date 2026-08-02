Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003ED390234
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785660028; cv=none; b=saH7AbGKIVr3iDsBwjnAYklrZ73v10he4SGYnLMcDdyNy7+ENm2LL1JFEqTnomdUJIDWICY3HkoS+CywKbH9bXXVU1FB/ZZiZkZrTuXUbxsczHXM06JXQna7/YREP7KwV3PZC3qLieQ1BAX1jFGZOpN8MzodNlmtaQ4hevf7Z/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785660028; c=relaxed/simple;
	bh=EjL3CArBowswo9EwHZllJ5fb9Ivl7DkyZjX+uZBWpEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J6eEz5JNpDyJB+Rj9BG8x8H8V7S9sIIAA4qfu2pLCSwIrbk7OeNp+BpEv37ylW8DaAD1i+UkRvVvLXDxxRJpmmn516acO/JXvAic3kRKX7aSjP976LstDrSIlMZ9xEAlMXGjlKQO9oeHk0zocqUkrMe0HOAxp3bUp2Fr8Xc2OrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OqdJjzaD; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OqdJjzaD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=h+q6MlI1XQFAk5NOJ+/4ZHFkbndeFGR2/w5YUQyBNM8=; t=1785660026; x=1786869626; 
	b=OqdJjzaDA/yjj7d1FgSmBR+v6yKjrI3aktlDD9I70y2sPZiSEZZUnhEblyfVuG+VuCDswNl7YRb
	j1ruW3nqKLZh3upLk+kZu0hOd5hKMOYUAo24384j75WO0r5Y2E5DR5A/3qY2jhOVGllINOP/1E0lf
	umKDz1AxLusKCNhAlnLC9B1EbbhxdsJRgOfUKB1fssVyeiinUp0DX/ErSKx3WMchVM3nTyq6E19Oy
	L01WVWKAPNp0yah3/JTP5pfrqI/T02bjVc6R0VroOmHEBkcb22xoQF7b6V1umxgYg0aCs6GJOJqVW
	KQmz7krmcfCOcUwuGuh62mr10HhF6aIwdZZw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqRjz-00000003w08-2qRm;
	Sun, 02 Aug 2026 10:40:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: mac80211: fix RCU dereference in throughput estimate
Date: Sun,  2 Aug 2026 10:40:09 +0200
Message-ID: <20260802104010.94bf0862c329.I0a05bf8ab999cb737c487d79082425257e10132a@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This is invoked with the wiphy mutex held, not in an RCU
critical section, fix the dereference accordingly.

Fixes: 2f925427e27a ("wifi: mac80211: estimate expected throughput if not provided by driver/rc")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a1759eba7b01..b380e3b3c044 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2834,7 +2834,7 @@ static u32 sta_estimate_expected_throughput(struct sta_info *sta,
 	u32 duration;
 	u8 band;
 
-	conf = rcu_dereference(bss_conf->chanctx_conf);
+	conf = sdata_dereference(bss_conf->chanctx_conf, sta->sdata);
 	if (!conf)
 		return 0;
 	band = conf->def.chan->band;
-- 
2.55.0

