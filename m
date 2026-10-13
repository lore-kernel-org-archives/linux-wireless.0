Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133023876A7
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 02:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791858753; cv=none; b=Xct5z0LTdpZ0hTTkC7eX1AkBd76fQ9LgHzWkG4xgendKYz0QaivmhHSKr84FZ9K8OyaotyU3v7egV42m2Z9mBBtO1flnAE36Yqq9ZpCsrpDoWfH89Jx024/ztbjLyUFIxQz8YQPMgg2/8mkJkZcoDy6rHmbj0idjTJn5JcoujtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791858753; c=relaxed/simple;
	bh=CFeIizV/ohM4nsKGTtqP+1pX9vJul0jNM2f7REEk6GM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BKfIEiC9BtNYcNXZeLodTcMA5OWudWLxPEc6MKVhLyFjqyCs2LqqIexH1XpwazD0piuHbYBgpF7JTfdv+1NlwKAic6IlwmdB+jigbmYzjuFqtMU8vN4TNzoQ+ekBJQxfdvFaZrwrN5Jv/ae3zJTOEb3K+ggBl0w+83f7p7IxUOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=bMO4krmx; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="bMO4krmx"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69D2WR3J0139358, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791858748; bh=Ov8iAOb/Zf+I3ltPJguf0KvyDJ+Wp6wSCcSYk8GMTlE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=bMO4krmxwPheyKtr/6HsAhgIMCBO3e5LPCRVU4fbH5SbuU2iEeabU94/HoqVLrX7r
	 UI2/yK/DXOmCUOpHHG2YwNymYkHCHZfrn1lPFp2Ec9a3izK0zhDvClpCNVxWaa+8gF
	 i0RAk6X/Wib0w1d+E22x7X5D1BaRcplE5KLtqF8UlWpBBDkJtUlCBB5wXtHTyyWOAc
	 xW95b1kYJzbKam9JfBPHjEbG09LXX+tkOHcqMz4yh0CL6n8qk92xC9bq93R+UvqbHJ
	 Kf6FScUI2R06b3moNXSCoY4Cbtao4oi4ohCOjKKKMJd4+vBwVjQDTT3X0aE8kYl/TB
	 pRvlRSIahqnoQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69D2WR3J0139358
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 10:32:28 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 13 Oct 2026 10:32:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 13 Oct 2026 10:32:27 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 13 Oct 2026 10:32:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH rtw-next] wifi: rtlwifi: correct unit of center_freq as KHZ passing to freq_reg_info()
Date: Tue, 13 Oct 2026 10:32:21 +0800
Message-ID: <20261013023221.12024-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The unit of argument center_freq of freq_reg_info() should be KHz, but it
wrongly passes ch->center_freq in unit of MHz to freq_reg_info(). Correct
the unit.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/regd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index 503625b50fc3..2e4c60886c1e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -153,7 +153,7 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				guard(rcu)();
 
 				reg_rule = freq_reg_info(wiphy,
-							 ch->center_freq);
+							 MHZ_TO_KHZ(ch->center_freq));
 				if (IS_ERR(reg_rule))
 					continue;
 				/*
@@ -217,7 +217,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	guard(rcu)();
 
 	ch = &sband->channels[11];	/* CH 12 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
@@ -225,7 +225,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	ch = &sband->channels[12];	/* CH 13 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)

base-commit: fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
-- 
2.25.1

