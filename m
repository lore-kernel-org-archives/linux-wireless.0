Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792664328;
	b=C9ZeHsrGokq4UhRECE659G5QpzI6KS3MtFO/JdCaqW6wq6kBHFxjpJqhJxJRdqCaOC4n
	 7Tds6q/6BfgVYQGe3zYWQW1p1Hs4nDCFddsZz2rrpm5QSq7LoCUcXBfnTH/EAGKOk4HRB
	 jTw4zUox6aXS6tDpyuScltD/VVaRgQ5q8zuOeiT2+dAtnVbXuHNO3RvNjEnE5vL9lpJQH
	 O3hy3KDoBFjWAEV3TSIuREnRsIaBPnlQWY4py2XKcLe+arHaEm/80I/fdvjUtE23ykVf7
	 SuKIJrB02WKKai0+KD75ShjZ37N5Zom3QVZQU3MzOfqfeKNZ4KrLHYQdl5SZ8yV3vag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664328;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kNkC55NZI9nP28JWi9xogYa13tTxGAosWNocgTEsX5s=;
	b=BqlDy6DJxDLEGO+2P/BCAJqsrYuJT9VAIbVOw/SkYshFxcRSthGluym7HCotLkC8ptOh
	 7pRQOM9Mo+JGxMdSTEHphxQHsdAattVFDeDC4UL/cSS8vV+Bm/YBslCgbTTSxev1C+uEv
	 QGfP+Pi5aUhcPLzYPebRPeE/eY/PTqsm9kpPUIYKoAjpfn3q16PWWabSRUDOQDEa3L7gR
	 seKGW66UvAjtoWlXJkARm7lHtCHV/8IrQxim7uN2P3qr2DhjHy6HXQ4PcGwLIWYect+uK
	 Nh9IUcO8xCCK40oklFQvJp+BMZ9zZJIxceEheBXxkkGV1vPbWDmRR553UscvvtiU2UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZV0rsY+M;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF186606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZV0rsY+M
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kNkC55NZI9nP28JWi9xogYa13tTxGAosWNocgTEsX5s=;
	t=1792664327; x=1793873927; b=ZV0rsY+MrQDp+sapfmR26i2BV6FgC+Op0Q0COsF5egyV+FG
	ew27IgLF3lD9gkZu0WJo0tIGCggRV9IM7a6FxV2Za4V23VGGiUBCWsjKdaMNR1fHc5m7l9aAlWuw4
	YlkRcL8LscPN32fNzTuKy6NwIHKlh4UCvRS+doFsvqqCzu8Yms5twrFp+adKMdRaOtkxP6wbaGHiE
	UgcdrhxZjChWsIf6ZVmWvx4HMXnnKcOrxXC6OKKINaKswI160pFVSoEtX5vaVjEl2Wc88HG9IWezP
	MHo2DtyFSi2+wqGHfrD/7tKDhOgY8yVVNNMaGj2j4JewJAiWJOJsZ5ipVwtjYEyg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJpsj-00000004Ifb-19E1;
	Thu, 22 Oct 2026 12:18:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 4/6] wifi: ath12k: register regulatory before wiphy
Date: Thu, 22 Oct 2026 12:15:35 +0200
Message-ID: <20261022101836.148512-11-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022101836.148512-8-johannes@sipsolutions.net>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This order is going to become required, since userspace
can query the regulatory in the window between the two
registrations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01f8c6572f65..2b52f76cff10 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -15094,6 +15094,14 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	for_each_ar(ah, ar, i)
 		complete_all(&ar->regd_update_completed);
 
+	for_each_ar(ah, ar, i) {
+		ret = ath12k_regd_update(ar, true);
+		if (ret) {
+			ath12k_err(ar->ab, "ath12k regd update failed: %d\n", ret);
+			goto err_cleanup_if_combs;
+		}
+	}
+
 	ret = ieee80211_register_hw(hw);
 	if (ret) {
 		ath12k_err(ab, "ieee80211 registration failed: %d\n", ret);
@@ -15111,13 +15119,6 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	for_each_ar(ah, ar, i) {
 		struct ath12k_base *this_ab = ar->ab;
 
-		/* Apply the regd received during initialization */
-		ret = ath12k_regd_update(ar, true);
-		if (ret) {
-			ath12k_err(this_ab, "ath12k regd update failed: %d\n", ret);
-			goto err_unregister_hw;
-		}
-
 		if (this_ab->hw_params->current_cc_support) {
 			struct wmi_set_current_country_arg current_cc = {};
 			struct ieee80211_regdomain *default_regd;
@@ -15158,12 +15159,6 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 
 	return 0;
 
-err_unregister_hw:
-	for_each_ar(ah, ar, i)
-		ath12k_debugfs_unregister(ar);
-
-	ieee80211_unregister_hw(hw);
-
 err_cleanup_if_combs:
 	ath12k_mac_cleanup_iface_combinations(ah);
 
-- 
2.56.0

