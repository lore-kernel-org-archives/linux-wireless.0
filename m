Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1C24E3EC1
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449803; cv=none; b=L2DFq/VcwxrqodprO8o3j0e9syVBTIo3El7s4+0Zd688BtXxxDT7CjSCKU/CYHVmfsoLqri7X3kFDuaSqa7c5d3Cej9lrYdG6bR7xYZjqimB//n6e6F2vaBVF4bCL5+BqueHVgnNacOGxOSLsWvv5Dm25LQbnfgeruQAckF/H6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449803; c=relaxed/simple;
	bh=qsFwjBfu2NKtEcsDviKHxw63ntmppkT8r3P6UxlkbOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zk+eAEEf21PbndW+owj/aUjH0TPAq4U/bD9UWXXxECKDsx/CnOHG+RamNdzTOHbW5R1amVy01jcw1b/KAgX4pHIvX9/nVcDT5ZcoVKHeAhXNuxkWahaOIaQz3AnPtF4jmGJuCOE4u/wBFwPL8ij16Yaz8CxE2oAhuNS/N/gQtcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvpVhIdC; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvpVhIdC"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b0d78a801so22295e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788449800; x=1789054600; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ShvhKa6MyfZ1jEWheQQ6SuhEnn7upG8Sh84fZvzR0n8=;
        b=VvpVhIdCDu+E+q9D3ZMVDm1AVd6kHCs8u0qRwDmqS02aZUnA7DlhlUPPj6QjbNNkC3
         a+ImcYMOjILsuXRZ6hJUOFHTcyBnqhQH/TxOaYKBs0qhUuK3R04YL9oa7zp1HiT9Yzjq
         5x9JkMwVTPgUcFbNdq8I9gUSH+rPfLEZgk+3scg/AQ3W/4tYr60jkTWurl6ozeAo2jzM
         khFaxl5svuz8sNmDY9yug7HyKgx4NpgsjkIXP0bYPrEJqA9h1uDlZ8lM/P/tBy4Ugt2n
         C/k6OGdKx54xCJZ6kePdrBgxzp5Kv0RzPQwr0erX1g+ClUEwZpbhbjQIxGVvl5HW7KRa
         37yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449800; x=1789054600;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ShvhKa6MyfZ1jEWheQQ6SuhEnn7upG8Sh84fZvzR0n8=;
        b=IHbX5qATtpKXsU8XYeJtA5NLBKfACll5w0hExUdNpg0ma1EBkAOx9R/y4qqOcxi8Dc
         6ASFwt2BoTwV5zsc2TpO3dMfzvwp/BFXcMDuaYYCET+UCZkvlVeqSEwHKLeOaW5LGTvH
         p73d26n9gVYDyxeKjYcTO8NsKsoFJ6KX7pcbt1mjw4FiEqnKoTiG6+7as+KfmeM0bPOA
         4QHk25ihqMvTYYkZij2TeO0Gpwa0GPxsV+i7foKoHRleS+cdArqFa3+c2oLsXXmdlhkG
         DoPtTb+xMh041wPyXVW7bZUDW+ZTNzE9jFz0ILFqbTkbK0wzKdAaTvRCCPgikxaYP6q4
         UjwA==
X-Forwarded-Encrypted: i=1; AKwUvBz2y4nhfkf/2RrujVAhc3gd7Vg8eWmF3aZY7fBJJ/mAl9gqrUWHpITlCqjCRoegmgqkZ/1IVvITltmnQo5G6A==@vger.kernel.org
X-Gm-Message-State: AFuF++nIfe+sY/4LKr/V9T3rqzcz92uJUy5+92KlUjnL0TLkUAhX96Ia
	0R8xp9wSn7KezFtxBbEX7rL6ofQOBw8XStCe/IrA8r4/GIF3VO1YX5nZh9aw
X-Gm-Gg: AYBFou2xY7+YvhHCzDk1TgqzS0uqLocmOgiFgyOy/xeKOqYxq/1N3vRDjF5ero+jiVK
	xvfFDTcYhscUwFima9PXBLS7q+ZDz6FnzVtkzCDaRI2FAg8sVI4xRWbW3fn/zAHtGSRzhZvkROv
	/wAupPnROwS1dCw4HvTuyMIzhBzoYLgtiQh6NlzIwE79Wq5oF26CRNO0arEWygGPqjeqHbVJxQP
	Ppv+4mFS9Pbbs8xXJB5Bm3I3EbNPmJLywthK8zbvM6EgJ9Oo29kTwY75hfycCXRn9iGVqeqECy5
	AGkjKb0xj6WuQ3Lpbeo0O5x5DVKaTIFEyGlTwjbMIHHLpVhh+gnbH5zEunLpxjPiUJQacXmtxJS
	rNSYjv/b/IbXKLA8LYT89TvgStlgZ4wd2GXVu07+6d/tgbebIcoSuJQrRjIXiqaROU1tccHghTE
	JIpFyKXNaGjAKbsd8aSm2HHlxsFNcd67viSSs/mIzNeDyaELVsTXCJmR7zBKoEbdc7kY0/zzMJs
	EkkvYmpDySn2IBQTyb3CrnuJ2fHfRoqdoFYJCrB+cjGmkZ0mC2y+mFXliBjf5BwzVUUv0fQzH4l
	szmJIoJ+32a2EWU=
X-Received: by 2002:a05:600c:3495:b0:49c:ee36:10fc with SMTP id 5b1f17b1804b1-49cee361162mr166580795e9.8.1788449799511;
        Thu, 03 Sep 2026 08:36:39 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce831af89sm75568425e9.1.2026.09.03.08.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:36:39 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] wifi: ath9k: skip the departing channel's noise floor on USB fast changes
Date: Thu,  3 Sep 2026 18:36:17 +0300
Message-ID: <20260903153617.990995-6-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
References: <20260903153617.990995-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_hw_reset() reads the noise floor of the channel it is leaving so
that channel's calibration history stays current. The readout is several
register reads, which on the USB devices are as many synchronous WMI
round trips, and a frequency-hopping monitor pays them on every hop for
a value that only matters if the radio returns to that channel later.

Leave the readout out when a fast channel change is asked for on a USB
device. Periodic calibration refreshes the history while a channel is in
use, and the arriving channel's noise floor is loaded either way, so
only a channel that is left and revisited without calibrating in between
sees an older history.

Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d204cdf3fa8f..64fefbec46d5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1878,7 +1878,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
-	if (ah->curchan && !ah->chip_fullsleep)
+	/*
+	 * Over USB the departing channel's noise-floor readout costs several
+	 * round trips and only feeds its history; the fast path reloads the
+	 * arriving channel's noise floor regardless.
+	 */
+	if (ah->curchan && !ah->chip_fullsleep &&
+	    !(fastcc && common->bus_ops->ath_bus_type == ATH_USB))
 		ath9k_hw_getnf(ah, ah->curchan);
 
 	ah->caldata = caldata;
-- 
2.55.0

