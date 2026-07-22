Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0A6379C38
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 07:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704068; cv=none; b=IwJhXZ9tTDPMhovolwkd4OpwxYGA7zlAFHLSReZGhfFqbJN5d/zZMyq3fMytACsT4pBlOCITc8WfqgT8GYa0rfEPtu2xucPcibM3CngyxXxqlbP66nzWLADXpefG9lUvGTW59sTX5LTI6b5hXjsILFa4Z4JdHOEuQoOo1NCUBLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704068; c=relaxed/simple;
	bh=+X2E/22QaYLRENUgNqGRydH/mkfev9mfmAWEy06FM60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gb2pJ4Pzt9TCdXTploQK89zQZWXtQ4jI5KTOeuCL+JxyBJapnKGLL368iyZrMPBloRusbtfDh2UMZkILbbJocxpEuUayaPzA6AYEi+SIcNJiSsrJXVEfl4uVqMwqt2/qgoP6sSWXtFyhXszBMKV6IkGt2SWZrEjngbeCudVueSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=empDKopO; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="empDKopO"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4954dff6536so31760085e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 00:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784704065; x=1785308865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rzOcSgcI8Ri1oJDweL+5pSLHXb3yiUThMbTxJzoHi0U=;
        b=empDKopO3dMAdZ4wE3tWvA5T6y04qrL9dLaiTPlDgkrX7hDkXAnbIwl7T1/PPRvwtV
         7NvNpgadWSMSkOQnZLXBvZJsZWP1PHonUSCOcXxw9I6mJRw/ngpFYPdg61/I4+oHykIw
         jQrDc3ppaEgpDs2nR2JDpzMEO++DWkLcQ9IZsZd7MlQhasa7EdLou1ThG4kdZQRaNgK4
         TxxYU72qphFyus5jC0nzJ/Bahm7rEbK6UlfRSDXI0jFFGim4LnYEk+PbWoStN80AX3ju
         lelCV/iMaO/3i1yWR1ppaLuPRx2l3rOPYRRWc2H0TVUFNgf/mML4hn9slFbgufCcmNFi
         5UUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784704065; x=1785308865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rzOcSgcI8Ri1oJDweL+5pSLHXb3yiUThMbTxJzoHi0U=;
        b=EZSv3Ap9Dxdydo8Ynk1caZr4nsHackGO6qicSPN/dsCOxZpPq4TpU0/SHSm/GFCDIy
         NS1e0zp8iQ2L+a3/fPrxG45fu+PY+UVbgvJqMAeA4oQXTeiJzoEZef/sGY/7sNdjhZeA
         8GPcc/zk8Kr5N6BMMmmc1dUAMN6D9X5i8A7OzJG+elf9eEda4TuKWTuphjIF6eK734ul
         AFDxak8c8TpQ/Uo/lLTB8ZnSDa3vhAXgS5+eloZFiHILWgfqYNfdgrh/oDSrCTKxUylX
         b6qQBIJNBZOVQD8PXe/zIc+/ko2ETzagK4+a6TVz60400b8HE5t5CIuAGNCIfMJORw5i
         6M2g==
X-Gm-Message-State: AOJu0YwpTaB4NlusdV6tQZrsy4DtRSju/HyePLdJOsZGrb4R1bKBSV7e
	beSWJalhqpN4bmmYyxdVyKITYdjQGGyNuM1N4m/AFHn+e/uJ2MDh6vbR
X-Gm-Gg: AR+sD10vP3c+o872GFZvx7+c3YieodEy4a6MiE8bPHnJxQji49wwsLjxVsxIzKyle7M
	ADDu8M5b4jfjn/SY2E2E+/Tpr+4M4yVzd+uRwMiOoPfURbZafUbFrWYILvFnRqmcs0ZM64iGsmI
	JWN3w5vJJ0oSPNkc7wkQjeDEJ9XCrTEgx9dE2noZmoQvx07q8HraBxif+zEoFYanhzN4oFoMAKU
	hETGABEjwVHno35uHbrtq2gP38KByFDLSc97tgKRwCF33oxVDr11CmKiaEOpThTXD14jHl+r9bS
	mWWWvYCHPIGyoCFMVz6+xSuF+VlFdKrnNsVt22QIJfFv+n3TgTBXwSKsqQ4DkU+WuXR9+Njy5Hj
	F0VWS/31tRIZoQPMBSHa90+KCDBiuHnpG1G5wbdqMWhRJzdZSkT/77KCciI48h4NEpx+nV7pV92
	CcoCGKuG0yEM+TIcPYTQNbXJl0vA==
