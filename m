Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826901;
	b=emyucWc86W3GcwWkmIafp0LyHnazEyc8o1BLbRbk+L+3+TaVDNUDvXMIbix7XMs3Oyhr
	 +elPBEMhYDCfG/UlW6GAYFyK/JZIOSq5eiZkFqTKkkNG5UXEzqcVLzDta5xQmIkddM6lm
	 NGQeG4cbyPXLQKhRVzF7zXy275te3Tf3l0I22WaktHiwci5ZYYrLh5Iu2MXvsdOrGlMwp
	 SSJRQ4bFyODJw6KkD2m5DLSM7dZ2tgqgalr/B1tk91hoKmWGADuQyZDlQ3YEiIZlKdr0e
	 eCMB5tcZh9sHjdWvG09rCv3Yf954mlPFo6WojcDPhE0xJJmcqHtYwH2oSDhAC/WqOmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z0W2Jd6uVsBM+uJxiCKZYftIMEndVFv4A/cqc5ME9Wg=;
	b=i2rq//1ZMWe6wvzp87FbiKBlPwrQoEoFwthMuJNMCPPmLDBo4JqRlLKea3Gc4SfXBJKp
	 kjCfXTOpsdYIOqFHhO6CmASl6NjHdmFXV+rJbbXNBeEAfk7LrjsyG9jfDoOq2gu9zdMqV
	 4VgN5VoRla4cA0EYXADCvSAFl/rsaa+6qmnO3mM39y0jsFKzKtZBT8rmiYWjEfm1OtTmY
	 N1zimmrCTGUPqkGKQGZ6YqAyhHhYIHRY8A4heUZaocYtXB2x5I5afm6CqujxfNps3tyhv
	 H8w+LSOU76ot/BBkAZzcTLMbB6C2Ge26CDNFS24akt+VawJOIwfPy8PggxxEtUbX4jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q1GWblou;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306D6084B40
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 21:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6306D6084B40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q1GWblou
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1a3c08d6928so1873372c88.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 13:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793826900; x=1794431700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z0W2Jd6uVsBM+uJxiCKZYftIMEndVFv4A/cqc5ME9Wg=;
        b=Q1GWblous/4WJwNpcq9vQcNJKyJUh++qAyNJqKHRdZ45zsrPRiHqBE6fZxUoWPK8l4
         QD0ld/SJHKYS/b5vzDAUh5QVS4Ky8qpTpZloSHYNpR2BXv7QKJGhvZyS1o5t1om9FfVf
         +75z+7zsmLvjuahsq38Bo0D1hQGGa9C8PwJRI2QfysJ56xY9zXqY53jKNxjqP+IIj8gb
         llEVwBiH33Vu88+WTjnO6ccWhk2K3MdnasBEWr1nOUqtWYCNlG/EFuKijqH03k2UT6+j
         OBR5MJZ2++M5JMHciycVsDIZjAq5kP+EyHNaKf2j5Eav6nMVXU9JyPZdV/Q9yl+veONR
         Xw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793826900; x=1794431700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z0W2Jd6uVsBM+uJxiCKZYftIMEndVFv4A/cqc5ME9Wg=;
        b=ZRldxj0ayG6SKRYm9VJXCSYreIh6U9Pm6wja4Vj5Xo/wDUZoXgAh7sLcKSR9JL8YhJ
         AYotX/Hqx8aiw/pUgcZ2mYqGlmuzM0Y9Kh974zosaUgRRqzmuj/A2iDgCy+nahRMrtNt
         n+2Zt8hIklODp5FdMgmXFDr95avuP2jJ59cu3D0Vv61EFvY3aLAhj5JVGDVYSGI0gQy8
         LhgswAfdozCI5GGJZQAaih8OzsjvEjKiwYdAYB46CzPEVSysUF1g3k6qbESnh8gmkgjV
         RrFBdO4FPDc4aJqSjm730YdCnxugif2HRfRZFKgXUDLCCO0pYG9t9G15QoSm0d81ecm9
         oCLQ==
X-Gm-Message-State: APuU4Z9Nz61S/j7Ca02rXh2Jzu4WbrC2rXLlXq6j6Ob1WXPc64t8TRfK
	buip8vj8qnUQ4L739FEELIhbtAwineNaDTVtFfZRtcmTouNvwqKd3JvQ
