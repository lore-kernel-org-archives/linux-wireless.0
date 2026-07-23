Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327431C3F0C
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769010; cv=none; b=FOxd/pgoXC45Ftg5LgGcJYc8MczJuvK6l+aqJrEBsjPSPZgpQGhmWN1o71J6fXUnOJNpXiqbhCAgaAAV8gtIGO4K4r+qjyOwC/frnAYGCa1kI5/vYPsL30glWn8n9Q9Ya0BtQsjclk4xluF4Tnl9TsrDR2ADwJIzsesKcbGO7+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769010; c=relaxed/simple;
	bh=Sy16K24qDpp7PICHqfmOrd5cZptXz9xLQaMlgu6spd0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lD7WQ3riynFclE15SBBNojVcnrreaH3P2MPdwfz3cLwo/zCGVUu1V+J89l1NZnaL+N57PmU2s7tom04l3EWRykLyh2vUzzIqnDBAtYmOtP+1Z8JKtrGrKYJuOahTdQO5ykLm7Ejj2G2JgytaAvur/EezD2ORhrX3MhWpYwoiUJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PP9Lhz8i; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PP9Lhz8i"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso84399a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 18:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784769008; x=1785373808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XV45lch4j6NlWc5z+lGZFxIZUMUzY2iGbKyDWLWuSmI=;
        b=PP9Lhz8ieXDxBG0omPHhG0fLIyjVKthZ/OFugjeUbiF38mzlVmYTVEwiWbZGcgRnvN
         /dNJkuRQ63qNp2NYG/ZyvZh8oGghLbxcYqINCKUYSSVdsb/4zKEsVRhHbQ+msQJ2DrsW
         nqblEg5rpcArJMxd00uvyIRQAYSa4V1VTXX1NqULVKL7qzPz0V6eK8ajfH+iSsK2v5P2
         1BWFsJnspJX4l9wLtwhpojDgvyRs7A3te69Y96Ui4Y5zliLqdmkBD4KnosncYOAtBD1T
         N2pQCiPraO5gtLxdxgI88Dmxkikl+fpKiq93T1WCpfYj3Jgc1AiRl2tW/KxU36meuR+y
         TElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784769008; x=1785373808;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XV45lch4j6NlWc5z+lGZFxIZUMUzY2iGbKyDWLWuSmI=;
        b=Vf1YfDcjG2Dq5X8U47FrcuXEjb07U+GrpCmMfgsEEsbeYLJ7B/reAziyVuZ1pFCFKk
         urRyUFyhnOBWbBpUU14ADKmEku5IuiYIXV7wX7lSvbZg0qdNOXVZk/ZT74m8MJREzOzG
         HnjaTnO+MwCmRWvsAWtjpHwlaRrGwApjR8MkPbFHHz1eq5OSUkKL0JUuYKxgNW04jB22
         158JQhlPRjLeGme4sGs3nOT0zjzONcNWBQYAho0qSHoELyJheaLkri7oJWD1WA3srZS4
         zPZ3OKxN73beBNCOwy5tNfbMeYndNXiphBfJDJYrHoQeX27HCqLpjGw6BISGnv8SXDnZ
         0ghw==
X-Gm-Message-State: AOJu0Yx8rxEYIcoPT7UWn/1oyIWdwv4BgdlDNoGxqEmE8g8QbplCgHJY
	PNvcM1bLX0U9K6EugcqBtQOmb7oWVmhYmF1xVQZQIs9PUX98IKU5+dnL
X-Gm-Gg: AR+sD10QmR1LbNplbtJrn71VOBNAxkV7k5JlQBTPrzZ6x/jFcO9T0MRtmRNrPpRtT2o
	ugjz/YDLuIMuFwfTpoKiACUQxrELo/OVlvY2J6w0G8varFSOdnKsVf2+CnOdp5Ut08hAdzIQY0i
	3/4zDJ3Z9vtUvV1pYjzoaBVMyuQvOReL8xe979K3V2g0Q4Ug/VCUTxs1DjomNKwvxi5kEHU8haK
	07pxPVlQfiPAFtA3S5JsKFA1cyJbhkGu/3fWAHs11IjMEfHLRY5nIRQk7lEIwan5g/FulbGOdL5
	m0WhFY6DW3TAqOsYAX1mFUCVeHI/DYp0uaCWJrKcjHg4mjZhI29Gl6UzRuhfDFsUYbCOkhgqAAn
	BEGJUWTDDHVW3BztvU13D69PnR9KSOPDKb7E2QPoellT+ECI2pAZpW8ZWvch5JMh3I9H/pJz/3i
	gjYfKPHpjAWBoXa+3xrQqr2bG+GFuUwk8q8BbMVg3f
X-Received: by 2002:a05:6a00:2ea6:b0:84c:4b58:2cec with SMTP id d2e1a72fcca58-84e2b7e3879mr1357215b3a.15.1784769008136;
        Wed, 22 Jul 2026 18:10:08 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17262d82sm2148975b3a.15.2026.07.22.18.10.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jul 2026 18:10:07 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	michal.kazior@tieto.com,
	Zhao Li <enderaoelyther@gmail.com>
Subject: [PATCH v2] wifi: mac80211: skip unused probe response countdown offsets
Date: Thu, 23 Jul 2026 09:10:01 +0800
Message-ID: <20260723011001.76851-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mac80211 copies cfg80211's variable-length countdown offset list into a
zero-initialized fixed-size array, leaving unused entries at zero. The
beacon branch already skips those zero entries, but the AP probe-response
branch writes through them unconditionally.

When a probe-response template has no countdown offset, the write through
an unused zero entry overwrites resp->data[0], corrupting the first byte of
the template. cfg80211 already bounds explicitly supplied non-zero offsets
in nl80211_parse_counter_offsets(), so this is a zero-sentinel bug, not an
out-of-bounds write.

Skip zero probe-response offsets, matching the beacon path.

Fixes: af296bdb8da4 ("mac80211: move csa counters from sdata to beacon/presp")
Link: https://lore.kernel.org/all/20260708195911.84365-6-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v2:
  - Describe offset zero as the unused-entry sentinel; do not claim an
    out-of-bounds access.

 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 91b14112e24f0..fd4c379b3f201 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5249,7 +5249,8 @@ static void ieee80211_set_beacon_cntdwn(struct ieee80211_sub_if_data *sdata,
 		if (sdata->vif.type == NL80211_IFTYPE_AP && resp) {
 			u16 *resp_offsets = resp->cntdwn_counter_offsets;
 
-			resp->data[resp_offsets[i]] = count;
+			if (resp_offsets[i])
+				resp->data[resp_offsets[i]] = count;
 		}
 	}
 }
-- 
2.50.1 (Apple Git-155)
