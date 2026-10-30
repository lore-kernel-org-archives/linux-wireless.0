Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334127;
	b=clOZXlHtIaru+7BnMSCJPZzREYYJV21JijpvUYOXWv3y9P1QeHTOa8gkuVSBWQxJe5E7
	 hv7+W4QB9VcbLCQ2t8KrHDxoZtCgg8lN3DUchV59SY3b8lvHtzw96AE7hvXPcQ2v8k+lm
	 lVgQZGJU2/5ejtNnZUQT9uCGxGV4YRIEzvazlQm0yIeR9O2WaympMtK8bulfwTh8muUwG
	 mVA/19ktTCISd6EECYGwPxKCraN1U2woJsxGkDktY1n+oXdWdgbV7PjhNObizudjXy4lG
	 UmOg534JzgUtRBWMm2OL9DBsHBgaGunHhsrk9ajMj9ZEVs4WPaN66E1RqgMWQHgBCeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=0VilEBuRjBLpfrAybGiQrzjj9tQNqzv1uCR08XLAscA=;
	b=Dq+ChuKqFO+vjX9jCV/dc9AhUHbc+caxQkdUG4oRFBNPkvPbs+/qqNmy0p0Mu9I/+vNU
	 1xxgBWOHIBU/1v5eQftEj8HxQGo6ve1JZIdrhqnzAcg3ZAvkxfEP0BXzAXUblgcPakv+I
	 D+CdbKOOR9292PlQWDzlgSU/XXIzWlAKkU8sEixFeN04EcbU0Bw3lKmWpBh10tbeVX+kJ
	 V0puCZBbnXb8UGeafveqpNugPRSxzNw+DyDFL2vcPs/4ClbkvsCC5XTOIYJdROu97OkZ0
	 I9oDn/WjoZbsieHx1MXy2X27L5s6mWj/tI20628V3FbVSpuU79fn61IsBwdy/2GS1DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=RDNSZmgD;
	arc=none smtp.remote-ip=209.85.210.52
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F1D606A32A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 04:22:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40F1D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=RDNSZmgD
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-8490a7d6696so231105a34.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 21:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1793334126; x=1793938926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0VilEBuRjBLpfrAybGiQrzjj9tQNqzv1uCR08XLAscA=;
        b=RDNSZmgD7Hfq7YIvLTbtFyEdLCDZpDX6jTl//bCh43JEUJVeU7EIP6jeh//AYC9ufM
         mnwzNVxK7s+QgiG1J0G1p781rlZUO9xGf1FMLgynSQfEt85dZgbqrVrM/lAn2l6WRTag
         mhrbHSBG48BiZbyWUeVtME7+N1niZ/i4w5s24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793334126; x=1793938926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0VilEBuRjBLpfrAybGiQrzjj9tQNqzv1uCR08XLAscA=;
        b=swEK0gXqEjeREPRj5craLsIsvbKZGFYMBQXe6VKSDgvYAQJ5BjQQaQrs8uTGy9nEcC
         0WMJNbFQPK7AgrRG6YP1D7FlGyYD8elkCkCwWclCkiDdlcmyX9JOBLCmZ/hxqULPVi/P
         DMK6thIrxlXYZyep/YRF9eDBiHMGgm9U4bkLC+nVNP7VGmS8rcv4jBUk+BqX/fuMco6M
         GnzTrII1uiUfaJ/fys+acRYAcFluCnrRiDhkDA6Mf8htaX6x02iuMX/fDdwWuBm0V8um
         1JJ9M+Mytgkbi1Q4sJOGxoZrda5w/gOCITiuMrw5Z/0kFKy5UzCfjJ3t5gRMF/fvC69w
         ee4Q==
X-Gm-Message-State: AFq9FYL56PandyWbTtUfC4+OorZM4NsKuJro/HruffOINWNJgUIAZCDT
	GSJqQuGEysbVe2zh7X7z8eDhupqFdha2o0Uq5e8ejowQrubrEMm+35kmjsHDEgslyniWv+3Yupk
	XQ3dMo/8=