X-Gm-Gg: AYBFou2UGIW/XXD2pogsLubjPIXNLKoYF/nndoUEqCJwH0kkVhhqYxTjWzMWTgVE7y/
	lE44L316EuatRwJLCmeSZcRy28M31EUyI8FqoLnEznx9b70tkgbi3Pf7UjYUx16Zcaw2856Zx5b
	FEp3TTlc7k12waUj6tkoQEUWdav+OLaLsDQdmGChHJnHFVOhRXJuxqfdWwAD79jsB9IKN1LJWCk
	XpT+PljO4IyVCvdF9GxepAzIIQrsS0d9YPo+LFnO3ksOGIw4aSERYCI1Z5/RlyyYMzKIbSr+uH+
	mHRVDFsm7i7tap3atElV+03egvDnD47w0DfJE6rbmczn59gIZPSNSGVbAjIIiTPclyp8vI/Sc8G
	RVSM8a+4z6blj+CV4SjbzJGLuS0J/PWcdj4CeFYmhreh9+20sFH0ZVAeTDw5/VPRelPPtUJQvT4
	0sfJ6zxkCPDMjVxefuZj4POeDwmR/XdNes39Jk/4H1CNIWkVRahjni/bPJTG+U7OxiJEiZfG8Cn
	SROXzU0yoS+qtnD+yCN3m9Pq1nY9KgFUk+s6V8Z7yFz5C2FxWN+VgWEGpDSFI3dVxEQjaBNV8nJ
	ScW7b30oUXI7CzpFG5JyqkpS0da8TFGVvMUqIbaj2HrYdMBSKVEW2fPWkz9+FnNzsg==
X-Received: by 2002:a05:701b:4244:10b0:149:1b5b:1f25 with SMTP id a92af1059eb24-1ac5b211405mr26311162c88.15.1793826900133;
        Wed, 04 Nov 2026 13:15:00 -0800 (PST)
Received: from anon-laptop ([103.187.196.159])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c2c2f7sm10606078c88.9.2026.11.04.13.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 13:14:59 -0800 (PST)
From: Wahid Khan <wahidzk0091@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	sara.sharon@intel.com,
	luciano.coelho@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless 2/2] wifi: cfg80211: test a split MBSSID profile longer than 255 bytes
Date: Thu,  5 Nov 2026 02:44:51 +0530
Message-ID: <20261104211451.693451-2-wahidzk0091@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211451.693451-1-wahidzk0091@gmail.com>
References: <20261104211451.693451-1-wahidzk0091@gmail.com>
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

Add a KUnit test with a non-transmitted BSSID profile that is split over
two Multiple BSSID elements and is 300 bytes long once merged. The last
element of the profile must show up in the generated BSS. Before the
previous change the profile length was cut to 44 bytes and the test
failed.

Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
---
 net/wireless/tests/scan.c | 104 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/net/wireless/tests/scan.c b/net/wireless/tests/scan.c
index 8c20278b5d3a..01dcabf9dbfe 100644
--- a/net/wireless/tests/scan.c
+++ b/net/wireless/tests/scan.c
@@ -402,6 +402,109 @@ static void test_inform_bss_ssid_only(struct kunit *test)
 	cfg80211_put_bss(wiphy, bss);
 }
 