X-Received: by 2002:a05:600c:4505:b0:493:f176:dc69 with SMTP id 5b1f17b1804b1-4954a413087mr230313795e9.37.1784704064934;
        Wed, 22 Jul 2026 00:07:44 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956bc68d4esm18301485e9.0.2026.07.22.00.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 00:07:44 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: [PATCH v3 2/2] wifi: cfg80211: tests: check BSS lookup failure reasons
Date: Wed, 22 Jul 2026 09:07:34 +0200
Message-ID: <20260722070734.3612581-3-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722070734.3612581-1-loukot@gmail.com>
References: <bbb15b0ae332d7344f5b69da5e993acc6813aca7.camel@sipsolutions.net>
 <20260722070734.3612581-1-loukot@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a KUnit test for the extack failure reasons that
__cfg80211_get_bss() now reports: no matching scan entry at all, a
matching entry that is expired, and a matching entry whose use_for
flags do not allow the requested use. Also cover the cases that must
not report a failure (a fresh entry, and an expired-but-held entry),
an entry that is both expired and unusable, and the combined message
when one matching entry is expired while another is current but
unusable.

Signed-off-by: Louis Kotze <loukot@gmail.com>
---
v3: message strings updated to match patch 1; the cross-entry case
now checks the combined message.

 net/wireless/tests/scan.c | 119 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/net/wireless/tests/scan.c b/net/wireless/tests/scan.c
index 2fc717317ac3..8c20278b5d3a 100644
--- a/net/wireless/tests/scan.c
+++ b/net/wireless/tests/scan.c
@@ -402,6 +402,124 @@ static void test_inform_bss_ssid_only(struct kunit *test)
 	cfg80211_put_bss(wiphy, bss);
 }
 