X-Gm-Gg: AYBFou2KTCdhGyL+VH8UYory2ZtHNY3t+NBAJauhnUdBZGF4jj12P00hC6+//Jg/RE3
	ywoudDl6ircrAltZiAyb2IpqMKLOEr//5h1FwcsPndaV8pzrgQp5B3JIxWsszzLagXBkjBtW9Ld
	5wz/EA7HJyJ4513DE1pXAR4qmZRXYkuAhuYr2JavRMkvLdrar4e28KrtVG5hZqkrIITidbK2LT2
	OHYeVL9idP817DpzlG6AL04Kqb3JIV1GyxcTukkTa39Xc1Ujv7A1OpbXhrD/JguXctCW2f5j+if
	sLCKHjZejoGAdd3AFDWJqXNgw0vi6tfbOWq5wSOPiaFzVfEP7ZSyTB22rcANh36JuTJniuBabxk
	oLB5Z1NDLC0HUW4Jpu/kIsNiF6zwZ+nXB4OaoyFwEjGmDC9gaCRizBdMuhc3N75LFIBwfiGvior
	T4q6GbFwA8v7sYyE3+amxVsQ0majtPp4vnFBo9m0XKNBvsFzm6MhT09/qEVIAiN4x5fVHjgvIFj
	RyzYhZ50zWEGJdaQdPsiOY3fyT7a/5zB0s2QhbL2VW06J9tNQQ7qXKgb3Jyf3UH265On8KlFiBr
	mvOgd7gaUhx6FEWyKDr/EDdGIwiTSOm0o1sHN6YD5bU0Q5v7ycF2pxqkgo3PWi+ymwT+FhqSrLd
	RfYWxp1Zrguh9egIt0Vs2lajh+igBXw==
X-Received: by 2002:a05:6830:71a5:b0:822:b69c:fe5a with SMTP id 46e09a7af769-85d3661ec90mr853248a34.27.1793334126175;
        Thu, 29 Oct 2026 21:22:06 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.5])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85d354efebesm1177931a34.19.2026.10.29.21.22.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 21:22:05 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org,
	outbounddisclosures@openai.com
Subject: [PATCH] wifi: cfg80211: reject overflowing scan frequencies
Date: Thu, 29 Oct 2026 21:22:04 -0700
Message-ID: <20261030042204.73885-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
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

validate_scan_freqs() checks for duplicate raw u32 frequencies, but scan
requests later convert MHz to kHz using 32-bit arithmetic. Values spaced
2^29 MHz apart therefore pass the duplicate check and resolve to the
same registered channel. This breaks the guarantee that drivers receive
no more channels than they registered. For example, 120 entries formed
from aliases of 15 5-GHz channels overrun mac80211_hwsim's 113-entry
survey array.

Reject MHz values greater than U32_MAX / 1000 in the shared validator
and keep the subsequent conversions unsigned. Pass the unit into the
validator so that raw kHz input remains unchanged. Apply the same check
to scheduled scans, including WoWLAN net-detect, which use the same
MHz conversion.

Fixes: 934f4c7dd3a5 ("cfg80211: express channels with a KHz component")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
I have a reproducer for this issue and can share via DM

 net/wireless/nl80211.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d790e204aee3..6cfa12191089 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11470,14 +11470,18 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 }
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
 
-static int validate_scan_freqs(struct nlattr *freqs)
+static int validate_scan_freqs(struct nlattr *freqs, bool khz)
 {
 	struct nlattr *attr1, *attr2;
 	int n_channels = 0, tmp1, tmp2;
 
-	nla_for_each_nested(attr1, freqs, tmp1)
+	nla_for_each_nested(attr1, freqs, tmp1) {
 		if (nla_len(attr1) != sizeof(u32))
 			return 0;
+		/* Avoid aliases when MHz values are converted to kHz. */
+		if (!khz && nla_get_u32(attr1) > U32_MAX / 1000)
+			return 0;
+	}
 
 	nla_for_each_nested(attr1, freqs, tmp1) {
 		n_channels++;
@@ -11786,7 +11790,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		scan_freqs = info->attrs[NL80211_ATTR_SCAN_FREQUENCIES];
 
 	if (scan_freqs) {
-		n_channels = validate_scan_freqs(scan_freqs);
+		n_channels = validate_scan_freqs(scan_freqs, scan_freqs_khz);
 		if (!n_channels)
 			return -EINVAL;
 	} else {
@@ -11828,7 +11832,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		/* user specified, bail out if channel not found */
 		nla_for_each_nested(attr, scan_freqs, tmp) {
 			struct ieee80211_channel *chan;
-			int freq = nla_get_u32(attr);
+			u32 freq = nla_get_u32(attr);
 
 			if (!scan_freqs_khz)
 				freq = MHZ_TO_KHZ(freq);
@@ -12118,7 +12122,7 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	if (attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		n_channels = validate_scan_freqs(
-				attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
+				attrs[NL80211_ATTR_SCAN_FREQUENCIES], false);
 		if (!n_channels)
 			return ERR_PTR(-EINVAL);
 	} else {
@@ -12276,7 +12280,8 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 				    tmp) {
 			struct ieee80211_channel *chan;
 
-			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
+			chan = ieee80211_get_channel_khz(wiphy,
+							 MHZ_TO_KHZ(nla_get_u32(attr)));
 
 			if (!chan) {
 				err = -EINVAL;

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.56.0
