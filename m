Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CA1374A1E
	for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2026 07:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783754023; cv=none; b=G7t38cPYutcDsoirMzzHT0v3ICFXRZi9StW3pn0QASJn+hpxA502Mt0XP7BilKnRlgtyBOy+4DXAJTQFmkPSfZxLeKgMkGyiTrCdlV8SuW3u1xjomdRobCm/YSMJHs4wB/0UwQ7KrTJQk1zPm69/qFj1I544Y+nJ7dwY/ZWTMOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783754023; c=relaxed/simple;
	bh=nJ93PuRgfvyXeSbj+HoOEf3Bf82IWNnh7L9snO3pg2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c4OynhJP6GfoSmURo4gmE8itBrj9iIliKKmAcPlIGO8FJhb7qzLlELQ8DmbLuWg4euLD/HKyG5TGsUD8OlRWxghedxSk1wcfsoyWwPR2cHXfHVdQ1hrv9f15U+qNyUboWkL+dkOrmMmYQffSHz/i5nVnhK4suzP+EoLHHrs92Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=jR9qGL0c; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="jR9qGL0c"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-474560436c3so1340995f8f.0
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2026 00:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1783754019; x=1784358819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SNHJSSzRo5FI9vf+enTbdejiXKeJlyuLQfvo17oWJAQ=;
        b=jR9qGL0cLL9OH8fZxX0l0ahGUrNlXFSzyPUN7DEBq2Tq42sRjZ+Ssf+tRy4SoxE09I
         1lipBfJEfCizwGIOQCdXBfCGWtg2x2NX4iGCgFsxYj1eqnDl3/kPqHqSG26Vlzi2AjFc
         PVKQJ7JUULXgOWxcBlix09KC/BQ3zTX1ww5x9fmdWQEXmfC1XvghCyOJlADQbJx3x2P0
         4FIILW8gLT6Bl5vFpwEukXZlCZzGzQ8LGT1R8A7R5LUXRF+eouCL7ykzNHUN8lfLyesm
         2VGPTDsk/v7YTyK0vlEi1XQ6UKVG13o9d88YEpxsEZUXuMfHqxIbmAv0ItaN8u2+6RGF
         K4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783754019; x=1784358819;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SNHJSSzRo5FI9vf+enTbdejiXKeJlyuLQfvo17oWJAQ=;
        b=WUfd0lVP7Oh7w8I7sXpXJmPDwKpHVKeQ7ngXKuaZtGo8cKTsVUwHp0j3d8R1qUHlE3
         A/TaSROYvdlIqfRAC+HJQHRTRh23atJqVbUteP20+6GM9hCUNDfBJEfIGzE43Sm4XMs2
         kP6u2i3v6D0Iex3/r3vAtW9CD/zVgmYD8P5OE7w9FdCrnz44A5zFP5gPyJ7dbasdC3+T
         Js62wo2OObahFkkRo7DfXkuo/GHTe2RZktRwuemW/57OtBA2tGY3HHQqaA/qLuWOyUSn
         G1VQ2S2KawNL+ICgvkWLQpW5s6x3NrR3Xi47Lcf39gFZ+XSQ6a9OSXb0HJE9+M/daouL
         qkrg==
X-Gm-Message-State: AOJu0Yy/YanzPYunmhI7UWXF4qRKvrX+w2E4bHU+nTNSgAiQC2RBnYpi
	hUOf2sNULgxQr4JiwMkk4Jte5SAIya3gHNt3KH/GuFvE8m0Vdd3c3nO6M6icMHV4O451pgLDfX+
	6KQBdmrKP
X-Gm-Gg: AfdE7ckJKDLF7Jja0yx8r3Mkfzj6MIL/3gFwI91WNFdPhI7DOVG+I1uhxvRFnoBqOch
	PpwdYoCOdQLH7qgbcreE0+yrDxlJ3KpRjaKIiZV0gxgy7bPrfaEiHJtij7H3ZZnSfVAh9m7B/ft
	RWbcQazuAu4+BGIvpYBSGbx2JpkezRy1jO5xC2q4Fq8lXgfimPGP9ssKFFxl6q44FP/Ukks07GP
	2eXhX7vQbEb1JZKf+uFvD4s8iw/0mYu/JG6guG++c+UtoZH5BEgO35JklKiOApbelZNHFh3ItfY
	c9ZS+RgLfmH7l+sf5Y/nM3elDj+ghIDJlJTWaB0yVCBJg3+DM4h5xSBCMkQSWmLoXD2TexuTDok
	P0aKeiyXGtjqzvgp53pFc79VQfgcpnYBoC0iuovVJKJZYILZL04HdtubgubXMJhsqHp+TPwo9rY
	GS1oepB/6pqYoIt3Jw/BnwUbYrPO9lBvA4Gf33Fh3tUDA6X3B2XEd9uZk0BOUZs9X3cpMbSYyy1
	S78jSU8iFj2XzssopEQZyO55orPsN4nWPk=
