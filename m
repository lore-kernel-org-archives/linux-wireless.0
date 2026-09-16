Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261144BD782
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789553072; cv=none; b=LUMRn2rQH2p31RtZTECl1QpBfy9JyA9+n879OznUDIHAtCjh8jz7lvi2rPHANGIo9E/1Ictls9CKEGUTN1ZTB98CD3cgGs0L+uIIrJzsIZLFYqq8qFb1PlKjjemD+6W03buYkrQNVGIZ89I2TmpoC6Dh2RiFi9jwxdS21fHqQng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789553072; c=relaxed/simple;
	bh=IvqTdNFGQXMXC0m6NPVizQI6U1cofb4mKAQ2BKsfp/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QHOoxb6Xy9YWt0wxfBpmw8zRSqTWbI8EOPHs4GlsesqYsVPBQErnfihHLeEpX5IVgJI+UX4xXkP2Od1HHyBItctIytW8uGXYmQCpUP+TiVqG3PN91wYPrAbr1OnnMI1gdxK5JVeTRwNRieZY+lTusppUcfT2donubuNl6oWrn1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NSGE/wpA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NSGE/wpA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=4Uvm4OtrmXpgIiwDeLqFPvcFaFnE7ElV4EeqPJTItss=; t=1789553055; x=1790762655; 
	b=NSGE/wpA+qaEref5oqX5bnQragAN4TwIZOW8a4BB3BHUxaJP993dbMIPIC+5ZcEIcqiSS8/M3lm
	jd4bOS+3Ile4/NqSb9L3AsAYgSGejfTE13FTtNySDuNL3k4rDhm8wM/r3dEQq3ZXVdjaOLtA0pUoc
	4Jlw8M6sKLLpsijAa/KanIZbsC9iCv8UnRbEGiIs0+bMmD3UrcHFZD0Kx2uTP54e9gVwOqQ3BBXfB
	Qc0sm7geFZnaqgKnefA3a/VbuvbDuLdrYk35cTEUN2nYjn5SD2TT/9gNbwH8MHRbNXnrCd9ibOAju
	scWRvEuKPSic1Rv2eGm1VY6PoPV2K4H/eiEA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6mUr-00000000baQ-00De;
	Wed, 16 Sep 2026 12:04:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: radiotap: correct EHT TB U-SIG 1 B20:25
Date: Wed, 16 Sep 2026 12:04:06 +0200
Message-ID: <20260916120406.e4c89f440edb.I8d80bba29ff7e7d642ec603098fb7d30f2db5968@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The mask here needs to cover six bits, not just five,
fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/ieee80211_radiotap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 27ee67b38ea8..ffdfbade25b8 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -596,7 +596,7 @@ enum ieee80211_radiotap_eht_usig_mu {
 
 enum ieee80211_radiotap_eht_usig_tb {
 	/* TB-USIG-1 */
-	IEEE80211_RADIOTAP_EHT_USIG1_TB_B20_B25_DISREGARD	= 0x0000001f,
+	IEEE80211_RADIOTAP_EHT_USIG1_TB_B20_B25_DISREGARD	= 0x0000003f,
 
 	/* TB-USIG-2 */
 	IEEE80211_RADIOTAP_EHT_USIG2_TB_B0_B1_PPDU_TYPE		= 0x000000c0,
-- 
2.55.0

