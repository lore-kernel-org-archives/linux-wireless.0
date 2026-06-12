Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24C2391E59
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781271446; cv=none; b=rj2s8iYXBgK8Ajc2HxjRaneY63Sa2rPB8SOq2Bom/kMpid+ROI2/Ss8g73opyZI22Hk2IJOf8Z7QATbq6vD9IJ3WvXZycekKBFmCTDlsjSBInEeQ+GXZzeHsnT6JSTuM6wn8TspVhNbID0IV+E6EeSwsNwUZcq9EIVaqjkEow4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781271446; c=relaxed/simple;
	bh=HBMQIc3i0WSqme9qm7W+Jpdq795wU8V3pCCK4mnZhTY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pi55rX/CAhFJ6IGu5JBxuPO2u0PMdQ1KwN8Yi4aybgZdoMd+nDtlmwaglb7z0Okv2gJ7VPUid3XkVQsVFDtX3HvBt4sw2NyUWN8ZHOWrsjrBD/Hbmn7DeQ5EgiXQ8QwAXnu6GLk9vhq2s2SmcENgTzdz2oqLoqj7jD39lJ3yLhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XjEepvBs; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XjEepvBs"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-36ba706ab46so608626a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 06:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781271444; x=1781876244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YiRDV2O79UKL4VyDu2d69JL1vYhokaN9C+CWmuW2Lhc=;
        b=XjEepvBs3CpE8p101To8OdECgrjyAqryKHTX4io6GFbEjcBBEj+00kcwhpvlryg9nx
         EtqWXo4PiwgnfimGar3So9t6Fock4O/UyItUGohV6K2VeyUcho6Lucj+fIGtwMDLmUxj
         IrO3+WeIoTeexHt6GS6EHO7dKRGPSId8j0/iSUPirxQiLrD50q/Rme2nZP7GIxT0w8So
         1TVxFVMidg4IHTosol2aX3u35OsiPNHxHC71z4dzrFECPAzZwLkkNGEpzZuFlt45Fjp3
         M0Y4PLm6A0sXp4YwjXjw6FohPO2pyDMeSK1YEmPmlRT8LU2GB/1FXbigz8SmjAbpVLjp
         MQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781271444; x=1781876244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiRDV2O79UKL4VyDu2d69JL1vYhokaN9C+CWmuW2Lhc=;
        b=Y8Gq3mQyNTMvSb8rRyZFegpkzO3rZ8WgI7Ypn28vlHH645HSQSC4iYUXruGFvKDYIB
         Zq2AdoYw5FBkuKRB2RX7sTFxluH/7ckvWCHoBRf0vIcbu/peMZ12kl2bS6JdwREu6H5r
         iVR/qnMyKItPVCEtoMGYzmCKRLDuSl/ZBHRPiZCjCFy/cR12xB7qn36yuA8dgzVLWnwz
         X9RoWKpes0Pll/b+Ty7tgpHNySwmTd6XGWVwu7esvaHnPt8ySmiKw1D1J/ZpAHrvEyeD
         TGZyU2EyyHZu9ZUdgCwk4ojs1FXMvMH3sBRByZuYmwyvYcNO5rRLMc008g3MPo8eRnbH
         FTsg==
X-Gm-Message-State: AOJu0YwldQ5UkyrlvsCMw20qiOCUS6gV0UBqLiE+Fz3IxehJmL5EpRsd
	rrGkpyqwjPts3ytJydey466j2RaDG++ptSde7uTCmcgv8s70UY2FtCR9DSmBmnxCreDODQ==
X-Gm-Gg: Acq92OGeTDdR8JFBMFYGaDMyKSC1XJiui6kiVLV3UJ+xkR1qsSSySXSf76RIZiw+F6I
	nUxj2MkI74RPz4808v1FVa6MVkyG/A7mOBC+E3Pdsom+6CMyEAE3uWihXqJ2dhCwZTwq03qe8wh
	gQbiWFaliZ4+gSz5gKITShta2x4j7W9KsnzipYG84lanreW6o7DLX5QggTN5MajEYpIBscEvXGC
	ZJTTWnByVyrZudvcvKSHtHV1YYW5+YIDreRc+isZc9UzX1PysvpW+A2s4dUD5PQw245xD/Vn0w3
	bRty8Fohmo+zyv6qcpfRaRiBmC9Pjdkbv5hCfJErIp9/DZRJjiouJsXTqLCUjCXhTqxdTrCBY1P
	bSL6bj9RZIWHJ5pr6r3U3i6C7iJrunXDUyhmQ8q86PDB8lYRyEei1hIegmDAedX8c3sZaB/6XeA
	h921skeT82vh6zfT+0VQJuRgwE1J9XJrq/LaVLsy6Cerwz9WRMeKtMwvJwIoDjI5g=
X-Received: by 2002:a17:902:ebcb:b0:2c2:75c4:4b0f with SMTP id d9443c01a7336-2c40ff3a21emr34986165ad.2.1781271444283;
        Fri, 12 Jun 2026 06:37:24 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4327acab5sm21668695ad.40.2026.06.12.06.37.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jun 2026 06:37:23 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: cfg80211: reject empty PMSR peer lists
Date: Fri, 12 Jun 2026 21:37:18 +0800
Message-ID: <20260612133717.93783-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A PMSR request with an empty peers array is not a useful request and
weakens the cfg80211-to-driver contract by allowing start_pmsr() with
no target peer.

Reject empty peer lists before allocating the request object or calling
into the driver.

Fixes: 9bb7e0f24e7e7 ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 net/wireless/pmsr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index d6cd0de64d1f8..3bf2b2d2546d4 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -313,6 +313,11 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (!count) {
+		NL_SET_ERR_MSG_ATTR(info->extack, peers, "No peers specified");
+		return -EINVAL;
+	}
+
 	req = kzalloc_flex(*req, peers, count);
 	if (!req)
 		return -ENOMEM;
-- 
2.50.1 (Apple Git-155)