X-Received: by 2002:a5d:5c84:0:b0:474:9991:60d0 with SMTP id ffacd0b85a97d-47f2dcb60d3mr1985178f8f.12.1783754018793;
        Sat, 11 Jul 2026 00:13:38 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.188])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f21543sm61990120f8f.35.2026.07.11.00.13.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 11 Jul 2026 00:13:38 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: ath6kl: validate assoc info lengths in the WMI connect event
Date: Sat, 11 Jul 2026 09:13:36 +0200
Message-ID: <20260711071336.58324-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath6kl_wmi_connect_event_rx() only checks that the received event is at
least sizeof(struct wmi_connect_event); it never checks that the trailing
beacon_ie_len + assoc_req_len + assoc_resp_len fields fit within the
received buffer. Those attacker/AP-influenced lengths then drive two
out-of-bounds accesses:

  - The WMM information-element scan builds
    peie = assoc_info + beacon_ie_len + assoc_req_len + assoc_resp_len
    and walks up to it, reading past the end of the event buffer when the
    declared lengths exceed the buffer. The walk also dereferences
    pie[1..6] and pie[1] (for the advance) without checking they stay
    within peie.

  - ath6kl_cfg80211_connect_event() subtracts fixed offsets from
    assoc_req_len (-= 4) and assoc_resp_len (-= 6), both u8, with no lower
    bound. A short assoc request/response underflows the length to ~250,
    which cfg80211_connect_result() / cfg80211_roamed() then treat as the
    IE length and copy out of bounds from the small assoc_info buffer,
    disclosing adjacent slab memory to user space via nl80211.

Bound the declared IE lengths against the received buffer, bound the WMM
element reads against peie, and clamp the assoc request/response lengths
before the subtraction. The sibling wil6210 driver already performs the
equivalent length check for the same WMI connect event.

Found by 0sec (https://0sec.ai) using automated source analysis; the
missing bounds are evident from source and cross-checked against the
sibling wil6210 driver. Compile-tested.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  5 +++++
 drivers/net/wireless/ath/ath6kl/wmi.c      | 10 +++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index cc0f2c45fc3a..62f663c0daa2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -754,6 +754,11 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 	u8 *assoc_resp_ie = assoc_info + beacon_ie_len + assoc_req_len +
 	    assoc_resp_ie_offset;
 
+	if (assoc_req_len < assoc_req_ie_offset)
+		assoc_req_len = assoc_req_ie_offset;
+	if (assoc_resp_len < assoc_resp_ie_offset)
+		assoc_resp_len = assoc_resp_ie_offset;
+
 	assoc_req_len -= assoc_req_ie_offset;
 	assoc_resp_len -= assoc_resp_ie_offset;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 72611a2ceb9d..fbfd74154d12 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -862,6 +862,10 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 
 	ev = (struct wmi_connect_event *) datap;
 
+	if (len < sizeof(*ev) + ev->beacon_ie_len + ev->assoc_req_len +
+	    ev->assoc_resp_len)
+		return -EINVAL;
+
 	if (vif->nw_type == AP_NETWORK) {
 		/* AP mode start/STA connected event */
 		struct net_device *dev = vif->ndev;
@@ -913,7 +917,8 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 	while (pie < peie) {
 		switch (*pie) {
 		case WLAN_EID_VENDOR_SPECIFIC:
-			if (pie[1] > 3 && pie[2] == 0x00 && pie[3] == 0x50 &&
+			if (pie + 7 <= peie && pie[1] > 3 &&
+			    pie[2] == 0x00 && pie[3] == 0x50 &&
 			    pie[4] == 0xf2 && pie[5] == WMM_OUI_TYPE) {
 				/* WMM OUT (00:50:F2) */
 				if (pie[1] > 5 &&
@@ -926,6 +931,9 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 		if (wmi->is_wmm_enabled)
 			break;
 
+		if (pie + 1 >= peie)
+			break;
+
 		pie += pie[1] + 2;
 	}
 
-- 
2.43.0

