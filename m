Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5257B34C141
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704685; cv=none; b=KToY4ZYGUazb+TBT1gxC4l3NDM3h7/D17YbUxnjYs7hwXET+LA3hVSxF4j/Z8MIdACuFY6d8GP52iTOBIiD4d7u5F6ZWM3pJCY1Sb1lCSd22uMWDDCloO8rVKzaRjxXCMmbWQCDwrHIc5OoU8zF5t7PZiFHQswHH5nxC8HZ41dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704685; c=relaxed/simple;
	bh=rGMbyhib4zZcg3k4zdkgCRV8ZgOgMOEaU/d0FumPSQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n8yDc6C/NEdW88Acmgu6RIiQ+IeVWB3unwNNE2UA/IVVFtrBNa5v9+cRiV1vhTMgFvvxf72OnSk6m4sJ9uwhCLDCro2p9A4tI7UgoXR6IEUN5xKshzGFQAdLiUlkz77IbrfQxjMWWZFF+JZkn+TmVqlJrLnLul80sBdbBW2rtLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJzyLD7A; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJzyLD7A"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a022fee0caso6433025e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 00:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791704682; x=1792309482; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xEpLIief8ocWMfrgYIPs7JbK9l0pcCQt5z82oKv+qFc=;
        b=VJzyLD7AGHCkW4mUPuNXfGmJ6B6CkOdQKonl0VVjZP457cyFHZEwn5bBXXAdGYK/In
         wc9gF9xVwhlquB2zIsg1/jStc7QcF3KVuf31Rtjxa9XAh0ww/CP14lVPYeQKMFv10kry
         yiN/DSDayLqc3YfJWz2y+a1p8qiqu1Iq4l4qOs+Z0YKPeJ0VwSo4vR1qmIQ/BwEd/NXV
         GWBxLIZKl683SBrKTfoeqPJ6aXlNw915JDnl2hy7Cc8qyJnSwXeyE+AR4AbITKJAGwTh
         QeC9V7ttjsSFRBMtlPguidziWhR1NJK7nRPxdL1KcAwmarWWRTCbY7rsYLnIleeT0ZN6
         z6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791704682; x=1792309482;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xEpLIief8ocWMfrgYIPs7JbK9l0pcCQt5z82oKv+qFc=;
        b=c6o19dWqJQ19MHE5cKRlS9M2YHZecTQrk6DlRyr2XZ+TVQgPUMzX6vc/uz1vHftPbs
         jfWrAielyfHk1CNgSMfrzAvkCuqcahxP7u0/dpotHMIJtGqBh6MjUdTKbT3nFD6V/e1y
         4QLen4g/6SueoVY93O3uuwbLfirjbj9mzkxIeDfe0lQoSSRb9lBB5o+8CCmY1LsfxpKB
         3/Sxc4XN9tcnxQFvO2EXtJafLY6RKmNFnqXjAVvvZDw/2rDYe2zznLyoRNe1mqTW1vF2
         nIzm/k1WH+JBiPCYT/5/ZiweVUZ34hU6TFD7EJJpDM25OnbEsXOxhJEbN3swAKaJ3B9p
         ctQg==
X-Forwarded-Encrypted: i=1; AKwUvByYEdEixfgTedmgX4SEnFw7XAFD2izGN+rxLMxGZr2Nqu5qmtmRR7iT8vGE9xJqlXtdXxAi5Z98VvkaIaNc6A==@vger.kernel.org
X-Gm-Message-State: AFq9FYKsXVcjw/A8IDTK+DCK45LaqsrxyorB+eRSQEF5nZwGKF45bOdE
	lPF/QCu52vucvt+X6DT1vcVVv7nyHQVHnMDHOUdKKo6CFyFa5ZsgtIwP3AC9UOzhGjQ=
