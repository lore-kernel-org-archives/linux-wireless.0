Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653C02853E0
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 07:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788162756; cv=none; b=j8kimE2c0YhP4PHRnGgqG7W7ORd3Tw4zTD7e2VN1sHL10GLVQTFbdwYqZbM5hW3nKwgCE7EuXq8u3pY+rrxB59iP+SHfQyKBSTFdbtGekBvJTbLunXBmUaKLXUak7zgcwSX1jHEYz4ejzFNriOgoW/VwY3DesyuMSxwBMVVY77w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788162756; c=relaxed/simple;
	bh=OXDgkpkpNgPyl7oWvgcmu7eMaUg2MwDcP6GbniOs4gc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kZ1GtF6enLK29WSefbJmdx/ZMTlnuHk7xAg7T+zc7EFdC0DI7J47pj1OY45iJIkp40DwkrRQ2EZ5AuGrxO1tVLgc2EfAPBBktbcJO8Eu+tRrpaUkxEsJD7FV5gHoBnjrXC37pHh7dR+Hg1XdpTyb+LHKK9fLO30UnwE8+JZhVwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TWBbC8vE; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWBbC8vE"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so3195193b3a.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 00:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788162755; x=1788767555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7XOLnI0Bp74nz7GsZdhQ+Q24V6cVlLUr+JGeJJ8isyc=;
        b=TWBbC8vEkJ90wYLjn9xrjWXyiPdAqx4HTOialh3ulwiByKXaD4DufYm6iyeP1hzaXX
         kJ16qsV+qzZ4/TE38kBoT2A71KZ5chz3SoERfREwxbebJcd7IouJLCpa6gXrqne+6P5u
         3hgqzHgYykgEMX0QUmCsPq792ieLBWBhBEJWsKjp04NGzFsn6P82WvHAwBulcAxgOtEl
         YyM5ObuLye7yRQMGwwtPA6Axg3jl88bQy7nSkJaPS6vke7SHHvqtJCJb2rbbuAAwnDPq
         UO6hEdEvvxiWpSqTc/4OujClCvoK2sdB0mFpCYzOTHen/6ITKkAxZdg0dl3ztjspkbyt
         H2Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162755; x=1788767555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7XOLnI0Bp74nz7GsZdhQ+Q24V6cVlLUr+JGeJJ8isyc=;
        b=rltIitfDIpxYavA2kj/yhM47L5TzZe4fbbs7q6WknKoxV9QmQ/5D216l91FIhY28Dt
         T7+hqUeaaI4aB5I018nUI8CVyWHI8zew1B1Vw/NIUT6wQgCq8kP6MX9jf9+S3j/cfw5x
         koth0VBDYA2O4tUHR3NI6lj43GYzB/cG9UznJEKO8rwr3a2KoUyMdMx4O+j0SJck9+NZ
         QBfOtmXuVkZVVILYmHe/wwmMvm/9bR8nms96Qjq82rT8ZQP+2bZTTvh/U2aTTmupCiVA
         G5mjtqVrMcSs2Fp7Ib6Nv4yPn3M0ShpNbE6ysymPIvifTy7RsO3u/FGQK13qITn0Ca98
         YERQ==
X-Gm-Message-State: AFuF++nBIlahQqz3+H5tA3sRh5aZhS7oQRhoh/UriVIaqYvs+o81gGX1
	s246SUziavb2+g7iw5pNzPExy/02uwcd0UH/8197Su/zSXztHgwNWwOgh9Qq9Fi8
X-Gm-Gg: AR+sD12J2MtZD/JDrBZc9vzgw0LFvKEauhdYOeUEq+PHxlvduptv5R8ymHBwqYZel4/
	jolgu/sZOB/M/1Ogno472ZzYKiVydUYsRU1Qk0VVmAoJ8ZZY2j1vJeBjHGhxt+MpJeLVeIyRdAn
	KcTCCY0+G/IQstvaM705jVMfwUQ5cF139TrqJrr8F3fNA4YD6KZVG1YCLCDDmoeo+nHQg21MIFq
	zWU62VUQLuzSvCC+LmnAvz51piUIiCmEo8r4ExzV8A3TIMWngfhkCbZGJw4rzf7ohxq7j+tgttg
	YEkxOfdVScKy51SO0tqGUlyrq+rXHsgNlozYLK64EXQfrklUbO9N1AUEn4TfzvP8ZWRI6jxyKFD
	QvtpXT4qN5OmSGCFYhOeu0QfinzBmHhdX/ysQXI5mjJsVxn2OaaWsC3l3Hx9XOIPINZzmwGjIHP
	aO5OKkX3nPMHjwyafLIzHA5mHtv9KG8HFB+hLxQ0MiN5bcZoGTvVYSO3Ho9vk6oefxX7Ne4FGTa
	2OEpgHR4ydbQElKrRHTyDWhF17i0L8Sqp4fu4d5zmqUTdsw8xoZmppfF3u1/DbjSYy7jyL+c/R6
	2w==
X-Received: by 2002:a05:6a00:f0c:b0:848:6c9c:4074 with SMTP id d2e1a72fcca58-85ad9242840mr2294361b3a.1.1788162754590;
        Mon, 31 Aug 2026 00:52:34 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (61-228-209-44.dynamic-ip.hinet.net. [61.228.209.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8569f984f4asm3163147b3a.15.2026.08.31.00.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 00:52:33 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	arend.vanspriel@broadcom.com,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH v2] wifi: nxpwifi: fix return value check in change_vif_to_sta/ap
Date: Mon, 31 Aug 2026 15:52:26 +0800
Message-Id: <20260831075226.136883-1-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Chen <jeff.chen_1@nxp.com>

nxpwifi_change_vif_to_sta() and nxpwifi_change_vif_to_ap() both call
nxpwifi_set_bss_mode() without storing the return value, then check
'if (ret)' which tests the stale value from the previous call. The
'if (ret) goto done' is therefore dead code, and errors from
nxpwifi_set_bss_mode() are silently ignored.

Fix this by assigning the return value to ret, so the existing error
path works correctly.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/anwqp-LuExbRshYu@stanley.mountain/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 5cc8cdf594d3..335221c4f17d 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -844,8 +844,7 @@ nxpwifi_change_vif_to_sta(struct net_device *dev,
 	update_vif_type_counter(adapter, type, 1);
 	dev->ieee80211_ptr->iftype = type;
 
-	if (nxpwifi_set_bss_mode(priv))
-		return -1;
+	ret = nxpwifi_set_bss_mode(priv);
 
 	if (ret)
 		goto done;
@@ -888,8 +887,7 @@ nxpwifi_change_vif_to_ap(struct net_device *dev,
 	update_vif_type_counter(adapter, type, 1);
 	dev->ieee80211_ptr->iftype = type;
 
-	if (nxpwifi_set_bss_mode(priv))
-		return -1;
+	ret = nxpwifi_set_bss_mode(priv);
 
 	if (ret)
 		goto done;

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.34.1

