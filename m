Received: from mail-dl2-f43.google.com (mail-dl2-f43.google.com [74.125.229.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FD1414410
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790871461; cv=none; b=T6kDzW5Kn0eRc/Fa8ShLrx14cceG9CUV+DC2cvEFYqJJfQF81O85P8ykmBDWc5zNtVBfp64urLCzq7/A+GfYHUnLgjRbYj7UWpwsJ/c+TJGRTdB65cyWmk5JEthYvXgdTs+xgqpz1POX9TkPkX3+E9z6OCjnUQd0TmEWQzyySyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790871461; c=relaxed/simple;
	bh=k/5ig5ONwsnkdgPMJ5jhFJBX5ppFH9cc/Uo9rdAI8a0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UoCMhoaa4fcfUsgt7p+67G8TD9FH5zozEHL1MmL9EyTViDHjmC7azpLlkfLVAGo43LNEjEDY0uCmtG2x26PhtDWy7CvgZ5NwBVgE/SpV+msvMEKjrblfl+98fTrhlGxObpbFeHtY1PjPyOZV3kl50bcJWIXEYDPpiPtXyzlg0PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aFvXF4Ul; arc=none smtp.client-ip=74.125.229.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFvXF4Ul"
Received: by mail-dl2-f43.google.com with SMTP id a92af1059eb24-145ab8fd39cso6146841c88.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 09:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790871459; x=1791476259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NUuxBELaGQbgmCKkI/Vu7XcacxWn6YEXtbMh1ZJI2Ps=;
        b=aFvXF4UlmTUbW/BmS8FoDg8O8NGXYDKnxsLBltb5kOtRRmdauMmFxSUK4N3N8pNh4u
         azvSeTvrO8Yq/QWLXiwsXBHVDsGGqjJabH7DJfITPtFtJHwmlglwN6zeDkaXR24ncwow
         a75LQe+JVuYLsf7dSslIj4MtJC384jtgqnPX2OyEqRgSJBjPv13P77Ewu288NHAV1+VR
         uS/tuhO/eCYcmdZUT4A6qFZQoJLIo2aghsCuBYNimtvhkqrjnlFMGtNqAne3fgRTUJFX
         KDQAPkVYawCNDa/UgjICt807tDQEITZcvRhxFER6KCUGqE+iQX8Cgpr0RRqv30D5G7Xr
         cHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790871459; x=1791476259;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NUuxBELaGQbgmCKkI/Vu7XcacxWn6YEXtbMh1ZJI2Ps=;
        b=JZp16sW5lZI6WW9exHOWWbzUq7bvm7Xd3oqXdF19C4chPRJR4CXjSoWPngucO/OzeP
         r7YumBaab4ilYSRxFFhqzFVgCJEdt3i2SXWyponmAF7tGpWPOX+v3/8UmbrYJdwASVs4
         QxpjuIc7g264wt76ub93N5/Bh3WmSOwiF4hdsCvpAgK4elE5s8JilcQGJv9+vp8u6FUZ
         2RMCHgguWDMdn/IOWKkcX4VrkMNzAsSv3wZCIiQG25oZ2UtwirHY+5q4az3pTglS7Vfe
         /ACJ8vVc53bms263IRgChkYYvewr6BYGG5OYsHyObkajPH1jccTP3gikHiFsg+KhpQ9Q
         H3LQ==
X-Forwarded-Encrypted: i=1; AKwUvBykBwiKF8voiRVMSMBu3kI5vPL9Dzey57hfvL6gXh3K7ltd57GlFWixbEh7dgALvD5Ts34jPtzn6Y4Yl8P7VA==@vger.kernel.org
X-Gm-Message-State: AFuF++nY4je9mhqdflemBiAIvTzZUQqLLZnegkv6bP2+vxwJbog9NQUC
	ppLLN4Nb22n2LcvRRNyYI6hIIZayrIGCKm3LFzqyFf51YBa8b89DZUoj
X-Gm-Gg: AYBFou2EPbopvlkM2ORQQ2pY8rv7ucazgLga/FpmIJaaF590D5YuWbzdUj5CxeT7+W0
	KcCkPuJcvapIDRbVscaVMM7CgfuxX+PrQ3G7pdRWjqWLpllPvsqh0PEJmuXht4AQd8wPQ3tTxlw
	XUj2M78f99VIEchEqoEazQOb6yyhVpZ8cMZn8OTX5HSxaqohHgm0UWcnfCQHbokq1bMPZqtg0Sa
	blmVmPMLPM4Gvuvb6Fa+MPuA8uqDkEibU9QKeLnQH6W9bWNZAtvLa1nIFiR7gyWan7YzcnBlZFG
	UgdvSn18qsU07OT4DNUEJKdqObSIzIL7HA5nSjYFc5kens0QXcoBa8kAWFbbhHMroKi9OTfjQdb
	87bNoTy3/UB2vzW+gUUkoBuFx9tFta2boavE5VrIcHEv8Di6b8SntBPUMpxFxzh4EmoQ+ZReXU0
	Pz6Y6mDOkll+Brzx7/GpdBC7e2EDrr21dLF0b9uBt2p5ZYXgynJV0BDEZ5vlcOC4r948U+UWAjy
	UBv1yyKnogbcqNx/KgVLT2ZfjTQsMPpd8RtrWYzRpxgOqjlff4Mqwig+NtFxpSDec4amS+w
X-Received: by 2002:a05:7022:b889:b0:145:f4:1401 with SMTP id a92af1059eb24-14d36cf68ddmr4922780c88.46.1790871458840;
        Thu, 01 Oct 2026 09:17:38 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:301c:f8cd:a4cd:e25d:fdef:4a3b])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14f27d322d9sm369601c88.16.2026.10.01.09.17.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 01 Oct 2026 09:17:38 -0700 (PDT)
From: techyminati <sinha.aryan03@gmail.com>
X-Google-Original-From: techyminati <techyminati@outlook.com>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aryan Sinha <sinha.aryan03@gmail.com>
Subject: [PATCH wireless] wifi: nxpwifi: fix NULL deref and leak in authenticate
Date: Thu,  1 Oct 2026 21:47:13 +0530
Message-ID: <20261001161730.49134-1-techyminati@outlook.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aryan Sinha <sinha.aryan03@gmail.com>

mgmt is allocated but never checked, and the auth frame is filled in
right after, so a failed kzalloc ends up dereferencing NULL. The skb
error path also returns without freeing mgmt.

Hence, Check the allocation, and free mgmt when the skb alloc fails.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Aryan Sinha <sinha.aryan03@gmail.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 86304ea33..9eb809caa 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -3403,6 +3403,8 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
 		pkt_len -= 4;
 
 	mgmt = kzalloc(pkt_len, GFP_KERNEL);
+	if (!mgmt)
+		return -ENOMEM;
 
 	skb = dev_alloc_skb(NXPWIFI_MIN_DATA_HEADER_LEN +
 			    NXPWIFI_MGMT_FRAME_HEADER_SIZE +
@@ -3410,6 +3412,7 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
 	if (!skb) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "allocate skb failed for management frame\n");
+		kfree(mgmt);
 		return -ENOMEM;
 	}
 
-- 
2.46.0

