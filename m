Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2697543F093
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 00:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784246423; cv=none; b=ZDPcaLmAqgOHae/uWYvrV1qwQOPkFGaqvQ/3HxoRAAblCLDdDYsPD3E0ye13p3aNlSU+dp1QYHgsMgMmSIWoI5ZrA5/zwmVcWG0bQLr3GrQmq934VP8rmxWeiFTcMLGE3LZKylJuUkrqlpY/b4oXXCB+dW6/UlsF2IXysscbtJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784246423; c=relaxed/simple;
	bh=AfYPfJwF5BfWs/weAYfrLTws9xqmxHiZcm9loGO9wNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PJsrI/kvE+lPoXvO/r0DlcmHcePIVaqSbiQbEMwUU2sDWP9AUf+Z4vuTB2hUvYarxd06i/VpBGLR9XlHTXGs3pWPYlsz64CkE1eh23upnQwVdLmP8UKVT0wCiVRmTHSWAdRYRck2Jn4Apvs3RLbmZGfFrjxifTWgOIEBkXENMyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kleiner.pro; spf=pass smtp.mailfrom=gracedigital.studio; dkim=pass (2048-bit key) header.d=kleiner.pro header.i=@kleiner.pro header.b=HJgtsiNk; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kleiner.pro
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gracedigital.studio
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kleiner.pro header.i=@kleiner.pro header.b="HJgtsiNk"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6681e786b81so262082d50.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 17:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kleiner.pro; s=google; t=1784246420; x=1784851220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KiAW/qIk5S89JuA1sLMk0vSqm7rhb7f9JlzmZCBVEVs=;
        b=HJgtsiNkhrZFGC3EiiCiJW7pEBDlufyZEZ10F1lr9Qfmgl3bDCJKQsxhKW5j1pneV1
         pG2B2YXelp2FF3zcwDy21Vs3lA0pvJ2FZHwIvk2ccCUZkL1W0L4tVcM32JyTywBG91iM
         NsDmIdb1/xkhM7VKeoBB1C9Vf2I7p4fuDjvzFQCqTosxSg6L8HmSHCRuWExT6/dLpPhZ
         hvWJqeKLB2lR6fwWIZbdAHXc/04eXS3XxbNUSFk37pPvAZvI1euiQ9q59EZwdOSt9mP0
         4864eHq0y8yHmJT5iISw4Dp9vnGb0/HGIfwl7bY+qGRbk1qBtYz0RbceVncaDdoYTmk5
         73aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784246420; x=1784851220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KiAW/qIk5S89JuA1sLMk0vSqm7rhb7f9JlzmZCBVEVs=;
        b=oc9tcq91Sy5O8whRxL0S8T8+Phud18aa9rv7WRrrD5K6gVNOYwI7fLcdVRk0ezV1yk
         LpYHMpSVMXPVWry/uc2qSm3ganfUNZR0vCAhJQYtJAadJJCVoL4RdEp8ZSvT3Zw3fhWk
         ttXBj3XQMoQgeX//+1wVlD5bHYiaQDG4H+V1P4thTYuJT/jH5RWoZV5tDrFamd+v1r+w
         4TviEMPYak93akJdhQpgCGo8xnd6ZaSsQbIgEd6cfYXAMj/pB74t4QfuRn0nc9lY7/Jy
         42v4dzNmBNnuxqZ+FrJP1y4qsGe9G79riRo3PbWXI3z+k50n93cFxZ5E1E3pNyoB+15k
         g/4w==
X-Forwarded-Encrypted: i=1; AHgh+RrGbOg92zg5ar+p9PSsE4MubbVOKwNMv1DVzrDdw48i7i4A4SWNjom6GvAYIeoUbXJsLzp9J7Xgj/3icXh+PA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgdZoyVMfCEVeGlrIRyw5OJdZxEXghvbgnWWAAhsFlQ1s1eEi/
	xrVM+HEHxf9pHzN0Wl8ZhTH0VPpp3lXlRkok5ZArNo5QRHgDPq1RPgdu3O6ibhyYlL5Z
