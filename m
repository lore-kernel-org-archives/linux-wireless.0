Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B157C40D565
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 11:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785237215; cv=none; b=SQlAoCcNyd6DEvYbVo+xII8WZZa9X3SaR3wrNahAgfyBzsh4uNExGM8EGHqqia6GPttgbz5ZTG7mMt+VwhQZCmOmt6jgwj32OislExa4hSNLoXsYbUVMAPlgO0wA13ItPMatzLh6nt28dqaaLiGbPTCN7XtGIKlDzSGwkO4ZCDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785237215; c=relaxed/simple;
	bh=e9EJOPMJQQmdhrX9ZLjutTgNigOU2bNeUlGTHv/ADiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hqDJt2/bgnil7VTgyMqoPUYo+MZMBcy8epl1bQ51U8OxgsaPAomxm3S3kzGKTxUhT9wL6/MZMCKgmerKKaK/5EDMdPO8zW7JHvxnH3EFXLoPEhKgRV1c6MQZUMWCA3+9rOb7LExg3F+YBSmYKT4wZVOkPLf8NrGCDLImVCxTHMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r7WrkE6V; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r7WrkE6V"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cbb662575d3so2132242a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 04:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785237214; x=1785842014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ef3Yb4VZjfVw3Uexl/SrI2+nfGjSSdskMXoJ4cJ3KC8=;
        b=r7WrkE6VZQff1oXL400jSucWTgahF7HFO9FvU0E8AXJt/XTL0YhJNBmuB6tzqLNjTa
         TqQLjYupJdFovP8eqXCkl0Y9sgyesXRmHivrW22dBeMgkeFXniQRWIQMvGoQq6LmHS60
         fJlKgt0qbxsdqLuc3pW1uEo33Mbg+4JCqR65qSAgkbUUZ1PJE1+RDopRO3PaTKwX5mm6
         jVyf4jY7wWWTU2RxTPlLKUM7D1rxE5QaD8btdZWViaf/SAnjhD4XvDU5K7HSgy6EEeO6
         79eRsxw435tWf98pkor8SH+7WeqJMlYQsVe2g3LpUTufNYSqmYSh2BSRY9XGq0tbEqrS
         1ZGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785237214; x=1785842014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ef3Yb4VZjfVw3Uexl/SrI2+nfGjSSdskMXoJ4cJ3KC8=;
        b=llmwuCSA1ApbNzBRw56gLPTxCQlMs+UIhkPiT4G4qGlLI6JVKbi9qIfdcWI6RejV61
         iWCenGE9eLjHaVHXacpVDdhnX0dCGLq62Ol4imAGUW7R2lR7Mr28b0fCillc3MrCwLMl
         vFcG1BeJiTTDy3T1FidtNCj7aPjVRZACBc5NkNyVQy3h89HLSifM6v1JGJb+d55aLuyT
         aUvSjeYuxExF6xOToN4oUNFh0zx9mP9Lsnn6/MZCaEz/1V/7z+AMuNgiSuSoncNeBN0Z
         U0jv1BvEA75+Yrh05H52+/CfxFTbLHfyEwGL3L71N6TATmS1IDif3QBoMuqB6y9jIXoX
         EkmA==
X-Forwarded-Encrypted: i=1; AHgh+RrRX+EqEExLHTQPoSZ1M/5UDH0E/7xW9AyXSQNTYlbQDzgavunMgs9clat3wwwFas1KL4ad8pZ33FauvJ+veA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ4xlnhQZp7ROAKu6QPEMmPnBjz/BifdF5SQpVxKs8Vxcv+H+N
	2KARF9rdm4/oQ9apkRSEv8Nn2d95U9CihekKQhhod7EQ+JffMaC/maZq
X-Gm-Gg: AR+sD10F2AZqrSMsql4ynLmFX7gbHwlz/2syq6jPZoUFI+8BHpdu9q+KPkS0+zomYA7
	KVfQlCDW8uBTecUHNcpa8pTtx+BUUsq3xNs/UQZGVGvPv/sj0wZZ53vTnN/UfW8gyx8+VSPBu7j
	dKQEuDw7mmB8XIjfP2R9P7pnhZq7gppK3ae4t3baV0HPwc4rlhwoHqdDoBWmQLGQjaHLm7/TBCb
	NDJHz39prNagXYAwdeb9H0uaq8snd6rKG3Un1RihWSfs1b+tn7Egdyik0ukvHVKt8xewfMX2lDC
	+d+nyskzDK5DJABuIFRf83r+DWuBn3GkWvPA5K/W2QhwSWUULK2NQFydjd57ykLX7BhiU59sL0D
	SEPzDdSkKzVrfN6QqAHZRqW5tCfVXLDtz9vzJywQLyOMdmFMpfugfAsckhscCBaIqNpZdOvIvlA
	Ss9hgfhxd1dF84moEniV1Ehnch5joczA+k3tQUutE=
X-Received: by 2002:a05:6a21:e598:b0:3c1:657:4c95 with SMTP id adf61e73a8af0-3c8aafbb6f3mr2587944637.15.1785237213865;
        Tue, 28 Jul 2026 04:13:33 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc548efesm43920950eec.14.2026.07.28.04.13.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jul 2026 04:13:33 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next] wifi: mac80211: fix per-STA profile length in cross-link CSA parsing
Date: Tue, 28 Jul 2026 19:13:26 +0800
Message-ID: <20260728111326.63087-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_mgd_check_cross_link_csa() starts parsing elements after the
fixed per-STA profile header and the STA Info field, but subtracts only
the STA Info length from the profile length. As a result,
ieee802_11_parse_elems() is given sizeof(*prof) == 3 bytes beyond the
current profile's element area, and data following the profile may be
interpreted as belonging to it.

Subtract the fixed profile header as well. The preceding
ieee80211_mle_basic_sta_prof_size_ok() check guarantees that the
corrected calculation cannot underflow, and
ieee80211_rx_uhr_link_reconfig_req() uses the same calculation.

The call site currently states that cross-link CSA parsing has no effect
because the broader parsing is still incorrect. This patch does not
address that broader problem; it only makes the per-STA profile parser
stop at the end of that profile. No production allocation over-read or
user-visible failure has been demonstrated.

Fixes: 7ef8f6821d16 ("wifi: mac80211: mlme: handle cross-link CSA")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fa773f3b0541..1b9d272e7f8e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7977,7 +7977,7 @@ ieee80211_mgd_check_cross_link_csa(struct ieee80211_sub_if_data *sdata,
 		prof = (void *)sta_profiles[link_id];
 		prof_elems = ieee802_11_parse_elems(prof->variable +
 						    (prof->sta_info_len - 1),
-						    len -
+						    len - sizeof(*prof) -
 						    (prof->sta_info_len - 1),
 						    IEEE80211_FTYPE_MGMT |
 						    IEEE80211_STYPE_BEACON,
-- 
2.50.1 (Apple Git-155)