+static void test_inform_bss_mbssid_long_profile(struct kunit *test)
+{
+	struct inform_bss ctx = {
+		.test = test,
+	};
+	struct wiphy *wiphy = T_WIPHY(test, ctx);
+	struct t_wiphy_priv *w_priv = wiphy_priv(wiphy);
+	struct cfg80211_inform_bss inform_bss = {
+		.signal = 50,
+		.drv_data = &ctx,
+	};
+	const u8 bssid[ETH_ALEN] = { 0x10, 0x22, 0x33, 0x44, 0x55, 0x60 };
+	const u8 marker[] = { WLAN_EID_VENDOR_SPECIFIC, 6, 0x00, 0x11, 0x22,
+			      0x77, 'M', 'K' };
+	struct cfg80211_bss *tx_bss, *bss;
+	const struct cfg80211_bss_ies *ies;
+	u8 *input, *pos;
+	size_t len;
+
+	wiphy->support_mbssid = 1;
+	w_priv->ops->inform_bss = inform_bss_inc_counter;
+
+	inform_bss.chan = ieee80211_get_channel_khz(wiphy, MHZ_TO_KHZ(2412));
+	KUNIT_ASSERT_NOT_NULL(test, inform_bss.chan);
+
+	input = kunit_kzalloc(test, 1024, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, input);
+	pos = input;
+
+	/* transmitting BSS SSID */
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 2;
+	*pos++ = 'T';
+	*pos++ = 'X';
+
+	/*
+	 * First MBSSID element: a 200 byte non-transmitted profile start,
+	 * the profile continues in the next MBSSID element.
+	 */
+	*pos++ = WLAN_EID_MULTIPLE_BSSID;
+	*pos++ = 1 + 2 + 200;
+	*pos++ = 1;			/* max BSSID indicator */
+	*pos++ = 0;			/* nontransmitted BSSID profile */
+	*pos++ = 200;
+	*pos++ = WLAN_EID_NON_TX_BSSID_CAP;
+	*pos++ = 2;
+	*pos++ = 0x34;
+	*pos++ = 0x12;
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 2;
+	*pos++ = 'N';
+	*pos++ = 'T';
+	*pos++ = WLAN_EID_MULTI_BSSID_IDX;
+	*pos++ = 1;
+	*pos++ = 1;
+	*pos++ = WLAN_EID_VENDOR_SPECIFIC;
+	*pos++ = 187;
+	*pos++ = 0xaa;
+	*pos++ = 0xbb;
+	*pos++ = 0xcc;
+	pos += 184;
+
+	/* second MBSSID element: continuation of the profile, 100 bytes */
+	*pos++ = WLAN_EID_MULTIPLE_BSSID;
+	*pos++ = 1 + 2 + 100;
+	*pos++ = 1;
+	*pos++ = 0;
+	*pos++ = 100;
+	*pos++ = WLAN_EID_VENDOR_SPECIFIC;
+	*pos++ = 90;
+	*pos++ = 0xaa;
+	*pos++ = 0xbb;
+	*pos++ = 0xcc;
+	pos += 87;
+	memcpy(pos, marker, sizeof(marker));
+	pos += sizeof(marker);
+	len = pos - input;
+
+	tx_bss = cfg80211_inform_bss_data(wiphy, &inform_bss,
+					  CFG80211_BSS_FTYPE_PRESP, bssid,
+					  0x1000, 0x1234, 100,
+					  input, len, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, tx_bss);
+
+	bss = cfg80211_get_bss(wiphy, NULL, NULL, "NT", 2,
+			       IEEE80211_BSS_TYPE_ANY, IEEE80211_PRIVACY_ANY);
+	KUNIT_ASSERT_NOT_NULL(test, bss);
+
+	/* the 300 byte merged profile must not be cut at 300 % 256 */
+	rcu_read_lock();
+	ies = rcu_dereference(bss->ies);
+	KUNIT_EXPECT_NOT_NULL(test, ies);
+	if (ies)
+		KUNIT_EXPECT_NOT_NULL(test,
+				      cfg80211_find_vendor_elem(0x001122, 0x77,
+								ies->data,
+								ies->len));
+	rcu_read_unlock();
+
+	cfg80211_put_bss(wiphy, bss);
+	cfg80211_put_bss(wiphy, tx_bss);
+}
+
 static void test_get_bss_miss_reason(struct kunit *test)
 {
 	struct inform_bss ctx = {
@@ -973,6 +1076,7 @@ kunit_test_suite(gen_new_ie);
 
 static struct kunit_case inform_bss_test_cases[] = {
 	KUNIT_CASE(test_inform_bss_ssid_only),
+	KUNIT_CASE(test_inform_bss_mbssid_long_profile),
 	KUNIT_CASE(test_get_bss_miss_reason),
 	KUNIT_CASE_PARAM(test_inform_bss_ml_sta, inform_bss_ml_sta_gen_params),
 	{}
-- 
2.56.0

