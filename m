Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B34382F15
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785481875; cv=none; b=pyf6LDSSBJbt8UO6LI6XoDMAUettur1Ia3vai/0rFBRyStRnLMtF3hJ37EiGvqQhpxaoMiOL8liTwOwSydp0nxmvglupQowvqjZm9yKLjb2NFRQBH+Bdxc0hIC2EsUGaQVGhQ9Pz4lCw4xzuWBxTGpIsJobhm2pAPp5VO2fzeBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785481875; c=relaxed/simple;
	bh=QBxqLpkuoclvdW87kAV0VwP082ao16ty49gstGMK74c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XXB6cjprlc8X2fGRTNrVjE47nlTXNZudDP5kgRViK3IpmZ53xJedZU/1ebuVBLTuvrrh3VNevIsXYfqb4sCAfIa00LvIk49+WYwvQqj+Egpk+Dsxk1wu5ffhyEgjHF90KWuKdLifXl7sJojiE6amSa1dZd/cAyDHTr4B6+ZGl58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mq5udmqn; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mq5udmqn"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cc97653887so6722475ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 00:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785481869; x=1786086669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9fQeZIHEBXy4iMTbzliIUKRsXdr80McjIgofNNYPCn0=;
        b=mq5udmqnVuDrioyTKOLhDr1oYsKTSDYMVyTMvu5ewL/G9pJWiBRW7/P/bdcqvFRrpN
         tiPqPdoReXhb4JtbRvqISDaXAwMTnvRGW5Tw/5f71r5Dr47vNsXJX3+xjdCZTFHklKzT
         zwZc+tMflhBZEMZxZYI0bFShAY7/RhhdW1AhyebczYBz6eaxTgZIWkh+CCHHo6B4RCBS
         tLHPqipvsMkbHVbaoUZKHXw9hk9F/i5q3r+dk+BiQMLOAmk2FGgrOq59YhGI15VYrtLJ
         YvyoRKGZrO+A6LimCp8yWgsEQA9NqYl+5jh0zEa99fp8bEmkkhWdbuDY9IRmNox4JwLY
         Ympg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785481869; x=1786086669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9fQeZIHEBXy4iMTbzliIUKRsXdr80McjIgofNNYPCn0=;
        b=c7hbJ7lYrxrhK0GY2we2UQR/vtwQitcTOYta2GvaSAvjTZtWwN1DXraEyxaI2YPqS7
         TiVcFFumAFdxPC1Hhz/4B/rminFftEiIDo7t2vm4cvj+JzzCQRFcpJllfybr9jEuPDJI
         BjyXMIkLzj7rr1fexlibwucV1BQQdZaAwE5S+qdTgYDpoO0BUBX3jjx+/2gsgDBHdrJJ
         1OZk78sOKgaJzm3gnCPt/7HY05voqyCfberIa2aTBl1X3NT4owJWU7B9S9XoamQPiSA5
         bUoVmk2JQw1U8NIJJZqFofHLqzEChjpXQmO1swWpWQe1Qfekk1C2OH2B207dYn63d3o9
         lz1g==
X-Gm-Message-State: AOJu0YyBzaRfvCVvVQ0gr3ii3Pi5MHNw4glNfDk2074kw58e8tr5diaz
	OJy++fRxa3BLE6lGQXObBpICHkvi7HJ3397glRiqPlq41gSHXYksEUx+
X-Gm-Gg: AR+sD12ToMSFoSaf61MlWOthDcxNdoU7QSdYbNJfiUxAFCMhEJ0FxtPlydkOuPc/2dT
	iatxKFPgwZwx7vxtC2742remsgnMlSO1mpJf8Zgoppuv5js3jEbNzAf0uu4geUBbd8pT3NgPc9Y
	pp111o/CJ5VNThK+n7t9l4b9rTqEpCQPNyFQc27qCErKAdu8AW3u9n24Cw3T9HVp5KTE6xVxz/g
	tPzT1SrDwuTtM3XKPH83Zq21qM/AZnI3UfAm8AZ6PPz3lHTfBodrmkOuU/JzVrciqe3e/jZpEqj
	C79ifkpVceQCtDVYPU6G0aLdmm14F9utKe/5uFP5Aiv1pp1r78BXiFD94cc7f+40V6MIJhWq086
	xJJm+BTzOCaQsvtS2d3mgIjVOExkdDulidvxapDjgeAqyXqmgl3CjT0Z/K4YwX8O5jqbFHuXvJe
	QQSUlDW3etEtqehLDl+ngAYQ42CDiFAoU98XuPxCtxbCWs50iUQq7C50ZP/4WoHrpMqlFsRVRSw
	WYvG23Lj9IyB9vaz+CE+qFZNhzmcLeaAI7Gglx9gY80WkWs
X-Received: by 2002:a17:903:4410:b0:2cf:7bfe:6043 with SMTP id d9443c01a7336-2d046db01b9mr10032235ad.19.1785481869104;
        Fri, 31 Jul 2026 00:11:09 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm2082881eec.9.2026.07.31.00.11.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Jul 2026 00:11:08 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: cfg80211: stop PMSR before P2P and NAN teardown
Date: Fri, 31 Jul 2026 15:11:03 +0800
Message-ID: <20260731071103.73563-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PMSR request teardown must abort active measurements while the
wireless_dev is still present in the driver. cfg80211_leave_locked() and
cfg80211_stop_pd() already do this before invoking the driver's stop
callback, but cfg80211_stop_p2p_device() and cfg80211_stop_nan() do not.

Those helpers are also called directly by nl80211, rfkill shutdown, and
wireless_dev unregister paths. If one of these paths stops a P2P device
or NAN interface with a pending request, it removes the mac80211
subinterface from the driver first. Subsequent request cleanup cannot
reach the lower driver's abort callback, but cfg80211 frees the request
regardless. Driver state can then retain a stale request and use it when
it later reports a result.

Call cfg80211_pmsr_wdev_down() before stopping the P2P device or NAN
interface. This keeps lower-driver request state and cfg80211 request
ownership in sync for all of the helpers' callers.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 net/wireless/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 610238d723ff..d13310fef691 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -237,6 +237,7 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	cfg80211_pmsr_wdev_down(wdev);
 	rdev_stop_p2p_device(rdev, wdev);
 	wdev->is_running = false;
 
@@ -264,6 +265,8 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	cfg80211_pmsr_wdev_down(wdev);
+
 	/*
 	 * If there is a scheduled update pending, mark it as canceled, so the
 	 * empty schedule will be accepted

base-commit: 4a0bd262df757b25fc4e2a53c947317c119ced4e
-- 
2.50.1 (Apple Git-155)