+static void test_get_bss_miss_reason(struct kunit *test)
+{
+	struct inform_bss ctx = {
+		.test = test,
+	};
+	struct wiphy *wiphy = T_WIPHY(test, ctx);
+	struct cfg80211_inform_bss inform_bss = {
+		.signal = 50,
+		.drv_data = &ctx,
+	};
+	const u8 bssid[ETH_ALEN] = { 0x10, 0x22, 0x33, 0x44, 0x55, 0x66 };
+	const u8 other_bssid[ETH_ALEN] = { 0x66, 0x55, 0x44, 0x33, 0x22, 0x11 };
+	static const u8 ies[] = {
+		[0] = WLAN_EID_SSID,
+		[1] = 4,
+		[2] = 'T', 'E', 'S', 'T'
+	};
+	struct cfg80211_internal_bss *ibss;
+	struct netlink_ext_ack extack = {};
+	struct cfg80211_bss *bss, *bss2, *found;
+
+	inform_bss.chan = ieee80211_get_channel_khz(wiphy, MHZ_TO_KHZ(2412));
+	KUNIT_ASSERT_NOT_NULL(test, inform_bss.chan);
+
+	bss = cfg80211_inform_bss_data(wiphy, &inform_bss,
+				       CFG80211_BSS_FTYPE_PRESP, bssid, 0,
+				       0x1234, 100, ies, sizeof(ies),
+				       GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bss);
+	ibss = container_of(bss, struct cfg80211_internal_bss, pub);
+
+	/* Fresh usable entry: found, no message is set */
+	found = __cfg80211_get_bss(wiphy, NULL, bssid, NULL, 0,
+				   IEEE80211_BSS_TYPE_ANY,
+				   IEEE80211_PRIVACY_ANY,
+				   NL80211_BSS_USE_FOR_NORMAL, &extack);
+	KUNIT_ASSERT_PTR_EQ(test, found, bss);
+	KUNIT_EXPECT_NULL(test, extack._msg);
+	cfg80211_put_bss(wiphy, found);
+
+	/* No entry at all for this BSSID */
+	found = __cfg80211_get_bss(wiphy, NULL, other_bssid, NULL, 0,
+				   IEEE80211_BSS_TYPE_ANY,
+				   IEEE80211_PRIVACY_ANY,
+				   NL80211_BSS_USE_FOR_NORMAL, &extack);
+	KUNIT_EXPECT_NULL(test, found);
+	KUNIT_EXPECT_STREQ(test, extack._msg, "BSS not found in scan results");
+
+	/* Fresh entry that is not usable for the requested use */
+	extack._msg = NULL;
+	bss->use_for = 0;
+	found = __cfg80211_get_bss(wiphy, NULL, bssid, NULL, 0,
+				   IEEE80211_BSS_TYPE_ANY,
+				   IEEE80211_PRIVACY_ANY,
+				   NL80211_BSS_USE_FOR_NORMAL, &extack);
+	KUNIT_EXPECT_NULL(test, found);
+	KUNIT_EXPECT_STREQ(test, extack._msg,
+			   "BSS cannot be used for the requested operation");
+	bss->use_for = NL80211_BSS_USE_FOR_ALL;
+
+	/* Expired entry, > IEEE80211_SCAN_RESULT_EXPIRE (30s) old */
+	extack._msg = NULL;
+	ibss->ts = jiffies - 60 * HZ;
+	found = __cfg80211_get_bss(wiphy, NULL, bssid, NULL, 0,
+				   IEEE80211_BSS_TYPE_ANY,
+				   IEEE80211_PRIVACY_ANY,
+				   NL80211_BSS_USE_FOR_NORMAL, &extack);
+	KUNIT_EXPECT_NULL(test, found);
+	KUNIT_EXPECT_STREQ(test, extack._msg,
+			   "BSS entry in scan results is expired");
+
+	/* An entry both expired and unusable reports expired */
+	extack._msg = NULL;
+	bss->use_for = 0;
+	found = __cfg80211_get_bss(wiphy, NULL, bssid, NULL, 0,
+				   IEEE80211_BSS_TYPE_ANY,
+				   IEEE80211_PRIVACY_ANY,
+				   NL80211_BSS_USE_FOR_NORMAL, &extack);
+	KUNIT_EXPECT_NULL(test, found);
+	KUNIT_EXPECT_STREQ(test, extack._msg,
+			   "BSS entry in scan results is expired");
+	bss->use_for = NL80211_BSS_USE_FOR_ALL;
+
+	/* Expired but held entries are still usable, no message is set */
+	extack._msg = NULL;
+	atomic_set(&ibss->hold, 1);
+	found = __cfg80211_get_bss(wiphy, NULL, bssid, NULL, 0,
+				   IEEE80211_BSS_TYPE_ANY,
+				   IEEE80211_PRIVACY_ANY,
+				   NL80211_BSS_USE_FOR_NORMAL, &extack);
+	KUNIT_ASSERT_PTR_EQ(test, found, bss);
+	KUNIT_EXPECT_NULL(test, extack._msg);
+	cfg80211_put_bss(wiphy, found);
+	atomic_set(&ibss->hold, 0);
+
+	/*
+	 * With one matching entry expired and another current but
+	 * unusable, both reasons are reported.
+	 */
+	bss2 = cfg80211_inform_bss_data(wiphy, &inform_bss,
+					CFG80211_BSS_FTYPE_PRESP, other_bssid,
+					0, 0x1234, 100, ies, sizeof(ies),
+					GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, bss2);
+	bss2->use_for = 0;
+	extack._msg = NULL;
+	found = __cfg80211_get_bss(wiphy, NULL, NULL, "TEST", 4,
+				   IEEE80211_BSS_TYPE_ANY,
+				   IEEE80211_PRIVACY_ANY,
+				   NL80211_BSS_USE_FOR_NORMAL, &extack);
+	KUNIT_EXPECT_NULL(test, found);
+	KUNIT_EXPECT_STREQ(test, extack._msg,
+			   "BSS entries are expired or cannot be used for the requested operation");
+
+	cfg80211_put_bss(wiphy, bss2);
+	cfg80211_put_bss(wiphy, bss);
+}
+
 static struct inform_bss_ml_sta_case {
 	const char *desc;
 	int mld_id;
@@ -855,6 +973,7 @@ kunit_test_suite(gen_new_ie);
 
 static struct kunit_case inform_bss_test_cases[] = {
 	KUNIT_CASE(test_inform_bss_ssid_only),
+	KUNIT_CASE(test_get_bss_miss_reason),
 	KUNIT_CASE_PARAM(test_inform_bss_ml_sta, inform_bss_ml_sta_gen_params),
 	{}
 };
-- 
2.55.0

