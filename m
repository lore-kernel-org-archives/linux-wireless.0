Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7310E39B4A2
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657532; cv=none; b=EXF6ilCCGOfewSBStz/EesK5WjRB62Ci0CL25IfwSVYgoLtWRtHlJEjERmPFaaEz03OAMQOOPJLX1YxKkWwtcGVMbN/NZiizl0WTja0a/Y2QMWZaSpwsOjb/ZO//DZrBm09dtjyu5VRzSg9stjppbX1Tez1eo2l9fohx1NzJ2Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657532; c=relaxed/simple;
	bh=VyqPry+Jyk41bywcDDOHwgp5gnyvxXMNoSPQu15XKTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYh9HWJEs1pvWoC73HWawS+LElQklmLwCqOhq31/+bXlRx+xAm+IY2CygyXiXYkw0GoQgPzDIGCvDFS6kf90SpGfZcbPR0DhYzALSebTv3R34R8yjPtaWRoS5Iey2DXSJQBfY69vAvCJU3rTAaUNijfJD/DO8goFsrY4kiPlNac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Alfm1z8f; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Alfm1z8f"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4956242332dso19094905e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 11:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784657529; x=1785262329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dG/aaTVPvOTLfx14gUE4MGd7dHHYsJQKyX614HPG0BE=;
        b=Alfm1z8f2u3cuWUvppni7iyvCoqFYXj+qYediXokVDF4iv2NWn2PjN7t6Bo//tzQaQ
         YgumjOTkLMnfcokv2AGOhqI3NgTQueDKsVJrLeSZfwCqfqx51jLu5s8xpL8cFJw4WxkO
         Bkj3wVnCNCctiILTGlkl6dQUN7kM4G1L0+zmp3SpQKlqeZl3WQJaLJA2AL8YEQZC04fN
         JehXxABmxDiv78lmz3nRdSbzBEXCXomj+eH+Xlum46r1oQSN/fcq23GEPlPaHylpIV03
         /ihMs7SSfxwQTdDVv6zVziX+IlE1RdHxAS5/MNDCiWpIOqfDNaXpZfjZA123cO6SvOPK
         jYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657529; x=1785262329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dG/aaTVPvOTLfx14gUE4MGd7dHHYsJQKyX614HPG0BE=;
        b=Z6zM4MbETzzLrLqnniIjJLpKuLm9G7iVKsjUdErbbvWL5uvWvV1lyscd4ov5WYOxmC
         S5HVyjhHo/Ue6EgGWfS/7IfGDRkRHaqsrFXNFJdWkUNYax8RGD02yEkDorb9+y1QwXMP
         mLVlQl6NgvwerfNnSGMRDuRlMIhkgQDrKsSdNVYaFeaFDvbBPoMVKi0twngjWANoSB/h
         xNGziT/AdJR7HcWTcZ2gp73MVIehx1g8MugJXCLpwI8hA2kba2JiSDtVPwsp1gsBxkzX
         KRELiEpcpF3v2ds5MEtUttydVPng+FRHy05qW9DK3ue0tEuY52gMhbLbSDrsSR9eMSRQ
         bwcg==
X-Gm-Message-State: AOJu0YwT70m7zuJXvD+/lTliTDBHYncyj5pVIyBxFLq7gTWa3DKY7Fww
	4Kh7RA424IksrS7V4N0VWFKFepzB+PvxUB7y0vGmmhcdWVgDo9VE2W4I
X-Gm-Gg: AfdE7ck43jHLGNVKe99aMRVRy6SNIOQ5FMg81ybYGCgZviiPOylGWj0eWHChXQZFBBz
	p2qhkHr+mk11flxzDzwNbPHhf+/8fqJY7PO3RJO9zrpJL9sALHLxSW/3GiDZHSH0i8x5sUm8eb9
	mdNlAlNoidBwohqEL7770PQnoYi/DcV9YtAhKliRk3N6Z5jeMYmGONhfz4ELwNap0ADp+FekU5w
	zQXbdMtyiQQhoozz9AG8MC/3kN2nHkjSsjJJoDL7QBD+VcbxMP3euBXcskQc6k3PVi6X+JVIHDg
	F2SYzLHpdg4a9Xx+w33vKrM4QYwiec96+gvgcOgpUP7poJDZUQKLyLmxKa0LndgbyxZZrRv2/t3
	Kvgo2ndb9zCC4g98J6imNzxRBgKEisFalCzI3EXXNkwYk+ubVI1SHiI/aQL3a4uW+cnl3PfH5o3
	jGesASJg9x4w5CPKKX2protIf7mw==
X-Received: by 2002:a05:600c:4584:b0:493:f5bf:4da4 with SMTP id 5b1f17b1804b1-4954a50e970mr222206645e9.28.1784657528424;
        Tue, 21 Jul 2026 11:12:08 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956a6354a3sm15632125e9.10.2026.07.21.11.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 11:12:08 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: [PATCH v2 2/2] wifi: cfg80211: tests: check BSS lookup failure reasons
Date: Tue, 21 Jul 2026 20:11:58 +0200
Message-ID: <20260721181158.3004022-3-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721181158.3004022-1-loukot@gmail.com>
References: <2629d83dd460f3d9a60566f3fad975db13b045c3.camel@sipsolutions.net>
 <20260721181158.3004022-1-loukot@gmail.com>
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
the precedence for an entry that is both expired and unusable, and
the cross-entry precedence when one matching entry is expired and
another is current but unusable.

Signed-off-by: Louis Kotze <loukot@gmail.com>
---
 net/wireless/tests/scan.c | 120 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/net/wireless/tests/scan.c b/net/wireless/tests/scan.c
index 2fc717317ac3..e62b01f8cbe5 100644
--- a/net/wireless/tests/scan.c
+++ b/net/wireless/tests/scan.c
@@ -402,6 +402,125 @@ static void test_inform_bss_ssid_only(struct kunit *test)
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
+			   "BSS entry is expired, scan again");
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
+			   "BSS entry is expired, scan again");
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
+	 * With both an expired entry and a fresh-but-unusable entry
+	 * matching, the unusable one determines the message: a current
+	 * entry exists, so suggesting a rescan would be misleading.
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
+			   "BSS cannot be used for the requested operation");
+
+	cfg80211_put_bss(wiphy, bss2);
+	cfg80211_put_bss(wiphy, bss);
+}
+
 static struct inform_bss_ml_sta_case {
 	const char *desc;
 	int mld_id;
@@ -855,6 +974,7 @@ kunit_test_suite(gen_new_ie);
 
 static struct kunit_case inform_bss_test_cases[] = {
 	KUNIT_CASE(test_inform_bss_ssid_only),
+	KUNIT_CASE(test_get_bss_miss_reason),
 	KUNIT_CASE_PARAM(test_inform_bss_ml_sta, inform_bss_ml_sta_gen_params),
 	{}
 };
-- 
2.55.0

