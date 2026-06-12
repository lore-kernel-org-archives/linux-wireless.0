Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229453C277F
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781271418; cv=none; b=QpWtMYqVIJOwK6jD3hW4cZ/P48Cj5GKh6frT4ez8j5UfEB/mEgY+jnSCZVAEV4z7qB7yq9RG+UaQ9Chcht0SGUCsr7O9g25Ovb8bqs7sYIwJEF36jYQrK4ymRe9vS5W/++icMJ9IhSiXK1HWXV4x/csSDRni6sfzuIqS+V5rUUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781271418; c=relaxed/simple;
	bh=nCpdhIunvB06QiAzGtqEd5PSwXEXy/YkzxmjFScsVGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZE5X2iU++n45Azh9QKWcEJO2aSVc85FOqomgQvqdVF25STtT1OOPNwRBRCNGj1dSeIclG+7JgJtxK/h5938er8HBjsWBFweywT6JQ+QzJkmBuUjmTk/BtVcmrIotvju5+PKo0rnRvUgdlIKEQvqG+KlQ87XmWzLPobsHd74+i28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o9aItiyr; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o9aItiyr"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2bf237e1433so11454945ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 06:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781271416; x=1781876216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bGQjtNDHafVkCF72eksxJ6HFAyJPMwhm2V7Z5ULHxOY=;
        b=o9aItiyrbuRtCfRcg0NZcl29uhEuOtply9AZa1M04fp+uxFPXMhn3WiwLQotr0ryuL
         W1cD1OUYPjk592KEN6y+wcC/SkH6yaq4jm4ydJA902Kuw+pZTSq9iuu8ju3s/ez7S9kC
         JbgNWIt+QuK9dxo30BElj/YeXYYCMTKcUbaK02WlRLzhPRr3scQxOFiSnHm8pmYD27Rf
         1kdd2r92FSwOKxISGFzdE7Y1RsmunzKuFWzJbQhtQO9+jRQh489WAemsErMt6IdEzp/F
         cCjMV8WHrfAU1mjyp5rYPqoOriCY5odUrOnxMi5m15/sgWNAXowrlOdVDI3BxDXFBS8W
         Assw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781271416; x=1781876216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bGQjtNDHafVkCF72eksxJ6HFAyJPMwhm2V7Z5ULHxOY=;
        b=b63gKxJCxPSXDKgzKy8lxFLyJaAnfRNdep9S9YbFXoLA+NkGncfMMydOCMM/G+nx9d
         GxR8vChrYEb31sNj1g2bgLCLvEDRfDiYJ6eI6xmcy52/8hfkshx46rHF0Ce63LYJJP5E
         fbbq24YrC/0MVjOSi/Hz5KfcXKZN3XzdE6SiPgj4+BDj7jiKPeIR+EDzsNVOcf4kgxXS
         0liApQZfee6HSShsZdZ7ofL07bhtcQya9Yi48sm1OUY/ofmKcj9cZxjTbk+ypWakEV1h
         j9KlWtQiG0zNYy7MZBy4f5vmaswaogEDLpJZ5ieRogNpQ+MUD2GCpWhcgpa86cVPrcTX
         F3MA==
X-Gm-Message-State: AOJu0Yy/unB6VKoizC6pbRY2/wn+DnSTrdb4Mk6fGdwl7Y02IgWJiYPR
	NgLiwAODM2jTm3fnFgRwY91fw0K7KDJMwYYm55v2Mw22E1e2M40uLBZh
X-Gm-Gg: Acq92OHKvtwyo+xTh3kBFZsI3Q4BHfY3HbUS9xEzVnRCPgAyqj5dfRPEvlp3MXdmZ6j
	iGM9l81uKTLxB3yO98eeM2zofIVH57Tznt3KBLYcRVZqyIuK+/nJwbCaa9PbiioV5BAaSoX/keI
	nY/khnYqTXDhgvZ12mPhCdVBZd6qu502s0C9+chFX46S+49YdNVnHtGXsTjh2/P96f/VQuOXelI
	133w3RVz6/pgjZjV8G53z0bWCYGeobwtp0Li+JJ99Qk7AaC1w0iMV3JP5xapZL3t9qFr89nd8Oy
	07Gtva7hcCkRwc/7UO/lAs7e79DXZksv+10l/50LUSCcDwWj1UAOc3mI9WuTbjFQgFKPcLE+wq6
	oNB6XEDHgY9JWlaVANTSVYYdGByht+DusyYVTGEZ/cQRQ5aGkkb8AL6C59jpy7DnMU0ii1kX1qL
	OhVe7JoYZkpvONg7sdFBKt8u/SOfYVHuw5pxWTSSoNFG3C27F6Knhuv8b+rXK8xfw=
X-Received: by 2002:a17:902:e750:b0:2c1:e04d:7cb5 with SMTP id d9443c01a7336-2c412841372mr35915755ad.34.1781271416371;
        Fri, 12 Jun 2026 06:36:56 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e59e1sm22777925ad.17.2026.06.12.06.36.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jun 2026 06:36:56 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: avoid non-S1G AID fallback for S1G assoc
Date: Fri, 12 Jun 2026 21:36:50 +0800
Message-ID: <20260612133649.92630-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When assoc_data->s1g is set and no AID Response element is present,
falling back to mgmt->u.assoc_resp.aid reads the non-S1G
association-response layout.

Keep the fallback for non-S1G only. If a successful S1G association
response omits the AID Response element, abandon the association
instead of proceeding with AID 0.

Fixes: 2a8a6b7c4cb0 ("wifi: mac80211: handle station association response with S1G")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 net/mac80211/mlme.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b98ddfa3003e1..e86adc0371994 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6737,8 +6737,12 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	if (elems->aid_resp)
 		aid = le16_to_cpu(elems->aid_resp->aid);
-	else
+	else if (!assoc_data->s1g)
 		aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
+	else if (status_code == WLAN_STATUS_SUCCESS)
+		goto abandon_assoc;
+	else
+		aid = 0;
 
 	/*
 	 * The 5 MSB of the AID field are reserved for a non-S1G STA. For
-- 
2.50.1 (Apple Git-155)