X-Gm-Gg: AYBFou0LLmHLiTSaacdDzrZKLuJDHqA5J+Y0FRNCygwhtjjeGTKqjaJCnQTtG6tacsP
	cG3iaSZe8iHC+DTn7rIXHgscBhBGN4Zj28Llfh7dX2kxTIT9mhuEgbxo91ags4RDD999hTGdV0s
	H3z06vTQzy5+iux//3rbwtKj5++LDSGZvTJc65S3wSntE9QcMUKMjFwv985WyNJv0qBvChveX3N
	AQjqTCI+uAcxnajlI8DLOIle5jhhgxv3KCi4ZOmwq7dn7UdeilsMY/pCW4w/PF7cjwo/U83qpDE
	9U4J0m6zvg4dr3Kjsrg0NLJk13IW9np9731Ad0N7DhDvf/XzSrdePMeK9ddmfdeEaA51cmMBQkz
	Mz3R87ZUwWN5P7DWhQx+gzbySgVT+UlFsd1uDpGxIuqsAY5JZS07HPvij6hM9PYrU5H8gy9zyGf
	+YzRJ38O0x/HKykvHbpF5iJ1s8aIk8kHlq3kNyQJTEJDjsvXdo4NUBJ8OoaOyZ1G+tp3Wfb2YOh
	V2x7pumAbjlqM1xqUx7xw==
X-Received: by 2002:a05:600c:1906:b0:4a1:71ab:63ba with SMTP id 5b1f17b1804b1-4a18e4e5c87mr117687715e9.29.1791704682296;
        Sun, 11 Oct 2026 00:44:42 -0700 (PDT)
Received: from FranzSP11.tail2d6612.ts.net ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a198c80cb3sm47912325e9.3.2026.10.11.00.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 00:44:41 -0700 (PDT)
From: =?UTF-8?q?Fran=C3=A7ois=20Roux?= <franzelfranzel@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath12k: set the regdomain before registering the wiphy
Date: Sun, 11 Oct 2026 09:44:33 +0200
Message-ID: <20261011074433.9187-1-franzelfranzel@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath12k marks its wiphy as REGULATORY_WIPHY_SELF_MANAGED, but it applies
the regdomain received from the firmware only after
ieee80211_register_hw(). cfg80211 announces the new wiphy to userspace
during registration, so a GET_REG request sent in that window finds a
self-managed wiphy without a regdomain:

  WARNING: net/wireless/nl80211.c:10828 at nl80211_get_reg_do+0x1d0/0x1fc [cfg80211], CPU#5: iwd/721

iwd queries the regdomain of each new wiphy right away, so this shows up
at boot. On a Microsoft Surface Pro 11 (WCN7850) it happened in 3 of 4
boots.

Apply the boot-time regdomain before ieee80211_register_hw().
regulatory_set_wiphy_regd() only queues it. cfg80211 then applies it in
wiphy_regulatory_register(), which runs under the RTNL before
wiphy_register() returns. nl80211_get_reg_do() also takes the
RTNL, so userspace can no longer see the wiphy without a regdomain.

The regdomain update no longer needs to unregister the hw on failure,
so drop that error path.

Tested on a Surface Pro 11 (WCN7850 hw2.0, WLAN.HMT.1.1.c7-00108) with
next-20260929:
- without this patch, every driver unbind/bind triggers the warning
  (12 warnings over 6 cycles);
- with it, there is no warning over two boots, two module reloads and
  17 unbind/bind cycles, and Wi-Fi connects each time;
- with CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS and the user regdomain set
  to CH, the wiphy ends up with CH after each of 4 unbind/bind cycles,
  with or without this patch. The user hint handling added by commit
  906619a00967 ("wifi: ath12k: handle regulatory hints during mac
  registration") still works.

Link: https://lore.kernel.org/all/20261006161744.3804-1-franzelfranzel@gmail.com/
Assisted-by: LLM
Signed-off-by: François Roux <franzelfranzel@gmail.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 196b80721..1208c1698 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -15041,6 +15041,18 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	for_each_ar(ah, ar, i)
 		complete_all(&ar->regd_update_completed);
 
+	/* Apply the regd received during initialization before registering
+	 * the wiphy. It is self-managed, so userspace may ask for its regd as
+	 * soon as it shows up, and cfg80211 expects one to be there.
+	 */
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
@@ -15058,13 +15070,6 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
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
@@ -15105,12 +15110,6 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 
 	return 0;
 
-err_unregister_hw:
-	for_each_ar(ah, ar, i)
-		ath12k_debugfs_unregister(ar);
-
-	ieee80211_unregister_hw(hw);
-
 err_cleanup_if_combs:
 	ath12k_mac_cleanup_iface_combinations(ah);
 

base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac
-- 
2.56.0