X-Gm-Gg: AfdE7cldLr5CzIdeb3s9s08Sg4BmB5zFav9fZcuzuB5YZCPU9VtZw3ZiGhS5EIYixPB
	0SZMee9/IOhjvZZjl0ohveM4xpVJSwCIJcwElb7rauJ/Rm3XmVqRecW9civNSU+dYeTKbiWpcyq
	vAFpoyMxpGrlW7AIFlR2qGLNgkpsSnu6IiK43mCj4GyDQROld+mVE6lJUYSIRnh5OKFbKzdx/ow
	qI51hE7i1jUvqYLvxsROgiXhw0m5Dn42P7yBUDENbdTtws8sDEc7LpM81JsmZPlNDEL4W6GqrbC
	/Xk15MzP/q470azdzaF4/zY/VsnRrQ1dswap1wciBvMvgTrCYcD/ml75Pscdrzc55CvNMCIu0li
	fUK1JjibVKhzWjS5LT3M85eCt8D3u8CBZaanv8NEN8CVWCx1I9eZuURBD4cCyIXRNlaPRlgPhqa
	obkvofSBlTb0xVNA==
X-Received: by 2002:a05:690c:15:b0:81e:ba71:2be2 with SMTP id 00721157ae682-81eba712fbamr98332757b3.5.1784246419658;
        Thu, 16 Jul 2026 17:00:19 -0700 (PDT)
Received: from localhost.localdomain ([217.180.197.172])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6bf653desm210134837b3.17.2026.07.16.17.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 17:00:18 -0700 (PDT)
From: Christopher Kleiner <chris@kleiner.pro>
To: briannorris@chromium.org,
	linux-wireless@vger.kernel.org
Cc: francesco@dolcini.it,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mwifiex: validate HT/VHT element length before storing beacon IE pointers
Date: Thu, 16 Jul 2026 20:00:17 -0400
Message-ID: <20260717000017.61415-1-chris@kleiner.pro>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mwifiex_update_bss_desc_with_ie() stores raw pointers into the beacon
buffer for the HT Capability, HT Operation, VHT Capability and VHT
Operation elements without checking that the element is long enough to
hold the corresponding fixed-size structure. The generic IE loop only
guarantees that the declared element length fits inside the beacon
buffer (bytes_left >= total_ie_len); it does not guarantee that
element_len is large enough for the struct that later consumers copy.

beacon_buf is a tight kmemdup() of the over-the-air IEs. When the
association command is built, mwifiex_cmd_append_11n_tlv() /
mwifiex_cmd_append_11ac_tlv() copy a fixed number of bytes from the
stored pointers (sizeof(struct ieee80211_ht_cap) and friends). A
malicious AP that emits a beacon or probe response ending in a
truncated (e.g. zero-length) HT Capability element leaves bcn_ht_cap
pointing near the end of the slab, and the subsequent copy reads out of
bounds. The leaked bytes are placed into the association request
transmitted back to the AP, disclosing adjacent slab memory; on
CONFIG_KASAN / panic_on_oops kernels it is an out-of-bounds oops.

Commit 685c9b7750bf ("mwifiex: Abort at too short BSS descriptor
element") added such length checks for the FH/DS/CF/IBSS parameter sets
and a few other elements, but did not cover the HT/VHT capability and
operation elements. Validate element_len against the size of the
structure that will be consumed, mirroring those existing checks.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Signed-off-by: Christopher Kleiner <chris@kleiner.pro>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 97c0ec3b822e..0196c2adfeed 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1384,6 +1384,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 							bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_HT_CAPABILITY:
+			if (element_len < sizeof(struct ieee80211_ht_cap))
+				return -EINVAL;
 			bss_entry->bcn_ht_cap = (struct ieee80211_ht_cap *)
 					(current_ptr +
 					sizeof(struct ieee_types_header));
@@ -1392,6 +1394,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_HT_OPERATION:
+			if (element_len < sizeof(struct ieee80211_ht_operation))
+				return -EINVAL;
 			bss_entry->bcn_ht_oper =
 				(struct ieee80211_ht_operation *)(current_ptr +
 					sizeof(struct ieee_types_header));
@@ -1400,6 +1404,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_VHT_CAPABILITY:
+			if (element_len < sizeof(struct ieee80211_vht_cap))
+				return -EINVAL;
 			bss_entry->disable_11ac = false;
 			bss_entry->bcn_vht_cap =
 				(void *)(current_ptr +
@@ -1409,6 +1415,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_VHT_OPERATION:
+			if (element_len < sizeof(struct ieee80211_vht_operation))
+				return -EINVAL;
 			bss_entry->bcn_vht_oper =
 				(void *)(current_ptr +
 					 sizeof(struct ieee_types_header));
-- 
2.43.0

