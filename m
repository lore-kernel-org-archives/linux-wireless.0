Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD1C4D09E0
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 11:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789558641; cv=none; b=MCzLFxqRBWlcmyGO+XCeKNcSsLO0d+eiA2bOQH8iIYx5YQmG64WuciYYwadbkn/gpChwTC1LQJAxSEFtGWfRRuFvQC1B2g1bemFlw4F6PmgbGv7QfYiJ6NAAw4pZ2SbYeKdQVLbTPg3J2Vt9rWN+5bXPGE5d0Rvg5ZVW5FFlGg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789558641; c=relaxed/simple;
	bh=FbQ6xgNpLh1+aWQRKalxyJfNU46gtcOpd5w6xbKJJGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mHHOG9gLsZceiz2DOgOlKWMku1x1HPpUk/HtWn0NKyp5aDT/yTUUTK5Buhji+otS3m6MkKP9IHYfLEGvnY36iW249iZSzp6PPyMa+gAdw/6yMCOLRlCIAhRWWo587m6W0um1FgBEkygr1hMbefSZYfMfgHqZe6hWb47Hmf6DdlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lSG092Oy; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lSG092Oy"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1cebad4aeso665092a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 04:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789558631; x=1790163431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cEQLS6J2QTb1fD6UW23RPMak1P8fPzYBsSNcEOaqPwk=;
        b=lSG092OyiFbZf4EA6ioDQIAAT0sp/bEmDdi/1qYSTeas+HPZIclMaD8048vctvErEm
         Xew2lf/IWW5crpfpwbB/GVf6DhlpobCt9o+L2HbY7i5zCrHyobrL8SFybQxVpfzW4dfn
         gK1R7khd8getF/gIi9X5/MBpgk39k2elN7z50odWcNyOqRaSkteDxtM3/Mv5GMn9zaSr
         0OPewhAoxpzyS1k1aahkrHZ25/wITxfhssVGikYpm7nABOlP33Zx6AQYp9zSYvZ1swUg
         7LH4I8m3DbLfp5gErWp5FhcyHX/X/WbWrLXyyl3xF1RlWakKJAHDY0A2kHs7eujpHrqw
         WmiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789558631; x=1790163431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cEQLS6J2QTb1fD6UW23RPMak1P8fPzYBsSNcEOaqPwk=;
        b=P1eYsJW7zVyI6Gf2DbQZzmKegTlWhffo9Y+u/CJ3QvTj6uxC6X8Xii96zt/wTHcXbd
         x+AoDdW5VKOcxfpO0CfoKvAYqsLXJOGJ3YPYiboMfMjS12Zgs4nlRmC5EAAIRt1k4J9q
         9cKTVIr27C3RHkNjW+T+/7DysPUG8KCOvXK7dlxzWonHusGguX6GUCz9bezwMaYkB/p0
         BQpwiYGVysr99eR0A3gzUaSian6Q6MLzV5pA4Z2mlvkAskbZGFtuB8ouMVV8YyC5NUvo
         JXiwY48PlKVHnMks8ll3zhH/jW12Z9zuuDQbFDTuymnK/E66w/fdHq2szAMI0x0s/kx3
         KX2A==
X-Forwarded-Encrypted: i=1; AKwUvByhn+mqxsvDvlduo8st2Mm2u5Ety/3QMHsSaHciiYf6rVBf45aLnBCt77T9Ou3Z0sX+xcSg/BQu4iRWA9+k1Q==@vger.kernel.org
X-Gm-Message-State: AFuF++kqJouH6BknIMU/RDIqK6Wb7cklfBqcTZxOp2K4Y44DPnHxmRpu
	BORu5m2vEtI8zSzWss8Ww6EpprdHl0N/WK6FPyCrW/0w2oP9YyXReqMd
X-Gm-Gg: AYBFou3RmvUqxUUlSbkrK1fx3WURKN/uftcf+eMumBh58a96HkN8Kr5hvkbrD/dpi9n
	JXuIVWlJ3HluKTvAfpx2eUR3BB5k9FlZKu58V2CHvckfW0t4d2kZwA3tFmoU47Fha8E05g6Dbf7
	Mdsr5Li+BLe8pInf0U0v4YjXrHUbKZp5bSd3I09xLQHXiUTnd2u5dliylKWDoeH8QAMkGsh87Sq
	SfnYzb+LJwkzZ+b0JuQvl0/dtU5kbTVZuuGS/Q2EXP+7cMWNJ7tJ17k7mrUMSzXKx7V8Rvc782P
	W1zxGSUSdRahxHxkpr1MnoZ1fcVDF686enFy3riqoVLXAgXbMJ2iji2L27js1fQKoI3rBluIDZB
	AfUAmNAdmmHiQVk7UdNt3+zpPvL5O/oUL/ybUviX/D1jgy3xtkJ1WcXqDoKLCJp1Wk/xEK2+RNA
	FFugL6RkuddJ+XRdPg8NOmqePF2tj+tShjFEQH4AIEoI3IsLKAwq4XWn8o6DobjOzNx2iK41vwp
	4/Hpj+QuQ9U1rspRnWVzeNyjBDbKzM+frpT6lj+aZvF
X-Received: by 2002:a17:902:da85:b0:2dd:89b1:7fd3 with SMTP id d9443c01a7336-2dd8dc06d6amr44900095ad.4.1789558630843;
        Wed, 16 Sep 2026 04:37:10 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f02fc2sm9927045ad.59.2026.09.16.04.37.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 04:37:10 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wifi: mac80211: balance mesh path quota accounting
Date: Wed, 16 Sep 2026 19:36:47 +0800
Message-ID: <20260916113649.28315-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The interface mesh path counter does not track the number of installed
paths. Failed mesh additions can exhaust the quota while the table stays
below the limit, and proxy-path churn can drive the counter negative and
let later mesh additions exceed MESH_MAX_MPATHS.

mesh_path_add() reserves quota before allocation, but its allocation,
insertion, and duplicate returns never roll it back. mpp_path_add() does
not reserve quota at all, even though the common free path decrements the
same counter for entries from both tables.

Make every successfully installed mesh or proxy path hold exactly one
shared reservation, and release it whenever an addition fails. The two
defects have different origins, so they are fixed in separate patches.

Validation used GCC W=1, Sparse C=2, and a controlled production-helper
accounting matrix. Allocation and insertion errors used test-only fault
injection; the concurrent duplicate path did not. A separate two-point
hwsim 802.11s run reached mesh_path_add() from HWMP PREQ/PREP processing
and mpp_path_add() from received mesh data with address extension. It
observed the proxy-accounting difference with identical table walks. No
physical-radio or layer-3 success is claimed.

Zhao Li (2):
  wifi: mac80211: release mesh path quota on failed additions
  wifi: mac80211: account proxy paths against the mesh path limit

 net/mac80211/mesh_pathtbl.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)


base-commit: 50d3d79dc0743b616afb00d01a626c76758721f7
-- 
2.55.0
