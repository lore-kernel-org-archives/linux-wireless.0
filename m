Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7AD3B42F7
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 20:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784925217; cv=none; b=NJPkg8YZoMdDO2GTt2W6UL0Gre0jOMcCfURWwOcALvVFljFWcZ9h8dk0JPu7M73bEbb+hgrzKZO1I8ZYMK15oFjeCUHeioz2tYt5GI6JWYPrRGF3bSNhByU4Cb7oaoqfOI1a58Ec4sosnbJiR9gAUjLACTmQQ8g8Obx2+tUfsV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784925217; c=relaxed/simple;
	bh=br95Se9rDFmKXXxrvhp0Grrr61ZBeG24/7gmFfXUuk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anLOOO0SzNjAWuZnX5gwshuCsstyIOUdelSBN3lOvfsKrtanijpGv90lhQU2AfmkwS2esByjiqODMnzGeFI5IWIADc5n+IjBjiiKhXuQWPCNsjHHUiMv8HFRbO46ThG3KUOl51IrvlLypT/O/a0pZs+wkFyw0QeBXdFDbNMGZwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YMiXu65d; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMiXu65d"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38deea72eebso986518a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784925216; x=1785530016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+jM4hsjMFOnRF0dUppd0CYr7puRKriRYBY16Q14Jrnk=;
        b=YMiXu65d5km0xFkJxYjriFiA7jJWAB6uHGOW6DKHx7jN0qR0UMXnW+sln6weoO/cKY
         0lS0WYBdu5wVJRG4QxyxWTOLrDIU0ZtXXvt0VbDCeLH7IGFrmR9d76iCr4rADRFWpacM
         3sde/ceikl4DWrISyrDt0C+4MIMe33JaHprVrgBu1biVpODA3uWwN7hcZCqHs1DJw5jO
         XWcBGUGmn72q5vpJZYFRiSXh1j9GFJl3VfA1+0KMkSf9/N92S08DdBv+269mom16k4Lc
         gyISbeRQgs7bsPmdVmd9P0DFSdrtb7QY0JJs3sz0iHgE66ZNLbGYWpNVnpbdhJfBEtuH
         KbBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784925216; x=1785530016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+jM4hsjMFOnRF0dUppd0CYr7puRKriRYBY16Q14Jrnk=;
        b=ALylUH5QktXBhm5ETghfKnIzGBXn3Jjxb4gEOMwbd32bJc/503ToJRLcTw3jZTcohG
         +6CZE8CUdkV4i81sCK+FlzIzGp3Hcqph6ojFGfekBh5c7f5ARQg0zmcHV/cTpDqeiIbp
         dJmDSGJCvwS6gS8IYMh0Ja0Pb0hCXH2Bz3Vy0UobQ79YW9sdYxXxSbvMLdJ2J0ysNC4g
         6i+QjqX6ThNvYrThzxFjWQjl1FUOp/N0jNBn3pp15hNhHqQtHTjJnZaHRK1PbXy7MDFR
         emDC6Mw5m8z7mgth+k2ST+TKvMtPYJZjbUur/0Q6Ki/m7RSrZvsGXb6HOJvrDmn/cRlK
         lYog==
X-Forwarded-Encrypted: i=1; AHgh+Rp6lyot9ynJkiAahJ8myYC08R5zOnrfwnVbJ8USZvVr8RodYqZtBPmWKafBYpf6iZ4YCcZo6+aRpmsonftI8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2CQLjyP+ftoKFoCmqSOaouhQjww+XG0H8FCLJt2u6B1PkHpw0
	Oo8/zIGNmmIYAAxS7KWyFf+4SJ5BQE0X17Pgmu4BGChEqvEdLJt8Zc6v
X-Gm-Gg: AR+sD13VZLGB69kCTZPFXS/FggtU87uyIaqWUf5AOK3d43UtwQV2kbWom1u7ne13J7p
	qfKCRyatc/4OlLgbzSN0btm/QzqY1aF6DXClrfbX7DNQblgFtFL1km2Ym63OyiecKwskj1CzmIv
	y4n8MwqDRNWgFRpm8ND7fb3eM7CJrp2JwcTQqgkhKdfnQSC2+JATJYMwfGMdEiFWjFLkcN0+eDH
	EIED7P3g2098aMlBYGmIc4F+MAX7aCKULh5O4amdzvsuwYnRM8V1/z6HrfeBe6fOwNRp8fKhTJ5
	G+8Z5KJ1sTpjrK5+DbRbVMt/6p5VI8zWBoptC3xV8eaCbsUZxoXBiO2rUHGzwoslhPmzzZ7hvDu
	vwG6bWnXq5XQrWwKAKsA88jHMijInaUuOSGACgeCTcWOrcV37CwVc1T/PlYUszaYXJ5SNy4Tg9U
	1UnJup5bmXkhTSz/RATfXVjMHBveaE2qjDQH+sF2MKniTi3AZnCDMh/+HiUCfq5A==
X-Received: by 2002:a17:90b:35ce:b0:37f:9ce1:cdb1 with SMTP id 98e67ed59e1d1-38ec65ae0eemr8221526a91.31.1784925215814;
        Fri, 24 Jul 2026 13:33:35 -0700 (PDT)
Received: from fabio-X870-EAGLE-WIFI7.. ([2804:1b3:a801:60b4:ddf8:a4ba:150b:5c93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm48918684c88.2.2026.07.24.13.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 13:33:35 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: johannes.berg@intel.com
Cc: briannorris@chromium.org,
	francesco@dolcini.it,
	linux-wireless@vger.kernel.org,
	Fabio Estevam <festevam@nabladev.com>
Subject: [PATCH 2/2] wifi: mwifiex: Remove WQ_HIGHPRI from main workqueue
Date: Fri, 24 Jul 2026 17:33:20 -0300
Message-ID: <20260724203320.78793-2-festevam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724203320.78793-1-festevam@gmail.com>
References: <20260724203320.78793-1-festevam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@nabladev.com>

The MWIFIEX_WORK_QUEUE handles command and event processing, including
the commands used for scheduled scans.

Running this work on the high-priority worker pool can interfere with
latency-sensitive workloads. On an i.MX8MP-based audio system using an
88W8997, background scheduled scans caused audible glitches in USB
audio playback.

Remove WQ_HIGHPRI from the main workqueue so that command and scan
processing use the normal-priority worker pool.

Leave the RX and host MLME workqueues unchanged.

Signed-off-by: Fabio Estevam <festevam@nabladev.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index a8eab6b1e63b..c8df3edff675 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1550,7 +1550,7 @@ mwifiex_reinit_sw(struct mwifiex_adapter *adapter)
 
 	adapter->workqueue =
 		alloc_workqueue("MWIFIEX_WORK_QUEUE",
-				WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+				WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
 	if (!adapter->workqueue)
 		goto err_kmalloc;
 
@@ -1716,7 +1716,7 @@ mwifiex_add_card(void *card, struct completion *fw_done,
 
 	adapter->workqueue =
 		alloc_workqueue("MWIFIEX_WORK_QUEUE",
-				WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+				WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
 	if (!adapter->workqueue)
 		goto err_kmalloc;
 
-- 
2.43.0

